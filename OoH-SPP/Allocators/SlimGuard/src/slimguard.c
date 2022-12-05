/*  slimguard.c
 *  SlimGuard
 *  Copyright (c) 2019, Beichen Liu, Virginia Tech
 *  All rights reserved
 */

#include "slimguard.h"
#include "slimguard-large.h"
#include "sll.h"
#include "debug.h"
#include "slimguard-mmap.h"

#include <assert.h>
#include <err.h>
#include <pthread.h>

#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
///////////////////////////
typedef struct cls_t{
  void* bucket[BKT];
  uint64_t dist[BKT];        // array for randomization and OP entropy
  void* start;              // start address of a size class
  void* stop;               // stop address of a size class
  void* current;            // bumper pointer
  void* guardpage;          // last guard page
  sll_t* head;              // head of the free list
  uint64_t bitmap[ELE>>6];  // bitmap
  pthread_mutex_t lock;
  uint32_t size;            // size of current sizeclass
  /*###################################*/
  //uint32_t nb_gp;           // to count the total #GP added during the workload -> we will substract it to the total consumption
//   int distance;
//   uint32_t allocated; //#slots allocated to app: avoid doing a large arithmetic division to compute this number for the mean distance
  uint32_t gp; //#slots alloués depuis la dernière GP
//   uint64_t wss;
} cls_t;

#ifdef RELEASE_MEM
uint16_t *page_counter[INDEX];
#endif

cls_t Class[INDEX];
uint32_t seed = 0;
pthread_mutex_t global_lock;

enum pool_state{null, init} STATE;

/* *Really* minimal PCG32 code / (c) 2014 M.E. O'Neill / pcg-random.org
 * See license for pcg32 in docs/pcg32-license.txt */
typedef struct { uint64_t state;  uint64_t inc; } pcg32_random_t;
__thread pcg32_random_t rng = {0x0, 0x0};

uint32_t pcg32_random_r(void) {
    uint64_t oldstate = rng.state;
    // Advance internal state
    rng.state = oldstate * 6364136223846793005ULL + (rng.inc|1);
    // Calculate output function (XSH RR), uses old state for max ILP
    uint32_t xorshifted = ((oldstate >> 18u) ^ oldstate) >> 27u;
    uint32_t rot = oldstate >> 59u;
    return (xorshifted >> rot) | (xorshifted << ((-rot) & 31));
}

/* convert a size to its corresponding size Class */
uint8_t sz2cls(uint32_t sz) {

    if (sz >= (1 << 17))
        return 255;

    if (sz < 128) {
        return ((sz>>(SLI_LOG2-1)) + ((sz&0x7) ? 1:0 ));
    } else {
        return ((((log2_64(sz)-MIN_EXP) << SLI_LOG2) |
                 ((sz>> (log2_64(sz)-SLI_LOG2))& ~(1 << SLI_LOG2)))
                 + ((((1<<(log2_64(sz)-SLI_LOG2)) - 1) & sz) ? 1:0 ));
    }
}

/* Find the size given a index */
uint32_t cls2sz(uint16_t cls) {
    if (cls < 16) {
        return (cls << (SLI_LOG2-1));
    } else {
        uint8_t shift = (cls >> SLI_LOG2) + 6;
        return ((1U<<shift) + ((cls & ((1U<< SLI_LOG2)-1))<<(shift-SLI_LOG2)));
    }
}

/* round the sizeup with the aligment */
uint32_t round_sz(uint32_t sz) {
    return ((sz + ALIGN) &(~ALIGN));
}

/* SlimGuard initialization */
void init_bibop() {
    rng.state = time(NULL);
    rng.inc = time(NULL);

    //Debug("Entropy %d\n", ETP);

#ifdef USE_CANARY
    seed = pcg32_random_r();
#endif

    for (int i = 0; i < INDEX; i++) {
        Class[i].start = NULL;
    }

    STATE = init;
}

