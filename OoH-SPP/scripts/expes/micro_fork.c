#include <sys/mman.h>
#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <unistd.h>

void user_write(char* a, char* b, char* c, char* d)
{
        a[0] = 1;
        b[0] = 1;
        c[0] = 1;
        d[0] = 1;
}

int main(int argc, char* argv[]) {
        int i;
        char *addr = mmap(NULL, 4096*4, PROT_READ | PROT_WRITE, 0x01000000 | MAP_PRIVATE | MAP_ANON, 0, 0);
        char *addr1 = mmap(NULL, 4096*4, PROT_READ | PROT_WRITE, 0x01000000 | MAP_PRIVATE | MAP_ANON, 0, 0);
        char *addr2 = mmap(NULL, 4096*4, PROT_READ | PROT_WRITE, 0x01000000 | MAP_PRIVATE | MAP_ANON, 0, 0);
        char *addr3 = mmap(NULL, 4096*4, PROT_READ | PROT_WRITE, 0x01000000 | MAP_PRIVATE | MAP_ANON, 0, 0);
        madvise(addr, 4096*4, 22);
        madvise(addr1, 4096*4, 23);
        madvise(addr2, 4096*4, 24);
        madvise(addr3, 4096*4, 25);

        user_write(addr, addr1, addr2, addr3);

        if (!fork())
                user_write(addr, addr1, addr2, addr3);
        return 0;
}
