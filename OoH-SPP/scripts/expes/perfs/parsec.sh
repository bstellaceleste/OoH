#!/bin/bash

##--!!!!!! verify GD for LeanGuard and GP for SlimGP in sed -i 
#---!!!!!!!!! remove the app clean for non concurrency

HOME="/home/stella"
#DIR="$HOME/Slimguard/expes/perfs/with_hypercalls_subinfo/parsec_apps/exec_times"
DIR="$HOME/Slimguard/expes/perfs/with_hypercalls_subinfo/exec_times/event_counter/mem_pages"
#baseline_slimGP"

cd "$HOME/spp/evals/parsec-3.0";
#pwd;
source env.sh

#echo "************************" >> $DIR/"$1"_time

#cd $HOME/Slimguard/LeanGuard/
#sed -i 's/#define GD '$2'/#define GD '$3'/g' include/slimguard.h
#make clean > /dev/zero 
#make > /dev/zero
#cp libSlimGuard.so lib_$1.so
parsecmgmt -a fullclean -p $1

cd $HOME/Slimguard/expes/
sudo sh ./pin.sh

#taskset -c 3 /usr/bin/time -v parsecmgmt -a run -p $1 -i native >> $DIR/"$1"_time 2>&1

if [ "$1" == "raytrace" ] || [ "$1" == "freqmine" ]
then
	LD_PRELOAD=/home/stella/Slimguard/LeanGuard/lib_$1.so taskset -c 3 parsecmgmt -a run -p $1 -i simlarge >> $DIR/"$1"_lean 2>&1
else
	LD_PRELOAD=/home/stella/Slimguard/LeanGuard/lib_$1.so taskset -c 3 parsecmgmt -a run -p $1 -i native #>> $DIR/"$1"_lean 2>&1
fi
#>> $DIR/"$1"_time 2>&1 #native

#pid=$!
#echo "************PID_$1 - $pid************************" >> $DIR/PIDs

#printpid () {
#	echo $pid
#}

#printpid
#echo $(printpid)

#./micro