/* Initialize each size class, fill in per size class data structure */
void init_bucket(uint8_t index) {
    if (Class[index].start == NULL) {
        /* If the size class manage a power of two, make sure that each slot is
         * aligned to the power of two in question. This is useful to manage
         * alignment requirements, see comments in xxmemalign */
        uint32_t align = 0;
        uint32_t sz = cls2sz(index);
        if(sz > PAGE_SIZE && (sz & (sz - 1)) == 0)
            align = sz;

        void* addr = slimguard_mmap(BUCKET_SIZE, align); // bucket start addr
        if(!addr)
            errx(-1, "Cannot allocate class %d data area\n", index);
        
        /*###################################*/
        // Class[index].wss = 0;
        Class[index].gp = 0;
        // Class[index].nb_gp = 0;
        // Class[index].distance = 0;  
        // Class[index].allocated = 0;
        /*###################################*/
        Class[index].head = NULL; // head of the sll contains free pointers
        Class[index].start = addr; // start address of the current bucket
        Class[index].current = Class[index].start; // bumper pointer
        Class[index].stop = (void *)((uint64_t)addr + BUCKET_SIZE); // upper
                                                                    // bound
        Class[index].size = cls2sz(index); // the size for current bucket
        Class[index].guardpage = (void*) ((uint64_t) 0);
        for (int i = 0; i < BKT; i++) {
            Class[index].bucket[i] = get_next(index, i);
        }

        // Debug("BKT %d size: %d, start: %p\n", BKT, Class[index].size,
        //         Class[index].start);

#ifdef RELEASE_MEM
        page_counter[index] = (uint16_t *)slimguard_mmap(4<<20, 0);
        if(!page_counter[index])
            errx(-1, "Cannot allocate mem. for class %d page counter\n", index);
#endif

        // Debug("index: %u size: %u %p %p %p\n", index, Class[index].size,
        //         Class[index].start, Class[index].stop, Class[index].current);
    }
}

/* get next slot to fill in the bucket */
void *get_next(uint8_t index, int position)
{
    void *ret; 

    if(Class[index].gp == 0);
    {
        //calculer la distance de sécu de ret
        //det the next gp
        void *next_gp = (void *)((uint64_t)Class[index].current + GP * Class[index].size);
        if( (uint64_t)next_gp % PAGE_SIZE != 0 )
            next_gp = (void*) ((((uint64_t) next_gp >> 12) + 1) << 12);
        Class[index].guardpage = next_gp;
    }
    Class[index].gp++;
    ret = (void *)((uint64_t)Class[index].guardpage - (uint64_t)(Class[index].gp * Class[index].size));
    
    // Class[index].current = (void *)((uint64_t)Class[index].current + (uint64_t)Class[index].size);
    // if(Class[index].current >= Class[index].stop){
    //     Error("not enough mem %u\n", Class[index].size);
    //     exit(-1);
    // }

    Class[index].dist[position] = (uint64_t)Class[index].guardpage - ((uint64_t)ret + Class[index].size);
    //Debug("malloc %lu gp %d dist %lu\n", cls2sz(index), Class[index].gp, Class[index].dist[position]);
    /////////////////////////////////

    if (Class[index].gp >= GP) 
    {
        Class[index].gp = 0;

        if (mprotect(Class[index].guardpage, PAGE_SIZE-1, PROT_NONE) == 0) {
            // for(int prev = GP-1; prev >= 0; prev--)
            //     Class[index].distance += ((uint64_t)Class[index].guardpage - ((uint64_t)Class[index].current - prev*Class[index].size));
            //Class[index].nb_gp++;
            Class[index].current = (void*) ((((uint64_t) Class[index].guardpage >> 12) + 1) << 12);
        } else {
            perror("mprotect");
            exit(-1);
        }
        if(Class[index].current >= Class[index].stop || ret < Class[index].start){
            Error("not enough mem %u\n", Class[index].size);
            exit(-1);
        }
    }
    return ret;
}

/* select a random object in a bucket */
void* get_random_obj(uint8_t index) {
    uint16_t i = pcg32_random_r() % BKT;
    void *ret = Class[index].bucket[i];
   // Debug("Slim+GP: malloc_class %lu secu_dist %lu\n", cls2sz(index), (uint64_t)Class[index].dist[i]);

    if (!ret) {
        Error("%p %p\n", Class[index].current, Class[index].start);
        Error("Cannot get next object for class size(%x)\n\n", index);
        abort();
    }

    Class[index].bucket[i] = get_next(index, i);

    return ret;
}

