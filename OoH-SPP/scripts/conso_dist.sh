#!/bin/bash
#It is better that you set #GP/KONE/SP for all profiles at 1
#I tried to define it as an argument but the number can be different from one profile to the other.

# #takes as argument, the last GP evaluated (e.g., 15) that will be affected to prev below
# if [ "$#" -lt 1 ]
# then
#     echo "Usage : ./conso_dish.sh #GP (last #GP used)."
#     exit 1
# fi
#######################
ws=0

#functions
microbench () {
    ((ws++))

    case "$ws" in 
        1)
            WSS="10MB"
            ;;
        2)
            WSS="100MB"
            ;;
        3)
            WSS="250MB"
            ;;
        4)
            WSS="500MB"
            ;;
        5)
            WSS="1GB"
            ;;
    esac

    echo "WSS : $WSS" >> ../logs/logs_CLASS"$size"_GP"$GP"
    LD_PRELOAD=./libSlimGuard.so ../test/main_size $1 $2
}

class_8 () {
    class=8
    for loop in 163840 1638400 4096000 8192000 16777216
    do
        microbench $class $loop
    done
}

class_24 () {
    class=24
    for loop in 54613 546130 1365333 2730666 5592405
    do
        microbench $class $loop
    done
}

class_40 () {
    class=40
    for loop in 27306 273060 682666 1365333 2730666
    do
        microbench $class $loop
    done
}

class_56 () {
    class=56
    for loop in 13653 136530 341333 682666 1365333
    do
        microbench $class $loop
    done
}

class_72 () {
    class=72
    for loop in 6826 68260 170666 341333 682666
    do
        microbench $class $loop
    done
}

class_88 () {
    class=88
    for loop in 3413 34130 85333 170666 341333
    do
        microbench $class $loop
    done
}

class_104 () {
    class=104
    for loop in 1706 17060 42666 85333 170666
    do
        microbench $class $loop
    done
}

class_120 () {
    class=120
    for loop in 853 8530 21333 42666 85333
    do
        microbench $class $loop
    done
}

class_136 () {
    class=136
    for loop in 426 4260 10666 21333 42666
    do
        microbench $class $loop
    done
}

class_152 () {
    class=152
    for loop in 213 2130 5333 10666 21333
    do
        microbench $class $loop
    done
}

class_168 () {
    class=168
    for loop in 106 1060 2666 5333 10666
    do
        microbench $class $loop
    done
}

# #remove previous logs
# for profile in *standard #iterate overeach folder representing each profile
# do
#     cd $profile
#     rm logs/*
#     cd ..
# done

#main
rm logs/logs_*
prev=1 #precedent GP: necessary to know what to find in slimguard.h for update

for size in 8 24 40 56 72 88 104 120 136 152 168 #iterate over classes 8 24 40 56 72 88 104 120 136 152 168
do
    for GP in 1 5 7 9 11 13 15 #vary #GP 
    do
        echo "*****************CLASS $size - GP $GP*********************" >> logs/logs_CLASS"$size"_GP"$GP"
        for profile in *standard #iterate overeach folder representing each profile
        do
            cd $profile
            #modify the value of GP and recompile
            sed -i 's/#define KONE '$prev'/#define KONE '$GP'/g' include/slimguard.h
            sed -i 's/#define GP '$prev'/#define GP '$GP'/g' include/slimguard.h
            sed -i 's/#define SP '$prev'/#define SP '$GP'/g' include/slimguard.h

            #recompile
            make clean && make
            
            #start microbench
            echo "*****************Profile : $profile*****************" >> ../logs/logs_CLASS"$size"_GP"$GP"
            class_$size
            
            cd ..
            ws=0 #reset
        done
        prev=$GP
    done
done

#grep -a koneSPP_Mem_Usage logs_CLASS8_GP1 | awk '{print $4}' (to grep specific profile in logs files and print only the last column that contains the values)
#./grep.sh 136 15 | paste -sd" " > ../data.csv #paste reverse line/column

#allocate as much virtual memory as wanted:
#sudo /sbin/sysctl vm.overcommit_memory=1