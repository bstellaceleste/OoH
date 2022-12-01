// #include <stdint.h>
// #include <unistd.h>
// #include <stdbool.h>
// #include <stdio.h>
// #include <stdlib.h>
// #include <unistd.h>
// #include <fcntl.h>
// #include <errno.h>
// #include <string.h>
// #include <sys/types.h>
// #include <sys/stat.h>
// #include <sys/mman.h>
// #include <sys/sysinfo.h>
// /******************/
// #define cpu get_nprocs_conf()
// /******************/
// #define UIO_DEVICE "/dev/uio0"
// #define PID_FLAG 0xFFFFFFFF00000000
// #define is_flag(x) (x & PID_FLAG) == PID_FLAG
// #define get_pid(x) x & ~PID_FLAG
// #define SIZE (1u << 19)
// #define SIZE_PT (1u << 22)
// #define FILE_BUF 25

// static unsigned long *pmap_phys_add, *pmap_virt_add;
// static unsigned long pmap_count;
// unsigned long *pml_add, pml_nb_entries, *list_dirty; //

// static void sort(unsigned long *arr)
// {
//     unsigned long i = 0, j = 0, temp = 0;
//     while (i < pml_nb_entries && arr[i] != 0)
//     {
//         j = i + 1;
//         while (j < pml_nb_entries && arr[j] != 0)
//         {
//             if (arr[i] > arr[j])
//             {
//                 temp = arr[i];
//                 arr[i] = arr[j];
//                 arr[j] = temp;
//             }
//             j++;
//         }
//         i++;
//     }
// }

// static unsigned long *sort_unique(unsigned long *arr)
// {
//     unsigned long i, j, count, *array1 = xzalloc(SIZE);

//     i = j = count = 0;
//     memset(array1, 0, SIZE);

//     while (i < pml_nb_entries && arr[i] != 0)
//     {
//         for (j = 0; j < count; j++)
//         {
//             if (arr[i] == array1[j])
//                 break;
//         }
//         if (j == count)
//         {
//             array1[count] = arr[i];
//             count++;
//         }
//         i++;
//     }

//     sort(array1);

//     return array1;
// }


// static unsigned long belongs_to_app(unsigned long add, unsigned long *list_add) // return the index, in dirty array, of the va corresponding to add
// {
//     unsigned long i = 0;

//     if (list_add)
//     {
//         do
//         {
//             if (list_add[i] == add) //{ //list_add[i] == add
//                 return i;           //}
//         } while (i < pmap_count && list_add[i++] != 0);
//     }
//     return -1;
// }

// /*
//  * Parsing /proc/$pid/maps and for each address, parse /proc/$pid/pagemap
//  */
// static void parse_proc_pagemap(unsigned int pid, unsigned long a_start, unsigned long a_end)
// {
//     char pagemap_path[FILE_BUF];
//     unsigned long pagemap_file_fd;

//     snprintf(pagemap_path, FILE_BUF, "/proc/%d/pagemap", pid);

//     /* On ouvre les fichiers */
//     pagemap_file_fd = open(pagemap_path, O_RDONLY);
//     if (pagemap_file_fd < 0)
//     {
//         perror("fopen");
//         exit(EXIT_FAILURE);
//     }

//     /* Pour chacune des adresses virt. dans la plage start-end, nous lisons l'adresse physique correspondante dans pagemap */
//     for (uint64_t page = a_start; page < a_end; page += PAGE_SIZE)
//     {
//         uint64_t data, offset = (page / PAGE_SIZE) * sizeof(data); //, gpa;//, page_offset = page % PAGE_SIZE;

//         if (pread(pagemap_file_fd, &data, sizeof(data), offset) < 0)
//         {
//             perror("pread");
//             exit(EXIT_FAILURE);
//         }

