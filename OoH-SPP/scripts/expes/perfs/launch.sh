#!/bin/bash
#cd /home/stella/scripts

HOME="/home/stella"
DIR="$HOME/Slimguard/expes/perfs/with_hypercalls_subinfo/exec_times/event_counter/mem_pages"

val=`cat app`
prev=`cat freq`
case "$val" in
        1)
            app="blackscholes"
	    freq=8
            ;;
        2)
            app="bodytrack"
	    freq=22
            ;;
        3)
            app="dedup"
	    freq=18
            ;;
        4)
            app="fluidanimate"
	    freq=12
            ;;
	5)
            app="freqmine"
	    freq=2
            ;;

        6)
            app="raytrace"
            freq=18
            ;;
        7)
            app="streamcluster"
	    freq=12
            ;;
        8)
            app="swaptions"
	    freq=9
            ;;
        9)
            app="x264"
	    freq=2
            ;;
esac

dmesg -c
./dmesg.sh $DIR/"$app"_linux &

#cd
#./parsec.sh $app $prev $freq
./parsec.sh $app

sysctl -w vm.drop_caches=3

#cd /home/stella/scripts
runs=`cat nb_runs`

if [ "$runs" -eq "1" ] #5
then
	echo 1 > nb_runs
	echo $(($val+1)) > app
	echo $freq > freq
else
	echo $(($runs+1)) > nb_runs
fi

if [ "$val" -gt 9 ] #9
then
	exit
else
	reboot
fi







