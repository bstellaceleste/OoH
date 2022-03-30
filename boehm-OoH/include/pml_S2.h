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
/******************/
#define cpu             get_nprocs_conf()
/******************/
#define UIO_DEVICE      "/dev/uio0"
#define PID_FLAG        0xFFFFFFFF00000000
#define is_flag(x) 	    (x & PID_FLAG)==PID_FLAG
#define get_pid(x)	    x & ~PID_FLAG
#define SIZE            (1u << 17)
#define FILE_BUF        25
#define MAX_NB_PFN      300000

static unsigned long pml_nb_entries, dirty_nb_entries; //
static unsigned long *dirty;
//static GC_bool already_logged;
// static unsigned long* sort_unique(unsigned long *arr)
// {
//     unsigned long i, j, temp, count, *array1=xzalloc(SIZE);

//     i = j = count = 0;
//     memset(array1, 0, SIZE);

//     while(i<pml_nb_entries && arr[i]!=0) 
//     {
//         for(j = i+1; j < pml_nb_entries && arr[j]!=0; j++) 
//         {
//             if(arr[i] == arr[j])
//                 /* Duplicate element found */
//                 break;
//         }
//         /* If j is equal to size, it means we traversed whole
//         array and didn't found a duplicate of array[i] */
//         if((j == pml_nb_entries) || arr[j] == 0) {
//             array1[count++] = arr[i];
//         }

//         i++;
//     }
//     //sorting the array1 where only the distinct values are stored
//     i = j = temp = 0;
//     while (i<pml_nb_entries && array1[i]!=0) 
//     {
//         j = i+1;
//         while(j<pml_nb_entries && array1[j]!=0) 
//         {
//             if(array1[i]>array1[j]) {
//                 temp = array1[i];
//                 array1[i] = array1[j];
//                 array1[j] = temp;
//             }
//             j++;
//         }
//         i++;
//     }

//     return array1;

//     // unsigned long i=0, j=0, temp=0;
//     // while (i<pml_nb_entries && arr[i]!=0)
//     // {
//     //     j = i+1;
//     //     while(j<pml_nb_entries && arr[j]!=0)
//     //     {
//     //         if(arr[i] > arr[j])
//     //         {
//     //             temp = arr[i];
//     //             arr[i] = arr[j];
//     //             arr[j] = temp;
//     //         }
//     //         j++;
//     //     }
//     //     i++;
//     // }
// }

static void collect_pml_logs(void)
{
    int uioFd;
    unsigned long *cpu_map;
    memset(dirty, 0UL, SIZE);

    // Open uio device
    uioFd = open(UIO_DEVICE, O_RDWR); //
    if (uioFd < 0)
    {
        GC_err_printf("Cannot open %s: %s\n", UIO_DEVICE, strerror(errno));
        //return -1;
    }

    // Mmap memory region containing buffer values
    cpu_map = mmap(0, SIZE, PROT_WRITE, MAP_SHARED, uioFd, 0);
    if (cpu_map == MAP_FAILED)
    {
        GC_err_printf("Cannot mmap map[%d]: %s\n", uioFd, strerror(errno));
        close(uioFd);
        //return -1;
    }

    pml_nb_entries = dirty_nb_entries = cpu_map[1];
    memcpy(dirty, cpu_map + 2, pml_nb_entries * sizeof(unsigned long));

    munmap((void *)cpu_map, SIZE); 
    close(uioFd);
}