//         if ((data >> 63) & 1) // if the page is present
//         {
//             pmap_phys_add[pmap_count] = (data & 0x7fffffffffffff);
//             // gpa = pmap_phys_add[pmap_count] * PAGE_SIZE + offset;
//             // pr_debug("gfn_pgemap : %lx - gpa_pgemap : %lx\n", pmap_phys_add[pmap_count], gpa);
//             pmap_virt_add[pmap_count] = page;
//             pmap_count++;
//         }
//     }

//     close(pagemap_file_fd);
// }

// static void parse_proc_maps(unsigned int pid)
// {
//     char maps_path[FILE_BUF];
//     char *line_buf = NULL, *line_buf_dup, *addr_start, *addr_end;
//     FILE *maps_file;
//     size_t size_line_buf = 0;
//     ssize_t size_line;

//     /* On construit les chemins vers le fichier maps */
//     snprintf(maps_path, FILE_BUF, "/proc/%d/maps", pid);

//     /* On ouvre le fichier */
//     maps_file = fopen(maps_path, "r");
//     if (maps_file == NULL)
//     {
//         perror("fopen");
//         exit(EXIT_FAILURE);
//     }

//     pmap_count = 0;
//     pmap_phys_add = xzalloc(SIZE_PT);
//     pmap_virt_add = xzalloc(SIZE_PT);

//     /* On parcourt /proc/maps ligne par ligne */
//     while ((size_line = getline(&line_buf, &size_line_buf, maps_file)) != -1)
//     {
//         uint64_t start, end;
//         /*
//          * Chaque début de ligne est sous la forme addr_start-addr_end rw ...
//          * donc on essaie de récupérer addr_start et addr_end
//          */
//         line_buf_dup = strtok(line_buf, " ");   // line_buf_dup points to the first string resulting on the split of the line
//         addr_start = strtok(line_buf_dup, "-"); // now we're spliting the string "addr_start-addr_end"
//         addr_end = strtok(NULL, "-");

//         start = strtoul(addr_start, NULL, 16);
//         end = strtoul(addr_end, NULL, 16);

//         /* Maintenant nous devons parcourir pagemap pour chaque adresse dans la plage start-end */
//         if (start > 0 && end > 0)
//             parse_proc_pagemap(pid, start, end);
//     }

//     free(line_buf);
//     fclose(maps_file);
// }

// static unsigned long *collect_pml_logs(void)
// {
//     unsigned int uioFd;
//     unsigned long *cpu_map, *dirty;
//     unsigned long i, j;
//     unsigned long count = 0, prev, ret = -1;

//     pml_add = xzalloc(SIZE);
//     dirty = xzalloc(SIZE); // MAX_NB_PFN*sizeof(unsigned long)
//     pml_nb_entries = (SIZE / sizeof(unsigned long));

//     // Open uio device
//     uioFd = open(UIO_DEVICE, O_RDWR); //
//     if (uioFd < 0)
//     {
//         pr_perror("Cannot open %s: %s\n", UIO_DEVICE, strerror(errno));
//         // return -1;
//     }

//     // Mmap memory region containing buffer values
//     cpu_map = mmap(0, SIZE, PROT_WRITE, MAP_SHARED, uioFd, 0);
//     if (cpu_map == MAP_FAILED)
//     {
//         pr_perror("Cannot mmap map[%d]: %s\n", uioFd, strerror(errno));
//         close(uioFd);
//         // return -1;
//     }

//     while (count < (pml_nb_entries - 2))
//     {
//         if (is_flag(cpu_map[count]))
//         {
//             unsigned int pid = get_pid(cpu_map[count]);
//             // printf("%lu logs for process : %d\n", cpu_map[count + 1], pid);
//             memcpy(pml_add + count, cpu_map + count + 2, cpu_map[count + 1] * sizeof(unsigned long));
//             cpu_map[count] = ~PID_FLAG;
//             prev = count + 1;
//             count += cpu_map[count + 1] + 2;
//             cpu_map[prev] = 0;
//             parse_proc_maps(pid);
//         }
//         else
//             count++;
//     }

