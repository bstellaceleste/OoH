#!/bin/bash
if [ "$#" -lt "2" ]
then
	echo "./run $policy (default,canary,gp,guarnary) $app (dedup, streamcluster, etc.)"
	exit 0
fi

WD="/home/stella/spp/evals" #working dir
PARSEC="$WD/parsec-3.0"
LOGS="$WD/mem_conso/wss"
LIB="$WD/mem_conso"

policy=$1
parsec(){
	#LD_PRELOAD=$LIB/lib$1.so taskset -c 3 parsecmgmt -a run -p $policy -i simlarge &>> $LOGS/$policy 2>&1 &
	echo "lib$1.so $policy"
}

print(){
	echo "************************$policy******************************" >> $LOGS/$1_output
}

cd $PARSEC
. env.sh
parsecmgmt -a clean -p $2

#sleep 120 #put back 120

while [ True ]
do

	if [ $1 == "default" ] #Slimguard-default
	then
		print $2
		parsec Default

	elif [ $1 == "canary" ] #Slimguard-canary
	then
		print $2
		parsec Canary

	elif [ $1 == "gp" ] #Slimguard-GP
	then
		print $2
		parsec GP

	elif [ $1 == "guarnary" ] #Slimguard-SPP
	then
		print $2
		parsec Guarnary
	fi
	#
	pid=$(pidof $2)
	while [ -z "$pid" ] #tant que la chaine de char pid est vide
	do
		pid=$(pidof $2)
	done
	#
	#taskset -c 2 nohup $WD/wss.pl -s 0 $(pidof $2) 3 >> $LOGS/$2_conso 2>&1
	echo "test" >> $LOGS/$2_conso 2>&1
	#
	cd /opt
	val=`cat policy`
	if [ "$val" -lt "4" ]
	then
		echo $(($val+1)) > policy
		sysctl -w vm.drop_caches=3
		#reboot
	elif [ "$val" -eq "4" ]
	then
		val=`cat app`
		echo 1 > policy #reinitialise pour faire également les 4 policies pour le bench suivant
		sysctl -w vm.drop_caches=3
		if [ "$val" -lt 10 ]
		then
			echo $(($val+1)) > app #passe au bench suivant
			#reboot #poweroff
		elif [ "$val" -eq 10 ]
		then
			poweroff
	#		val=`cat policy`
	#                if [ "$val" -lt "2" ]
	#                then
	#			echo $(($val+1)) > policy
	#                        echo 1 > bench
	#                        poweroff
	#                fi
		fi
	fi
done
