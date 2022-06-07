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
#define SIZE            (1u << 20)
#define FILE_BUF        25
#define MAX_NB_PFN      300000

unsigned long *pml_add, pml_nb_entries, *list_dirty;//  

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

static unsigned long *collect_pml_logs(void)
{
    int uioFd;
    unsigned long *cpu_map;
    // uint32_t intInfo;
    // ssize_t readSize;
    unsigned long count = 0, prev, i;//, j = 0;

    pml_add = xzalloc(SIZE);
    pml_nb_entries = (SIZE / sizeof(unsigned long));

    // Open uio device
    uioFd = open(UIO_DEVICE, O_RDWR); //
    if (uioFd < 0)
    {
        pr_perror("Cannot open %s: %s\n", UIO_DEVICE, strerror(errno));
        //return -1;
    }

    // Mmap memory region containing buffer values
    cpu_map = mmap(0, SIZE, PROT_WRITE, MAP_SHARED, uioFd, 0);
    if (cpu_map == MAP_FAILED)
    {
        pr_perror("Cannot mmap map[%d]: %s\n", uioFd, strerror(errno));
        close(uioFd);
        //return -1;
    }

    memset(pml_add, 0, SIZE);

    // Wait for interrupt
    // readSize = read(uioFd, &intInfo, sizeof(intInfo));

    // if (readSize < 0)
    // {
    //     pr_perror("Cannot wait for uio device interrupt: %s\n",
    //             strerror(errno));
    //     //return errno;
    // }

    while( count < (pml_nb_entries - 2) )
    {
        if(is_flag(cpu_map[count]))
        {
            int pid = get_pid(cpu_map[count]);
            printf("%lu logs for process : %d\n", cpu_map[count + 1], pid);
	    // for ( i = count + 2; i < count + cpu_map[count + 1] + 2; i++ )
                // pml_add[j++] = cpu_map[i];///PAGE_SIZE;//printf("%lx\n", cpu_map[i]);
            memcpy(pml_add+count, cpu_map+count+2, cpu_map[count+1]*sizeof(unsigned long));
            for ( i = count + 2; i < count + cpu_map[count + 1] + 2; i++ )
                    printf("cpu_map[%lu] : %lx\n", i, pml_add[i]);
            cpu_map[count] = ~PID_FLAG; 
            prev = count + 1;
            count += cpu_map[count + 1] + 2;
            cpu_map[prev] = 0;
        }
        else
            count++;
    } 

    munmap((void *)cpu_map, SIZE);
    
    //pml_add = sort_unique(pml_add);

    i = 0;
    pr_debug("@s in pml_add : \n");
    while( i < pml_nb_entries && pml_add[i] != 0 )
        pr_debug("pml_buff : %lx\n", pml_add[i++]/PAGE_SIZE);

    close(uioFd);

    return pml_add;
}