//     // i = 0;
//     // while (i < pml_nb_entries && pml_add[i++] != 0)
//     //     pr_debug("pml_add : %lx\n", pml_add[i]);

//     i = j = 0;
//     while (i < pml_nb_entries && pml_add[i] != 0)
//     {
//         if ((ret = belongs_to_app(pml_add[i++], pmap_phys_add)) > 0 && pmap_virt_add[ret] != 8392706)
//         {
//             dirty[j++] = pmap_virt_add[ret]; 
//             //pr_debug("pml_buff : %lx\n", dirty[j-1] / PAGE_SIZE);
//         }
//     }

//     dirty = sort_unique(dirty);
    
//     // i = 0;
//     // while (i < pml_nb_entries && dirty[i++] != 0)
//     //     pr_debug("dirty : %lx\n", dirty[i]); // virtual pages  / PAGE_SIZE

//     munmap((void *)cpu_map, SIZE);
//     close(uioFd);
//     free(pmap_virt_add);
//     free(pmap_phys_add);

//     return dirty;
// }

// // #include <stdint.h>
// // #include <unistd.h>
// // #include <stdbool.h>
// // #include <stdio.h>
// // #include <stdlib.h>
// // #include <unistd.h>
// // #include <fcntl.h>
// // #include <errno.h>
// // #include <string.h>
// // #include <sys/types.h>
// // #include <sys/stat.h>
// // #include <sys/mman.h>
// // #include <sys/sysinfo.h>
// // /******************/
// // #define cpu             get_nprocs_conf()
// // /******************/
// // #define UIO_DEVICE      "/dev/uio0"
// // #define PID_FLAG        0xFFFFFFFF00000000
// // #define is_flag(x) 	    (x & PID_FLAG)==PID_FLAG
// // #define get_pid(x)	    x & ~PID_FLAG
// // #define SIZE            (1u << 19)
// // #define FILE_BUF        25
// // #define MAX_NB_PFN      300000

// // unsigned long *pml_add, pml_nb_entries, *list_dirty;//

// // static void sort(unsigned long *arr)
// // {
// //     unsigned long i=0, j=0, temp=0;
// //     while (i<pml_nb_entries && arr[i]!=0)
// //     {
// //         j = i+1;
// //         while(j<pml_nb_entries && arr[j]!=0)
// //         {
// //             if(arr[i] > arr[j])
// //             {
// //                 temp = arr[i];
// //                 arr[i] = arr[j];
// //                 arr[j] = temp;
// //             }
// //             j++;
// //         }
// //         i++;
// //     }
// // }

// // static unsigned long *collect_pml_logs(void)
// // {
// //     unsigned long uioFd;
// //     unsigned long *cpu_map;
// //     uint32_t intInfo;
// //     ssize_t readSize;
// //     unsigned long count = 0, prev;

// //     pml_add = xzalloc(SIZE);
// //     pml_nb_entries = (SIZE / sizeof(unsigned long));

// //     // Open uio device
// //     uioFd = open(UIO_DEVICE, O_RDWR); //
// //     if (uioFd < 0)
// //     {
// //         pr_perror("Cannot open %s: %s\n", UIO_DEVICE, strerror(errno));
// //         //return -1;
// //     }

// //     // Mmap memory region containing buffer values
// //     cpu_map = mmap(0, SIZE, PROT_WRITE, MAP_SHARED, uioFd, 0);
// //     if (cpu_map == MAP_FAILED)
// //     {
// //         pr_perror("Cannot mmap map[%d]: %s\n", uioFd, strerror(errno));
// //         close(uioFd);
// //         //return -1;
// //     }

// //     memset(pml_add, 0, SIZE);

// //     // Wait for interrupt
// //     readSize = read(uioFd, &intInfo, sizeof(intInfo));

