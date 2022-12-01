#include <time.h>
#include <stdlib.h>
#include <limits.h>
#include <unistd.h>

#define size 12800
#define page_size sysconf(_SC_PAGE_SIZE)

int main(void){
        unsigned long i = 0;
        unsigned long *data = malloc(size*page_size);	

         for( ; ; ){
		for(i = 0; i < size; i++)
			data[i*512] = i;
        }
}