/* Hash a pointer to get canary value */
char HashPointer(const void* ptr) {
    long long Value = (long long)ptr;

    Value = ~Value + (Value << 15);
    Value = Value ^ (Value >> 12);
    Value = Value + (Value << 2);
    Value = Value ^ (Value >> 4);
    Value = Value * seed;
    Value = Value ^ (Value >> 16);

    return (char)Value;
}

/* put the canary to the end of each block, set it to MAGIC NUMBER */
void set_canary(void * ptr, uint8_t index) {
    char* end = (char *)((unsigned char *)ptr + Class[index].size - 1);
    *end = HashPointer(ptr);

#ifdef DEBUG
    //Canary("[%p] %p %x %u\n", ptr, end, *end, index);
#endif
}

/* check the canary value */
void get_canary(const void *ptr, const uint8_t index) {
    char *end = (char *)((unsigned char *) ptr + Class[index].size - 1);

#ifdef DEBUG
    //Canary("[%p] %p %x\n", ptr, end, *end);
#endif

    if(*end != HashPointer(ptr)) {
        Error("buffer overflow occured at %p, exiting now\n", ptr);
        Error("%x\n", HashPointer(ptr));
        Error("[%p] %p %x %u %u\n", ptr, end, *end, Class[index].size, index);
        exit(-1);
    }
}

/* mark the bit map as "used" */
void mark_used(void *ptr, uint8_t index) {
    uint64_t i = (uint64_t)((char*)ptr -
            (char*)Class[index].start) / Class[index].size;
    uint32_t bitmap_index = i >> 6;
    uint8_t shift = i % (1<<6);

    Class[index].bitmap[bitmap_index] |= (1UL << shift);
    Debug("i: %lx bit: %u shift %u bitmap: %lx\n", i, bitmap_index, shift,
            Class[index].bitmap[bitmap_index]);
}

/* mark the bit map as "free" and check for potential vulunerabilities */
void mark_free(void *ptr, uint8_t index) {
    uint64_t i = (uint64_t)((char*)ptr - (char*)Class[index].start) / Class[index].size;
    uint32_t bitmap_index = i >> 6;
    uint8_t shift = i % (1<<6);

    if((Class[index].bitmap[bitmap_index] & (1UL << shift)) == 0) {
        Error("Double Free or Invalid Free @ %p\n", ptr);
        abort();
    }

    Class[index].bitmap[bitmap_index] &= ~(1UL << shift);
    Debug("i: %lx bit: %u shift %u bitmap: %lx\n", i, bitmap_index, shift,
            Class[index].bitmap[bitmap_index]);
}

#ifdef RELEASE_MEM
/*
 * if release_mem is defined, we will setup an array of counter,
 * each counter stores the number of object in a page, once this
 * number becomes 0, we will release the memory back to Operating System
 */
void increment_pc(void *ptr, uint8_t index) {
    uint64_t curr_page = ((uint64_t )ptr >> 12) <<12;
    uint16_t obj_size = Class[index].size;
    uint16_t *pc, pc_index;

    do {
        pc_index = (curr_page - (uint64_t)Class[index].start)/PAGE_SIZE;
        pc = (uint16_t *)((uint64_t)page_counter[index] + pc_index*sizeof(uint16_t));
        *pc = *pc + 1;
        curr_page += PAGE_SIZE;
    } while((uint64_t) ptr+obj_size >= curr_page);

  //Debug("[%u]: %p \n", index, ptr);
}

void decrement_pc(void *ptr, uint8_t index) {
    uint64_t curr_page = ((uint64_t )ptr >> 12) <<12;
    uint16_t obj_size = Class[index].size;
    uint16_t *pc, pc_index;

    do {
        pc_index = (curr_page- (uint64_t)Class[index].start)/PAGE_SIZE;
        pc = (uint16_t *)((uint64_t)page_counter[index] + pc_index*sizeof(uint16_t));
        *pc = *pc - 1;

        if (*pc == 0)
            madvise((void *)curr_page, PAGE_SIZE-1, MADV_DONTNEED);

        curr_page += PAGE_SIZE;
    } while((uint64_t) ptr + obj_size >= curr_page);
}
#endif

