#!/bin/bash

Slim="/home/stella/Slimguard"
WD="$Slim/expes" #working dir
PARSEC="/home/stella/spp/evals/parsec-3.0"
LOGS="$WD/mem_conso/wss"
LIB="$WD/mem_conso"


parsec(){
	LD_PRELOAD=$LIB/lib$1.so taskset -c 3 /usr/bin/time -v parsecmgmt -a run -p $2 -i simlarge &>> $LOGS/freq_$3/$2_output 2>&1
	#echo "lib$1.so $2"
}

print(){
	printf "\n************************$1******************************\n\n" >> $LOGS/freq_$3/$2_output
#	printf "\n************************$1******************************\n\n" >> $LOGS/$2_conso
}

cd $PARSEC
. env.sh

sudo sh $WD/pin.sh
#sleep 120 #put back 120
sudo dmesg -c

prev=10
for freq in 3 5 10 15 20 50 #2  1 2 3 #4 5 #6 7 8 9 10 
do
	mkdir -p $LOGS/freq_$freq
	
	rm $LOGS/freq_$freq/*
	#cd $Slim/KONE-GP
	#sed -i 's/#define GP '$prev'/#define GP '$freq'/g' include/slimguard.h
	#make clean && make
	#cp libSlimGuard.so ../expes/mem_conso/libGP.so

	cd $Slim/KONE-SPP
	sed -i 's/#define SP '$prev'/#define SP '$freq'/g' include/slimguard.h
	make clean && make
	cp libSlimGuard.so ../expes/mem_conso/libGuarnary.so

	#cd $Slim/LeanGuard
	#sed -i 's/#define GD '$prev'/#define GD '$freq'/g' include/slimguard.h
	#make clean && make
	#cp libSlimGuard.so ../expes/mem_conso/libLeanguard.so

	for app in blackscholes bodytrack canneal dedup freqmine streamcluster swaptions ferret fluidanimate x264
	do
		for policy in Guarnary #Leanguard #Default Canary GP
		do
			sudo sysctl -w vm.drop_caches=3
			parsecmgmt -a fullclean -p $app
			print $policy $app $freq
			parsec $policy $app $freq
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
			sleep 20
			#printf "************************$freq******************************\n" >> $LOGS/nb_subpg$freq
			#sudo dmesg -c | grep SPPEXPEMEM: >> $LOGS/nb_subpg$freq
		done
	done
	prev=$freq
done
