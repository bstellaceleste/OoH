#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>

#define CLASS 4096
#define LOOP 1

int main(int argc, char** argv){
	printf("KONE\n");
	unsigned long *tab = malloc(CLASS*LOOP);
	for(int i=0; i<LOOP; i++) {
		tab[i*512] = i;
	}
	printf("yves\n");
	sleep(15);
	return 0;
}
