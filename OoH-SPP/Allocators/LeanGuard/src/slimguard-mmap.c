#include "slimguard-mmap.h"
#include "slimguard.h"

#include <err.h>
#include <sys/mman.h>
#include <stdlib.h>
#define MAP_SPP 0x01000000

void * slimguard_mmap(uint64_t size, uint64_t align) 
{
    // if(align % PAGE_SIZE) {
    //     warnx("slimguard_mmap: bad alignment\n");
    //     return NULL;
    // }

    void *r = mmap(0, size + align, PROT_READ | PROT_WRITE,
            MAP_PRIVATE | MAP_ANON | MAP_SPP, -1, 0); //| MAP_SPP,

    if(r == MAP_FAILED) {
        warn("mmap(%lu)", size);
        return NULL;
    }

    if(align) {
        void *old_addr = r;
        r = (void *)(((uint64_t)r + align - 1) & ~(align - 1));
        munmap(old_addr, (uint64_t)r - (uint64_t)old_addr);
    }

    return r;
}
