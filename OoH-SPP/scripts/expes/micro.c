#include <stdlib.h>
#include <string.h>


void user_memset(char *buff, int size) {
	int i = 0;

	for(i = 0; i < size; i++)
		buff[i] = 0;

}


int main(int argc, char *argv[]) {
        int i = 0;
        int *buff;
        int *buff1;
        int *buff2;
        int *buff3;
        int *buff4;
        int *buff5;
        int *buff6;
        for(i = 0; i < 5000; i++) {
//	while(1){
                buff = (int*) malloc(1<<18);
                user_memset((char*)buff, 1<<18);
                buff1 = (int*) malloc(5120);
                user_memset((char*)buff1, 5120);
                buff2 = (int*) malloc(1000);
	        user_memset((char*)buff2, 1000);
                buff3 = (int*) malloc(1500);
                user_memset((char*)buff3, 1500);
                buff4 = (int*) malloc(1800);
                user_memset((char*)buff4, 1800);
                buff5 = (int*) malloc(6144);
                user_memset((char*)buff5, 6144);
                buff6 = (int*) malloc(9000);
                user_memset((char*)buff6, 9000);
	//}
        }
        return 0;
}