// //     if (readSize < 0)
// //     {
// //         pr_perror("Cannot wait for uio device interrupt: %s\n",
// //                 strerror(errno));
// //         //return errno;
// //     }

// //     while( count < (pml_nb_entries - 2) )
// //     {
// //         if(is_flag(cpu_map[count]))
// //         {
// //             unsigned long pid = get_pid(cpu_map[count]);
// //             printf("%lu logs for process : %d\n", cpu_map[count + 1], pid);
// //             memcpy(pml_add+count, cpu_map+count+2, cpu_map[count+1]*sizeof(unsigned long));
// //             cpu_map[count] = 0;
// //             prev = count + 1;
// //             count += cpu_map[count + 1] + 2;
// //             cpu_map[prev] = 0;
// //         }
// //         else
// //             count++;
// //     }

// //     munmap((void *)cpu_map, SIZE);

// //     sort(pml_add);

// //     close(uioFd);

// //     return pml_add;
// // }
/*****************************************************************************************************************/

// unsigned long *rm_dup(unsigned long *arr)
// {
//     unsigned long last_dup, last_arr, i;
//     unsigned long *no_dup, size; //no_dup is the final array with no dup_elts

//     if(pml_nb_entries == 0)
//         return NULL;

//     last_dup = last_arr = i = 0; //resp. last index elts of final and initial array
//     size = pml_nb_entries*PAGE_SIZE;

//     no_dup = malloc(size);
//     memset(no_dup, 0, size);

//     while( i < pml_nb_entries )
//     {
//         if( arr[i] == 0 )
//         {
//             i++;
//             continue;
//         }

//         if( arr[i+1] == arr[i] ) 
//         {
//             do{
//                 i++;
//             }while( arr[i+1] == arr[i] );//while there is a list of dup elts, iterate
//             last_arr = i; //get the last elt that was duplicated
//         }

//         if( last_arr >= pml_nb_entries ) //if we are at the en of the array then collect the last elt and end
//             no_dup[last_dup] = arr[last_arr];
//         else
//         {
//             while( (i <  pml_nb_entries) && (arr[i+1] != arr[i]) ) //while elts are different iterate
//                 i++;
//             if( i > last_arr )
//             {
//                 memcpy(no_dup+last_dup, arr+last_arr, (i-last_arr)*sizeof(unsigned long)); //and then copy the block of different elt from the last on that was duplicated
//                 last_dup += (i - last_arr);
//             }
//             else  break;
//         }
//     }
//     pml_nb_entries = last_dup;
//     return no_dup;
// }

// // function to swap elements
// void swap(unsigned long *a, unsigned long *b) 
// {
//   unsigned long t = *a;
//   *a = *b;
//   *b = t;
// }

// // function to find the partition position
// unsigned long partition(unsigned long *array, unsigned long low, unsigned long high) 
// {  
//   // select the rightmost element as pivot
//   unsigned long pivot = array[high];  
//   // pointer for greater element
//   unsigned long i = (low - 1);

//   // traverse each element of the array
//   // compare them with the pivot
//     for (unsigned long j = low; j < high; j++)
//     {
//         if (array[j] <= pivot)
//         {
//             // if element smaller than pivot is found
//             // swap it with the greater element pointed by i
//             i++;
//             // swap element at i with element at j
//             swap(&array[i], &array[j]);
//         }
//     }

//   // swap the pivot element with the greater element at i
//   swap(&array[i + 1], &array[high]);  
//   // return the partition point
//   return (i + 1);
// }

// void quicksort(unsigned long *array, unsigned long low, unsigned long high) {
//   if (low < high) 
//   {
    
//     // find the pivot element such that
//     // elements smaller than pivot are on left of pivot
//     // elements greater than pivot are on right of pivot
//     unsigned long pi = partition(array, low, high);
    
