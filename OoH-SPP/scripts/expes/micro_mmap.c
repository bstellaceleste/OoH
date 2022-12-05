#include <sys/mman.h>
#include <stdlib.h>
#include <string.h>
#include <stdio.h>

int main(int argc, char* argv[]) {
        int i;
        void *addr = mmap(NULL,15*4096, PROT_READ | PROT_WRITE, 0x01000000 | MAP_PRIVATE | MAP_ANON, 0, 0);

        madvise(addr, 4096*15,22);
        char* buff = (char*) addr;

	
//for(int round=0; round<10; round++)
        for (i = 0; i < 15; i++) {
                buff[i] = 1;
                buff += 4096;
        }

        return 0;
}
