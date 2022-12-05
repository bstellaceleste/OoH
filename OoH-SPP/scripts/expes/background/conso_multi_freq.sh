#!/bin/bash

#while read app; do LD_PRELOAD=/home/ens/Documents/sources/spp/SlimGuard_IntelSPP/implementation_evaluation/KONE-GP-standard/libSlimGuard.so taskset -c 7 parsecmgmt -a run -p $app &> $app && 
DIR="/home/ens/Documents/sources/spp/SlimGuard_IntelSPP/implementation_evaluation/KONE-GP-standard"
prev=2
for freq in {2..10} 
do 
	parsecmgmt -a fullclean -p $1
	sed -i 's/#define GP '$prev'/#define GP '$freq'/g' $DIR/include/slimguard.h
	cd $DIR
	make clean && make
	cd ../evals/expes_background/
	LD_PRELOAD=$DIR/libSlimGuard.so taskset -c 7 parsecmgmt -a run -p $1 &> $1"_gp_"$freq
	echo "*******$freq******" >> background2
	while read p; do grep "Real_wss(KB)): $p " $1"_gp_"$freq | tail -1 | awk '{ print $10, $11, $12, $13, $14 }'; done <sizes | awk '{ conso+= $4; real+= $5 } END {print conso/real }' >> background2
	prev=$freq
done 


#echo "*******$1******" >> background1 &&  while read p; do grep "Real_wss(KB)): $p " $1 | tail -1 | awk '{ print $9, $10, $11, $12 }'; done <sizes | awk '{ conso+= $3; real+= $4 } END {print conso/real }' >> background1