//     // recursive call on the left of pivot
//     quicksort(array, low, pi - 1);    
//     // recursive call on the right of pivot
//     quicksort(array, pi + 1, high);
//   }
// }
/*****************************************************************************************************************/
#include <stdint.h>
#include <unistd.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include <errno.h>
#include <string.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/mman.h>
#include <sys/sysinfo.h>
#include <time.h>
/******************/
#define cpu get_nprocs_conf()
/******************/
#define UIO_DEVICE "/dev/uio0"
#define PID_FLAG 0xFFFFFFFF00000000
#define is_flag(x) (x & PID_FLAG) == PID_FLAG
#define get_pid(x) x & ~PID_FLAG
#define SIZE (1u << 21) //12 15 17 18 19 20 21 
#define SIZE_PT (1u << 22)
#define FILE_BUF 25
/**********************/
#define BILLION  1000000000L

static unsigned long *pmap_phys_add, *pmap_virt_add;
static unsigned long pmap_count;
unsigned long pml_nb_entries, *list_dirty; //
unsigned long *pml_add;

static int belongs_to_app(unsigned long add, unsigned long *list_add)//return the index, in dirty array, of the va corresponding to add 
{
	int i = 0;

    if (list_add)
    {
        do
        {
            if (list_add[i] == add) //{ //list_add[i] == add
                return i;           //}
        } while (i < pmap_count && list_add[i++] != 0);
    }
    return -1;
}

/*
 * Parsing /proc/$pid/maps and for each address, parse /proc/$pid/pagemap
 */
static void parse_proc_pagemap(unsigned int pid, unsigned long a_start, unsigned long a_end)
{
    char pagemap_path[FILE_BUF];
    unsigned long pagemap_file_fd;

    snprintf(pagemap_path, FILE_BUF, "/proc/%d/pagemap", pid);

    /* On ouvre les fichiers */
    pagemap_file_fd = open(pagemap_path, O_RDONLY);
    if (pagemap_file_fd < 0)
    {
        perror("fopen");
        exit(EXIT_FAILURE);
    }

    /* Pour chacune des adresses virt. dans la plage start-end, nous lisons l'adresse physique correspondante dans pagemap */
    for (uint64_t page = a_start; page < a_end; page += PAGE_SIZE)
    {
        uint64_t data, offset = (page / PAGE_SIZE) * sizeof(data); //

        if (pread(pagemap_file_fd, &data, sizeof(data), offset) < 0)
        {
            perror("pread");
            exit(EXIT_FAILURE);
        }

        if ((data >> 63) & 1) // if the page is present
        {
            pmap_phys_add[pmap_count] = (data & 0x7fffffffffffff);
            pmap_virt_add[pmap_count] = page; 
            pmap_count++; 
        }
    }

    close(pagemap_file_fd);
}

static void parse_proc_maps(unsigned int pid)
{
    char maps_path[FILE_BUF];
    char *line_buf = NULL, *line_buf_dup, *addr_start, *addr_end;//, *label[6];
    FILE *maps_file;
    size_t size_line_buf = 0;
    ssize_t size_line;
    uint64_t start, end;
    //unsigned int i = 0;

    /* On construit les chemins vers le fichier maps */
    snprintf(maps_path, FILE_BUF, "/proc/%d/maps", pid);

    /* On ouvre le fichier */
    maps_file = fopen(maps_path, "r");
    if (maps_file == NULL)
    {
        perror("fopen");
        exit(EXIT_FAILURE);
    }

    pmap_count = 0;
    pmap_phys_add = xzalloc(SIZE);
    pmap_virt_add = xzalloc(SIZE);

    /* On parcourt /proc/maps ligne par ligne */
    while((size_line = getline(&line_buf, &size_line_buf, maps_file)) != -1)
    {
        //i = 0;
        /*
         * Chaque début de ligne est sous la forme addr_start-addr_end rw ...
         * donc on essaie de récupérer addr_start et addr_end
         */
        // line_buf_dup = strtok(line_buf, " ");   // line_buf_dup points to the first string resulting on the split of the line
        // label[i++] = line_buf_dup;
        // do//if the vma is not heap or anonym don't parse the pagemap
        // {
        //     line_buf_dup = strtok(NULL, " ");
        //     label[i++] = line_buf_dup; 
        // }while( i < 6 && line_buf_dup != NULL );

        // if( strcmp(label[5], "[heap]\n") && strlen(label[5]) > 2 )
        //     continue;

        line_buf_dup = strtok(line_buf, " ");
        addr_start = strtok(line_buf_dup, "-"); // now we're spliting the string "addr_start-addr_end"
        addr_end = strtok(NULL, "-");
        start = strtoul(addr_start, NULL, 16);
        end = strtoul(addr_end, NULL, 16);
        
        /* Maintenant nous devons parcourir pagemap pour chaque adresse dans la plage start-end */
        if (start > 0 && end > 0)
            parse_proc_pagemap(pid, start, end);

        // if( strlen(label[5]) <= 2 )//once we find the 1st anonym we can stop
        //     break;
    }

    free(line_buf);
    fclose(maps_file);
}