/* given a pointer find the corresponding size class */
uint16_t find_sz_cls(const void *ptr) {
    static __thread int last_index = 0;

    for(int i=last_index; i<INDEX; ++i) {
        if(((uint64_t)Class[i].start <= (uint64_t)ptr) &&
           ((uint64_t)Class[i].start+BUCKET_SIZE > (uint64_t)ptr)){
            last_index = i;

            return i;
        }
    }

    for(int i=0; i<last_index; ++i) {
        if(((uint64_t)Class[i].start <= (uint64_t)ptr) &&
           ((uint64_t)Class[i].start+BUCKET_SIZE > (uint64_t)ptr)){
            last_index = i;

            return i;
        }
    }

    return 255;
}

int log2_64 (uint64_t u) {
  if (u == 0) { return INT32_MIN; }
  return ((int64_t)63 - (int64_t)__builtin_clzll(u));
}

/* SlimGuard malloc algorithm */
void* xxmalloc(size_t sz) { //modify to consider sz as the class_sz for consumption eval
#ifdef USE_CANARY
    sz++;
#endif

    uint64_t need = 0;
    void *ret = NULL;
    uint8_t index = 255;
    need = round_sz(sz);

    /* Can happen if sz is large enough */
    if(!need)
        return NULL;

    if (need >= (1 << 17)) {
        //Debug("sz %lu\n", need);
        ret = xxmalloc_large(need, 0);
    } else {
        if (STATE == null) {
            /* Lock here */
            pthread_mutex_lock(&global_lock);
            init_bibop();
            pthread_mutex_unlock(&global_lock);
            /* Lock end */
        }

        index = sz2cls(need);

        if (index == 255) {
            perror("sz2cls");
            return NULL;
        }

    /* Lock here */
    pthread_mutex_lock(&(Class[index].lock));

    if (Class[index].start == NULL)
       {init_bucket(index); }

    if (Class[index].head && Class[index].head->next) { 
        ret = Class[index].head;
        Class[index].head = remove_head(Class[index].head);
    } else {
        ret = get_random_obj(index);// 
        // Class[index].allocated++;
        // Class[index].wss += sz;
    }
    // Class[index].allocated++;
    // Class[index].wss += sz;

#ifdef RELEASE_MEM
    increment_pc(ret, index);
#endif
//    mark_used(ret, index);

    pthread_mutex_unlock(&(Class[index].lock));
    /* Lock end */

#ifdef USE_CANARY
    set_canary(ret, index);
#endif
}

  return ret;
}
/* SlimGuard free */
 void xxfree(void *ptr) { //modify to consider class_sz instead of ptr, to compute the total number of pages used
    // uint64_t end, start, usage, secu; 
    // uint32_t gp;
    // uint16_t fd;
    //char buf[255], file[50];
    uint8_t index = 255;

    if (ptr == NULL)
        return;

    index = find_sz_cls(ptr);

    if (index == 255) {
        int i = xxfree_large(ptr);

        if (i == 1) {
            return;
        } else if (i == -1) {
            Error("invalid free/double free %p\n", ptr);
            abort();
            return;
        }
    }

    // end = (uint64_t)Class[index].current;
    // start = (uint64_t)Class[index].start;
    // gp  = Class[index].nb_gp;

#ifdef USE_CANARY
    get_canary(ptr, index);
#endif

#ifdef DESTROY_ON_FREE
    memset(ptr, 0, Class[index].size);
#endif

    /* Lock here */
    pthread_mutex_lock(&(Class[index].lock));
#ifdef RELEASE_MEM
    decrement_pc(ptr, index);
#endif
    Class[index].head = add_head((sll_t *)ptr, Class[index].head);
//    mark_free(ptr, index);
    pthread_mutex_unlock(&(Class[index].lock));
    /* Lock end */

    // int factor;
    // if (cls2sz(index) < PAGE_SIZE)
    //     factor = PAGE_SIZE;
    // else
    //     if (cls2sz(index) % PAGE_SIZE == 0)
    //         factor = cls2sz(index);
    //     else
    //         factor =(cls2sz(index)/PAGE_SIZE + 1)*PAGE_SIZE;

    // usage = Class[index].allocated * factor; //end-start-gp*PAGE_SIZE;//

    // memset(file,0,sizeof(file));
    // sprintf(file,"../logs/logs_CLASS%u_GP%u", index, GP);
    // fd = open(file, O_CREAT | O_APPEND | O_RDWR, 0777);

    // memset(buf,0,sizeof(buf));
    // sprintf(buf,
    //       "stdGP_Mem_Usage (KB) : %lu\n"
    //       "stdGP_Mean_Distance (KB) : %f\n", usage >> 10, (Class[index].distance >> 10)*1.0/Class[index].slots);
    // write(fd,&buf,sizeof(buf));
    // close(fd);
    
    //Debug("Conso(KB) Real_wss(KB): %lu %lu\n", conso >> 10, wss >> 10);
    //Debug("(Size #buff #GP Conso(KB) Real_wss(KB)): %d %d %d %lu %lu\n", cls2sz(index), Class[index].allocated, Class[index].nb_gp, usage >> 10, Class[index].wss >> 10);
    //Debug("(Size Conso(KB) Real_wss(KB)): %d %lu %lu\n", cls2sz(index), usage >> 10, Class[index].wss >> 10);
}   

