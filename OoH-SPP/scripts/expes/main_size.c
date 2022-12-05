/*
 * Slimguard has 176 classes for 11 divisions at the rate of 16 classes per per division
 * Instead of evaluating all the 176 classes, we consider it significant to evaluate each middle class of every division * (since such a class is a mean of all other classes of the division, in terms of size)
 * We'll then evaluate classes: 8 - 24 - ... see the rest on the board in my office
 * We change the semantic of malloc so that we pass directly the class index instead of the size of buffers inside the class (e.g., we pass 8 instead of values between 57 and 63)
 */
#include <stdlib.h>
#include <stdio.h>

//#define CLASS 8 // Class:size(o) -> 8:64 - 24:192 - 40:384 - 56:768 - 72:1536 - 88:3072 - 104:6144 - 120:12288 - 136:24576 - 152:49152 - 168:98304
//#define LOOP  (1 << 24)

//we compute the loop so that CLASS*LOOP=wss (10MB - 100MB - 250MB - 500MB - 1GB)
/*
 * Class 8:
 * - 10Mo => 10 << 14 (163840) - 100Mo => 100 << 14 (1638400) - 250Mo => 250 << 14 (4096000) - 500Mo => 500 << 14 (8192000) - 1Go => 1 << 24 (16777216) - 
 * Class 24:
 * - 10Mo => 10*1.0/3 << 14 (54613) - 100Mo => (546130) - 250Mo => (1365333) - 500Mo => (2730666) - 1Go => (5592405) - 
 * Class 40:
 * - 10Mo => 10*1.0/3 << 13 (27306) - 100Mo => (273060) - 250Mo => (682666) - 500Mo => (1365333) - 1Go => (2730666) - 
 * Class 56:
 * - 10Mo => 10*1.0/3 << 12 (13653) - 100Mo => (136530) - 250Mo => (341333) - 500Mo => (682666) - 1Go => (1365333) - 
 * Class 72:
 * - 10Mo => 10*1.0/3 << 11 (6826) - 100Mo => (68260) - 250Mo => (170666) - 500Mo => (341333) - 1Go => (682666) - 
 * Class 88:
 * - 10Mo => 10*1.0/3 << 10 (3413) - 100Mo => (34130) - 250Mo => (85333) - 500Mo => (170666) - 1Go => (341333) - 
 * Class 104:
 * - 10Mo => 10*1.0/3 << 9 (1706) - 100Mo => (17060) - 250Mo => (42666) - 500Mo => (85333) - 1Go => (170666) - 
 * Class 120:
 * - 10Mo => 10*1.0/3 << 8 (853) - 100Mo => (8530) - 250Mo => (21333) - 500Mo => (42666) - 1Go => (85333) - 
 * Class 136:
 * - 10Mo => 10*1.0/3 << 7 (426) - 100Mo => (4260) - 250Mo => (10666) - 500Mo => (21333) - 1Go => (42666) - 
 * Class 152:
 * - 10Mo => 10*1.0/3 << 6 (213) - 100Mo => (2130) - 250Mo => (5333) - 500Mo => (10666) - 1Go => (21333) - 
 * Class 168:
 * - 10Mo => 10*1.0/3 << 5 (106) - 100Mo => (1060) - 250Mo => (2666) - 500Mo => (5333) - 1Go => (10666) - 
 */

void main(int argc, char **argv)
{
	void* buff; 
	unsigned int CLASS = atoi(argv[1]), LOOP = atoi(argv[2]);

	for(unsigned int i=0; i<LOOP; i++)
	{
		buff = malloc(CLASS);
	}

	free((void *)CLASS);
}