static unsigned long *collect_pml_logs(void)
{
    unsigned int uioFd;
    unsigned long *cpu_map;
    unsigned long i, j;
    unsigned long count = 0;
    unsigned long *dirty;
    unsigned long pid;
    int  ret = -1;
    struct timespec start, end;
    char command[20];

    pml_add = malloc(SIZE); // 
    dirty = malloc(SIZE);

    // Open uio device
    uioFd = open(UIO_DEVICE, O_RDWR); //
    if (uioFd < 0)
    {
        pr_perror("Cannot open %s: %s\n", UIO_DEVICE, strerror(errno));
        // return -1;
    }

    // Mmap memory region containing buffer values
    cpu_map = mmap(0, SIZE, PROT_WRITE, MAP_SHARED, uioFd, 0);
    if (cpu_map == MAP_FAILED)
    {
        pr_perror("Cannot mmap map[%d]: %s\n", uioFd, strerror(errno));
        close(uioFd);
        // return -1;
    }

    memset(pml_add, 0UL, SIZE);
    memset(dirty, 0UL, SIZE);
            
    pid = get_pid(cpu_map[count]);
    pml_nb_entries = cpu_map[count + 1];
    //printf("%lu logs for process : %d\n", pml_nb_entries, pid);
    memcpy(pml_add + count, cpu_map + count + 2, pml_nb_entries * sizeof(unsigned long));
    // cpu_map[count] = 0;//~PID_FLAG;
    // prev = count + 1;
    // count += cpu_map[count + 1] + 2;
    // cpu_map[prev] = 0;
    
    clock_gettime(CLOCK_MONOTONIC, &start);
    parse_proc_maps(pid); 

    i = j = 0;
    while (j < pml_nb_entries && i < pmap_count)
    {
        if ((ret = belongs_to_app(pml_add[i++], pmap_phys_add)) > 0 && pmap_virt_add[ret] != 8392706){
            dirty[j++] = pmap_virt_add[ret]; //pr_debug("dirty[%d] : %lx - virt : %lx\n", ret, dirty[j-1], pmap_virt_add[ret]);
        }
    } 
    clock_gettime(CLOCK_MONOTONIC, &end);
    time_RevMap = ( end.tv_sec - start.tv_sec )*BILLION + ( end.tv_nsec - start.tv_nsec );
    pr_debug("Formula - reverse_mapping : %lf ns\n", time_RevMap);
    
    // i = 0;
    // while (i < pml_nb_entries && dirty[i++] != 0)
    //     pr_debug("sorted : %lx\n", dirty[i++]); // virtual pages  / PAGE_SIZE

    munmap((void *)cpu_map, SIZE);
    close(uioFd);
    free(pmap_virt_add);
    free(pmap_phys_add);
			
    snprintf(command, 20, "rmmod uio_vtf");
    ret = system(command);

    return dirty;
}