void* xxrealloc(void *ptr, size_t size) {

#ifdef USE_CANARY
    size++;
#endif
    uint8_t index1, index2;
    void* ret = ptr;

    if(ptr == NULL)
        return xxmalloc(size);

    if(size == 0) {
        xxfree(ptr);
        return NULL;
    }

    index1 = find_sz_cls(ptr); // old size
    index2 = sz2cls(size); // new size

    size_t size1 = (index1 == 255) ?
                   get_large_object_size(ptr) : Class[index1].size;

    if( index2 >= index1) {
        ret = xxmalloc(size);
        memcpy(ret, ptr, (size1 < size) ? size1 : size);
        xxfree(ptr);
    }

    return ret;
}

void* xxmemalign(size_t alignment, size_t size) {
    /* Here we use a small trick, for power of 2 sizes, each slot in the data
     * area is aligned to a multiple of its size so if alignment is larger than
     * size, we just malloc alignment to give it an address, if alignment is
     * smaller than size, we round the size to the next power of 2. When the
     * size needed cannot be managed as a small allocation, we use a large one
     * with alignment constraint.
     */

    if(alignment &(alignment-1)){
        Error("%lu is not a valid alignment, %s fails...\n", alignment, __func__);
        exit(-1);
    }

#ifdef USE_CANARY
    size++;
#endif

    if(alignment >= size) {
        if (alignment < (1 << 17))
            return xxmalloc(alignment-1);
        else
            return xxmalloc_large(alignment, alignment);
    } else {
#ifdef USE_CANARY
        uint64_t need = (1 << ((uint8_t)log2_64(size) + 1))-1;
        int need_large = (need+1) >= (1 << 17);
#else
        uint64_t need = (1 << ((uint8_t)log2_64(size) + 1));
        int need_large = (need) >= (1 << 17);
#endif
        if(need_large)
            return xxmalloc_large(need, alignment);

        return xxmalloc(need);
    }
}

/* Only used for tests, with LD_PRELOAD and malloc_hooks calloc calls are
 * automatically translated to malloc calls */
void * xxcalloc(size_t nmemb, size_t size) {
    void *ret;

    ret = xxmalloc (nmemb * size);
    if (!ret)
        return ret;

    bzero (ret, nmemb * size);
    return ret;
}

/* high level SlimGuard API that is called by gnuwrapper */
void* slimguard_malloc(size_t size) {
  return xxmalloc(size);
}

void slimguard_free(void *ptr) {
  xxfree(ptr);
}

void* slimguard_realloc(void *ptr, size_t size) {
  return xxrealloc(ptr, size);
}

void* slimguard_memalign(size_t alignment, size_t size) {
  return xxmemalign(alignment, size);
}

