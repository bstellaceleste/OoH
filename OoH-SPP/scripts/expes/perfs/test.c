#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <unistd.h>

#define wss (1 << 30)
#define PAGE_SIZE sysconf(_SC_PAGE_SIZE)

void main(void)
{
		int nb_loop = wss/sizeof(unsigned long);

			unsigned long *tmp;
				for(int i=0;nb_loop;i++)
						{
									tmp=malloc(sizeof(unsigned long));
											tmp[0]=i;
												}
				free(tmp);
}
