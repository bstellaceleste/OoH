#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#define PAGE_SIZE sysconf(_SC_PAGE_SIZE)
#define PG 256000 /*1Go*/

void main(void)
{
    for( unsigned long i = 0; i < PG; i++)
    {
        unsigned long *region = malloc(PAGE_SIZE);
        //pick time before and after first access that generates PF
        region[0] = i;
    }
}