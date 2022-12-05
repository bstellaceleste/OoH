#!/bin/bash

Slim="/home/stella/Documents/sources/spp/SlimGuard_IntelSPP/implementation_evaluation"
WD="$Slim/expes" #working dir
PARSEC="/home/stella/Documents/sources/spp/evals/parsec-3.0"
LOGS="$WD/mem_conso/wss"
LIB="$WD/mem_conso"

parsec(){
	LD_PRELOAD=$LIB/lib$1.so taskset -c 6,7 /usr/bin/time -v parsecmgmt -a run -p $2 >> $LOGS/freq_$3/$2_output 2>&1
	#echo "lib$1.so $2"  -i simlarge
}

print(){
#	printf "\n************************$1_improved******************************\n\n" >> $LOGS/freq_$3/$2_output
	printf "\n************************$1******************************\n\n" >> $LOGS/freq_$3/$2_output
}

cd $PARSEC
. env.sh

sudo sh $WD/pin.sh
#sleep 120 #put back 120
sudo sysctl vm.overcommit_memory=1

prev=2
for freq in 2 3 5 10 15 20 50 #7 8 9 10 #1 2 3 4 5 6 #
do
	mkdir -p $LOGS/freq_$freq
	#rm $LOGS/freq_$freq/*
	cd $Slim/KONE-GP
	sed -i 's/#define GP '$prev'/#define GP '$freq'/g' include/slimguard.h
	make clean && make
	cp libSlimGuard.so ../expes/mem_conso/libGP.so

	cd $Slim/KONE-SPP
	sed -i 's/#define SP '$prev'/#define SP '$freq'/g' include/slimguard.h
	make clean && make
	cp libSlimGuard.so ../expes/mem_conso/libGuarnary.so

	cd $Slim/LeanGuard
	sed -i 's/#define GD '$prev'/#define GD '$freq'/g' include/slimguard.h
	make clean && make
	cp libSlimGuard.so ../expes/mem_conso/libLeanGuard.so

	for app in raytrace #blackscholes bodytrack canneal dedup freqmine streamcluster swaptions ferret fluidanimate x264 #blackscholes
	do
		for policy in Default Canary Guarnary GP LeanGuard 
		do
			sudo sysctl -w vm.drop_caches=3
			parsecmgmt -a fullclean -p $app
			printf "\n************************$policy******************************\n\n" >> $LOGS/freq_$freq/"$app"_output
			#print $policy $app $freq
			LD_PRELOAD=$LIB/lib$policy.so taskset -c 6,7 /usr/bin/time -v parsecmgmt -a run -p $app >> $LOGS/freq_$freq/"$app"_output 2>&1
			#parsec $policy $app $freq
			#
			#sleep 1
			#pid=$(pidof $app)
			#while [ -z "$pid" ] #tant que la chaine de char pid est vide
			#do
			#	pid=$(pidof $app)
			#done
			#
			#taskset -c 2 nohup $WD/wss.pl -s 0 $pid .05 >> $LOGS/$app"_conso" 2>&1
			#echo "test" >> $LOGS/$app"_conso" 2>&1
			#
			sleep 5
		done
	done
	prev=$freq
done
