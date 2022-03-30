/*****************************************************************************************************************/
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
#include <time.h>

#include "private/gc_priv.h"
/******************/
#define cpu get_nprocs_conf()
//#define PAGE_SIZE sysconf(_SC_PAGE_SIZE)
/******************/
#define UIO_DEVICE "/dev/uio0"
#define PID_FLAG 0xFFFFFFFF00000000
#define is_flag(x) (x & PID_FLAG) == PID_FLAG
#define get_pid(x) x & ~PID_FLAG
#define SIZE (1u << 21) //12 15 17 18 19 20 21 
//#define SIZE_PT (1u << 22)
#define FILE_BUF 25
/**********************/
//#define BILLION  1000000000L

static unsigned long *pmap_phys_add, *pmap_virt_add;
static unsigned long pmap_count;
static unsigned long pml_nb_entries, dirty_nb_entries; //
static unsigned long *dirty;
static GC_bool already_logged;

static int belongs_to_app(unsigned long add, unsigned long *list_add)//return the index, in dirty array, of the va corresponding to add 
{
	int i = 0;

    if (list_add)
    {
        do
        {
            if (list_add[i] == add) 
                return i;          
        } while (i++ < pmap_count);// && list_add[i++] != 0);
    }
    return -1;
}

/*
 * Parsing /proc/$pid/maps and for each address, parse /proc/$pid/pagemap
 */
static void parse_proc_pagemap(unsigned int pid, unsigned long a_start, unsigned long a_end)
{
    char pagemap_path[FILE_BUF];
    unsigned long pagemap_file_fd;

    snprintf(pagemap_path, FILE_BUF, "/proc/%d/pagemap", pid);

    /* On ouvre les fichiers */
    pagemap_file_fd = open(pagemap_path, O_RDONLY);
    if (pagemap_file_fd < 0)
    {
        perror("open");
        exit(EXIT_FAILURE);
    }

    /* Pour chacune des adresses virt. dans la plage start-end, nous lisons l'adresse physique correspondante dans pagemap */
    for (uint64_t page = a_start; page < a_end; page += GC_page_size)
    {
        uint64_t data, offset = (page / GC_page_size) * sizeof(data); //

        if (pread(pagemap_file_fd, &data, sizeof(data), offset) < 0)
        {
            perror("pread");
            exit(EXIT_FAILURE);
        }

        if( ((data >> 63) & 1) && (data & 0x7fffffffffffff) != 0 ) // if the page is present
        {
            pmap_phys_add[pmap_count] = (data & 0x7fffffffffffff);
            pmap_virt_add[pmap_count] = page; 
            pmap_count++; 
        }
    }
    close(pagemap_file_fd);
}

static void parse_proc_maps(unsigned int pid)
{
    char maps_path[FILE_BUF];
    int fd, ret;
    char *line_buf = (char *)GC_scratch_alloc(256), *copy = (char *)GC_scratch_alloc(sizeof(char));
    char *line_buf_dup, *addr_start, *addr_end;
    uint64_t start, end;
    /* On construit les chemins vers le fichier maps */
    snprintf(maps_path, FILE_BUF, "/proc/%d/maps", pid);

    /* On ouvre le fichier */
    fd = open(maps_path, O_RDONLY);
    if (fd < 0)
    {
        perror("fopen");
        exit(EXIT_FAILURE);
    }

    ret = 1;
    /* On parcourt /proc/maps ligne par ligne */
    memset(line_buf, 0, sizeof(line_buf));
    while (ret = read(fd, copy, 1) > 0)
    {
        if (strcmp(copy, "\n")) //(copy != '\0')//
            strcat(line_buf, copy);
        else
        {
            line_buf_dup = strtok(line_buf, " ");
            addr_start = strtok(line_buf_dup, "-"); // now we're spliting the string "addr_start-addr_end"
            addr_end = strtok(NULL, "-");
            start = strtoul(addr_start, NULL, 16);
            end = strtoul(addr_end, NULL, 16);
            parse_proc_pagemap(pid, start, end);
            memset(line_buf, 0, sizeof(line_buf)); 
        }
    }

    close(fd);
}

static void collect_pml_logs(unsigned int saved_proc_pid)
{
    unsigned int uioFd;
    unsigned long *cpu_map;
    unsigned long i, j;
    int  ret = -1;
    // struct timespec start, stop;
    // double time;

    memset(pmap_virt_add, 0UL, SIZE);
    memset(pmap_phys_add, 0UL, SIZE);
    memset(dirty, 0UL, SIZE);

    parse_proc_maps(saved_proc_pid);
    // Open uio device
    uioFd = open(UIO_DEVICE, O_RDWR); //
    if (uioFd < 0)
    {
        GC_err_printf("Cannot open %s: %s\n", UIO_DEVICE, strerror(errno));
        return;
    }

    // Mmap memory region containing buffer values
    cpu_map = mmap(0, SIZE, PROT_WRITE, MAP_SHARED, uioFd, 0);
    if (cpu_map == MAP_FAILED)
    {
        GC_err_printf("Cannot mmap map[%d]: %s\n", uioFd, strerror(errno));
        close(uioFd);
        return;
    }

    // if( clock_gettime( CLOCK_MONOTONIC, &start) == -1 ) 
    // {
    //     perror( "clock gettime" );
    //     exit( EXIT_FAILURE );
    // } 

    // if( clock_gettime( CLOCK_MONOTONIC, &start) == -1 ) 
    // {
    //     perror( "clock gettime" );
    //     exit( EXIT_FAILURE );
    // }  
    // if( clock_gettime( CLOCK_MONOTONIC, &stop) == -1 ) 
    // {
    //     perror( "clock gettime" );
    //     exit( EXIT_FAILURE );
    // }
    // time = ( stop.tv_sec - start.tv_sec )*BILLION + ( stop.tv_nsec - start.tv_nsec );
    // pr_debug("collect_from_pml_log_time : %lf ns\n", time);
    // if( clock_gettime( CLOCK_MONOTONIC, &start) == -1 ) 
    // {
    //     perror( "clock gettime" );
    //     exit( EXIT_FAILURE );
    // }  

    pml_nb_entries = cpu_map[1];
    i = j = 0;
    while (i < pml_nb_entries)
    {
        if( (ret = belongs_to_app(cpu_map[(2 + i++)], pmap_phys_add)) > 0 && pmap_virt_add[ret] != 0){
            dirty[j++] = pmap_virt_add[ret]; //GC_printf("dirty[%d] : %lx - virt[%d] : %lx\n", j-1, dirty[j-1], ret, pmap_virt_add[ret]);
        }
    }
    dirty_nb_entries = j; //GC_printf("nb_entries = %lu - j = %lu\n", pml_nb_entries, j);
    // if( clock_gettime( CLOCK_MONOTONIC, &stop) == -1 ) 
    // {
    //     perror( "clock gettime" );
    //     exit( EXIT_FAILURE );
    // }
    // time = ( stop.tv_sec - start.tv_sec )*BILLION + ( stop.tv_nsec - start.tv_nsec );
    // pr_debug("reverse_PT_walk_time : %lf ns\n", time);

//memset(cpu_map, 0, sizeof(cpu_map));
    munmap((void *)cpu_map, SIZE);
    close(uioFd);
    // free(pmap_virt_add);
    // free(pmap_phys_add);
    /*we can no more free these arrays as they are allocated using GC_scratch_alloc which is used 
    * for collector data structures that will never be freed*
    */
}