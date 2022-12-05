//on ne peut pas utiliser la version de notre micro classique où on alloue un bloc ou un ensemble de pages
//car vu que ce n'est pas le malloc de la libc, notre malloc(4K) ne va pas forcément nous renvoyer une page contingue ici et l'accès qu'on fera ne sera pas celui qui ira générer le PF
//les PF seront générés par l'allocateur quand il fera ses déplacments dans la vma
//et donc si on fait ul *region=malloc(4K) et qu'on essaie de mesurer le temps avant et après on ne sera pas en train de mesurer le temps du PF
//on est obligé ici d'aller mesurer les PF dans le kernel direct

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <unistd.h>

#define wss (1 << 30)*sizeof(unsigned long) /*1Go*/
#define PAGE_SIZE sysconf(_SC_PAGE_SIZE)

unsigned long slim_cls[191];
void init_slim_cls(void)
{
    int start = 0;
    for(int i = 0; i < 191; i++)
        if(start < 256)
            slim_cls[i] = start += 8;
        else if(start < 512)
            slim_cls[i] = start += 16;
        else if(start < 1024)
            slim_cls[i] = start += 32;
        else if(start < 2048)
            slim_cls[i] = start += 64;
        else if(start < 4096)
            slim_cls[i] = start += 128;
        else if(start < 8192)
            slim_cls[i] = start += 256;
        else if(start < 16384)
            slim_cls[i] = start += 512;
        else if(start < 32768)
            slim_cls[i] = start += 1024;
        else if(start < 65536)
            slim_cls[i] = start += 2048;
        else if(start < 131072)
            slim_cls[i] = start += 4096;
        else
            slim_cls[i] = start += 8192;
}
/* *Really* minimal PCG32 code / (c) 2014 M.E. O'Neill / pcg-random.org
 * See license for pcg32 in docs/pcg32-license.txt */
typedef struct { unsigned long state;  unsigned long inc; } pcg32_random_t;
__thread pcg32_random_t rng = {0x0, 0x0};

unsigned int pcg32_random_r(void) 
{
    unsigned long oldstate = rng.state;
    // Advance internal state
    rng.state = oldstate * 6364136223846793005ULL + (rng.inc|1);
    // Calculate output function (XSH RR), uses old state for max ILP
    unsigned int xorshifted = ((oldstate >> 18u) ^ oldstate) >> 27u;
    unsigned int rot = oldstate >> 59u;
    return (xorshifted >> rot) | (xorshifted << ((-rot) & 31));
}

int main(void)
{
    unsigned long rest = 0, *tmp, mult;
    unsigned short random;
    unsigned long count=0;

    init_slim_cls(); 
    while( rest < wss) //while we haven't allocated 1Go of memory
    {
//	random = pcg32_random_r() % 191; //pick a random size to malloc
	
	mult = slim_cls[(count++)%191];
	tmp = malloc(mult);//*sizeof(unsigned long));
	if(tmp)
		tmp[0] = rest += mult;
    }
//    printf("count %d\n", count);
    return 0;
}
