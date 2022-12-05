#!/bin/bash
#cd /home/stella/scripts

val=`cat app`
prev=`cat freq`
runs=`cat nb_runs`

HOME="/home/stella"
DIR="$HOME/Slimguard/expes/perfs/with_hypercalls_subinfo/exec_times/concurrency/$val"

compile () {
	cd $HOME/Slimguard/LeanGuard/
	sed -i 's/#define GD '$2'/#define GD '$3'/g' include/slimguard.h
	make clean > /dev/zero 
	make > /dev/zero
	cp libSlimGuard.so lib_$1.so
}

app1="blackscholes"
app2="bodytrack"
app3="canneal"
app4="dedup"
app5="fluidanimate"
app6="freqmine"
app7="streamcluster"
app8="swaptions"
app9="x264"
freq1=8
freq2=22
freq3=14
freq4=18
freq5=12
freq6=2
freq7=2
freq8=9
freq9=2

case "$val" in
        2)	   
	    echo "************$runs************************" >> $DIR/PIDs
	    echo "************$runs************************" >> $DIR/"$app1"_time
	    echo "************$runs************************" >> $DIR/"$app2"_time

	    cd "$HOME/spp/evals/parsec-3.0"
            source env.sh
	    parsecmgmt -a fullclean -p $app1 $app2
	    cd $HOME

	    LD_PRELOAD=/home/stella/Slimguard/LeanGuard/lib_$app1.so /usr/bin/time -v parsecmgmt -a run -p $app1 -i native >> $DIR/"$app1"_time 2>&1 &
	    pid1=$!

	    LD_PRELOAD=/home/stella/Slimguard/LeanGuard/lib_$app2.so /usr/bin/time -v parsecmgmt -a run -p $app2 -i native >> $DIR/"$app2"_time 2>&1 &
	    pid2=$!

	    echo "************PID_$app1 - $pid1************************" >> $DIR/PIDs
	    echo "************PID_$app2 - $pid2************************" >> $DIR/PIDs

	    wait
	    freq=$freq2
            ;;
        3)  	   
	    echo "************$runs************************" >> $DIR/PIDs
	    echo "************$runs************************" >> $DIR/"$app1"_time
	    echo "************$runs************************" >> $DIR/"$app2"_time
	    echo "************$runs************************" >> $DIR/"$app3"_time

	    cd "$HOME/spp/evals/parsec-3.0"
            source env.sh
	    parsecmgmt -a fullclean -p $app1 $app2 $app3
	    cd $HOME

	    LD_PRELOAD=/home/stella/Slimguard/LeanGuard/lib_$app1.so /usr/bin/time -v parsecmgmt -a run -p $app1 -i native >> $DIR/"$app1"_time 2>&1 &
	    pid1=$!

	    LD_PRELOAD=/home/stella/Slimguard/LeanGuard/lib_$app2.so /usr/bin/time -v parsecmgmt -a run -p $app2 -i native >> $DIR/"$app2"_time 2>&1 &
	    pid2=$!

	    LD_PRELOAD=/home/stella/Slimguard/LeanGuard/lib_$app3.so /usr/bin/time -v parsecmgmt -a run -p $app3 -i native >> $DIR/"$app3"_time 2>&1 &
	    pid3=$!

	    echo "************PID_$app1 - $pid1************************" >> $DIR/PIDs
	    echo "************PID_$app2 - $pid2************************" >> $DIR/PIDs
	    echo "************PID_$app3 - $pid3************************" >> $DIR/PIDs

	    wait
	    freq=$freq3
            ;;
        4)  	   
	    echo "************$runs************************" >> $DIR/PIDs
	    echo "************$runs************************" >> $DIR/"$app1"_time
	    echo "************$runs************************" >> $DIR/"$app2"_time
	    echo "************$runs************************" >> $DIR/"$app3"_time
	    echo "************$runs************************" >> $DIR/"$app4"_time

	    cd "$HOME/spp/evals/parsec-3.0"
            source env.sh
	    parsecmgmt -a fullclean -p $app1 $app2 $app3 $app4
	    cd $HOME

	    LD_PRELOAD=/home/stella/Slimguard/LeanGuard/lib_$app1.so /usr/bin/time -v parsecmgmt -a run -p $app1 -i native >> $DIR/"$app1"_time 2>&1 &
	    pid1=$!

	    LD_PRELOAD=/home/stella/Slimguard/LeanGuard/lib_$app2.so /usr/bin/time -v parsecmgmt -a run -p $app2 -i native >> $DIR/"$app2"_time 2>&1 &
	    pid2=$!

	    LD_PRELOAD=/home/stella/Slimguard/LeanGuard/lib_$app3.so /usr/bin/time -v parsecmgmt -a run -p $app3 -i native >> $DIR/"$app3"_time 2>&1 &
	    pid3=$!

	    LD_PRELOAD=/home/stella/Slimguard/LeanGuard/lib_$app4.so /usr/bin/time -v parsecmgmt -a run -p $app4 -i native >> $DIR/"$app4"_time 2>&1 &
	    pid4=$!

	    echo "************PID_$app1 - $pid1************************" >> $DIR/PIDs
	    echo "************PID_$app2 - $pid2************************" >> $DIR/PIDs
	    echo "************PID_$app3 - $pid3************************" >> $DIR/PIDs
	    echo "************PID_$app4 - $pid4************************" >> $DIR/PIDs

	    wait
	    freq=$freq4
            ;;
        5)  	   
	    echo "************$runs************************" >> $DIR/PIDs
	    echo "************$runs************************" >> $DIR/"$app1"_time
	    echo "************$runs************************" >> $DIR/"$app2"_time
	    echo "************$runs************************" >> $DIR/"$app3"_time
	    echo "************$runs************************" >> $DIR/"$app4"_time
	    echo "************$runs************************" >> $DIR/"$app5"_time

	    cd "$HOME/spp/evals/parsec-3.0"
            source env.sh
	    parsecmgmt -a fullclean -p $app1 $app2 $app3 $app4 $app5
	    cd $HOME

	    LD_PRELOAD=/home/stella/Slimguard/LeanGuard/lib_$app1.so /usr/bin/time -v parsecmgmt -a run -p $app1 -i native >> $DIR/"$app1"_time 2>&1 &
	    pid1=$!

	    LD_PRELOAD=/home/stella/Slimguard/LeanGuard/lib_$app2.so /usr/bin/time -v parsecmgmt -a run -p $app2 -i native >> $DIR/"$app2"_time 2>&1 &
	    pid2=$!

	    LD_PRELOAD=/home/stella/Slimguard/LeanGuard/lib_$app3.so /usr/bin/time -v parsecmgmt -a run -p $app3 -i native >> $DIR/"$app3"_time 2>&1 &
	    pid3=$!

	    LD_PRELOAD=/home/stella/Slimguard/LeanGuard/lib_$app4.so /usr/bin/time -v parsecmgmt -a run -p $app4 -i native >> $DIR/"$app4"_time 2>&1 &
	    pid4=$!

	    LD_PRELOAD=/home/stella/Slimguard/LeanGuard/lib_$app5.so /usr/bin/time -v parsecmgmt -a run -p $app5 -i native >> $DIR/"$app5"_time 2>&1 &
	    pid5=$!

	    echo "************PID_$app1 - $pid1************************" >> $DIR/PIDs
	    echo "************PID_$app2 - $pid2************************" >> $DIR/PIDs
	    echo "************PID_$app3 - $pid3************************" >> $DIR/PIDs
	    echo "************PID_$app4 - $pid4************************" >> $DIR/PIDs
	    echo "************PID_$app5 - $pid5************************" >> $DIR/PIDs

	    wait
	    freq=$freq5
            ;;
	6)	   
	    echo "************$runs************************" >> $DIR/PIDs
	    echo "************$runs************************" >> $DIR/"$app1"_time
	    echo "************$runs************************" >> $DIR/"$app2"_time
	    echo "************$runs************************" >> $DIR/"$app3"_time
	    echo "************$runs************************" >> $DIR/"$app4"_time
	    echo "************$runs************************" >> $DIR/"$app5"_time
	    echo "************$runs************************" >> $DIR/"$app6"_time

	    cd "$HOME/spp/evals/parsec-3.0"
            source env.sh
	    parsecmgmt -a fullclean -p $app1 $app2 $app3 $app4 $app5 $app6
	    cd $HOME

	    LD_PRELOAD=/home/stella/Slimguard/LeanGuard/lib_$app1.so /usr/bin/time -v parsecmgmt -a run -p $app1 -i native >> $DIR/"$app1"_time 2>&1 &
	    pid1=$!

	    LD_PRELOAD=/home/stella/Slimguard/LeanGuard/lib_$app2.so /usr/bin/time -v parsecmgmt -a run -p $app2 -i native >> $DIR/"$app2"_time 2>&1 &
	    pid2=$!

	    LD_PRELOAD=/home/stella/Slimguard/LeanGuard/lib_$app3.so /usr/bin/time -v parsecmgmt -a run -p $app3 -i native >> $DIR/"$app3"_time 2>&1 &
	    pid3=$!

	    LD_PRELOAD=/home/stella/Slimguard/LeanGuard/lib_$app4.so /usr/bin/time -v parsecmgmt -a run -p $app4 -i native >> $DIR/"$app4"_time 2>&1 &
	    pid4=$!

	    LD_PRELOAD=/home/stella/Slimguard/LeanGuard/lib_$app5.so /usr/bin/time -v parsecmgmt -a run -p $app5 -i native >> $DIR/"$app5"_time 2>&1 &
	    pid5=$!

	    LD_PRELOAD=/home/stella/Slimguard/LeanGuard/lib_$app6.so /usr/bin/time -v parsecmgmt -a run -p $app6 -i native >> $DIR/"$app6"_time 2>&1 &
	    pid6=$!

	    echo "************PID_$app1 - $pid1************************" >> $DIR/PIDs
	    echo "************PID_$app2 - $pid2************************" >> $DIR/PIDs
	    echo "************PID_$app3 - $pid3************************" >> $DIR/PIDs
	    echo "************PID_$app4 - $pid4************************" >> $DIR/PIDs
	    echo "************PID_$app5 - $pid5************************" >> $DIR/PIDs
	    echo "************PID_$app6 - $pid6************************" >> $DIR/PIDs

	    wait
	    freq=$freq6
            ;;
        7)   	   
	    echo "************$runs************************" >> $DIR/PIDs
	    echo "************$runs************************" >> $DIR/"$app1"_time
	    echo "************$runs************************" >> $DIR/"$app2"_time
	    echo "************$runs************************" >> $DIR/"$app3"_time
	    echo "************$runs************************" >> $DIR/"$app4"_time
	    echo "************$runs************************" >> $DIR/"$app5"_time
	    echo "************$runs************************" >> $DIR/"$app6"_time
	    echo "************$runs************************" >> $DIR/"$app7"_time

	    cd "$HOME/spp/evals/parsec-3.0"
            source env.sh
	    parsecmgmt -a fullclean -p $app1 $app2 $app3 $app4 $app5 $app6 $app7
	    cd $HOME

	    LD_PRELOAD=/home/stella/Slimguard/LeanGuard/lib_$app1.so /usr/bin/time -v parsecmgmt -a run -p $app1 -i native >> $DIR/"$app1"_time 2>&1 &
	    pid1=$!

	    LD_PRELOAD=/home/stella/Slimguard/LeanGuard/lib_$app2.so /usr/bin/time -v parsecmgmt -a run -p $app2 -i native >> $DIR/"$app2"_time 2>&1 &
	    pid2=$!

	    LD_PRELOAD=/home/stella/Slimguard/LeanGuard/lib_$app3.so /usr/bin/time -v parsecmgmt -a run -p $app3 -i native >> $DIR/"$app3"_time 2>&1 &
	    pid3=$!

	    LD_PRELOAD=/home/stella/Slimguard/LeanGuard/lib_$app4.so /usr/bin/time -v parsecmgmt -a run -p $app4 -i native >> $DIR/"$app4"_time 2>&1 &
	    pid4=$!

	    LD_PRELOAD=/home/stella/Slimguard/LeanGuard/lib_$app5.so /usr/bin/time -v parsecmgmt -a run -p $app5 -i native >> $DIR/"$app5"_time 2>&1 &
	    pid5=$!

	    LD_PRELOAD=/home/stella/Slimguard/LeanGuard/lib_$app6.so /usr/bin/time -v parsecmgmt -a run -p $app6 -i native >> $DIR/"$app6"_time 2>&1 &
	    pid6=$!

	    LD_PRELOAD=/home/stella/Slimguard/LeanGuard/lib_$app7.so /usr/bin/time -v parsecmgmt -a run -p $app7 -i native >> $DIR/"$app7"_time 2>&1 &
	    pid7=$!

	    echo "************PID_$app1 - $pid1************************" >> $DIR/PIDs
	    echo "************PID_$app2 - $pid2************************" >> $DIR/PIDs
	    echo "************PID_$app3 - $pid3************************" >> $DIR/PIDs
	    echo "************PID_$app4 - $pid4************************" >> $DIR/PIDs
	    echo "************PID_$app5 - $pid5************************" >> $DIR/PIDs
	    echo "************PID_$app6 - $pid6************************" >> $DIR/PIDs
	    echo "************PID_$app7 - $pid7************************" >> $DIR/PIDs

	    wait
	    freq=$freq7
            ;;
        8)	   
	    echo "************$runs************************" >> $DIR/PIDs
	    echo "************$runs************************" >> $DIR/"$app1"_time
	    echo "************$runs************************" >> $DIR/"$app2"_time
	    echo "************$runs************************" >> $DIR/"$app3"_time
	    echo "************$runs************************" >> $DIR/"$app4"_time
	    echo "************$runs************************" >> $DIR/"$app5"_time
	    echo "************$runs************************" >> $DIR/"$app6"_time
	    echo "************$runs************************" >> $DIR/"$app7"_time
	    echo "************$runs************************" >> $DIR/"$app8"_time

	    cd "$HOME/spp/evals/parsec-3.0"
            source env.sh
	    parsecmgmt -a fullclean -p $app1 $app2 $app3 $app4 $app5 $app6 $app7 $app8
	    cd $HOME

	    LD_PRELOAD=/home/stella/Slimguard/LeanGuard/lib_$app1.so /usr/bin/time -v parsecmgmt -a run -p $app1 -i native >> $DIR/"$app1"_time 2>&1 &
	    pid1=$!

	    LD_PRELOAD=/home/stella/Slimguard/LeanGuard/lib_$app2.so /usr/bin/time -v parsecmgmt -a run -p $app2 -i native >> $DIR/"$app2"_time 2>&1 &
	    pid2=$!

	    LD_PRELOAD=/home/stella/Slimguard/LeanGuard/lib_$app3.so /usr/bin/time -v parsecmgmt -a run -p $app3 -i native >> $DIR/"$app3"_time 2>&1 &
	    pid3=$!

	    LD_PRELOAD=/home/stella/Slimguard/LeanGuard/lib_$app4.so /usr/bin/time -v parsecmgmt -a run -p $app4 -i native >> $DIR/"$app4"_time 2>&1 &
	    pid4=$!

	    LD_PRELOAD=/home/stella/Slimguard/LeanGuard/lib_$app5.so /usr/bin/time -v parsecmgmt -a run -p $app5 -i native >> $DIR/"$app5"_time 2>&1 &
	    pid5=$!

	    LD_PRELOAD=/home/stella/Slimguard/LeanGuard/lib_$app6.so /usr/bin/time -v parsecmgmt -a run -p $app6 -i native >> $DIR/"$app6"_time 2>&1 &
	    pid6=$!

	    LD_PRELOAD=/home/stella/Slimguard/LeanGuard/lib_$app7.so /usr/bin/time -v parsecmgmt -a run -p $app7 -i native >> $DIR/"$app7"_time 2>&1 &
	    pid7=$!

	    LD_PRELOAD=/home/stella/Slimguard/LeanGuard/lib_$app8.so /usr/bin/time -v parsecmgmt -a run -p $app8 -i native >> $DIR/"$app8"_time 2>&1 &
	    pid8=$!

	    echo "************PID_$app1 - $pid1************************" >> $DIR/PIDs
	    echo "************PID_$app2 - $pid2************************" >> $DIR/PIDs
	    echo "************PID_$app3 - $pid3************************" >> $DIR/PIDs
	    echo "************PID_$app4 - $pid4************************" >> $DIR/PIDs
	    echo "************PID_$app5 - $pid5************************" >> $DIR/PIDs
	    echo "************PID_$app6 - $pid6************************" >> $DIR/PIDs
	    echo "************PID_$app7 - $pid7************************" >> $DIR/PIDs
	    echo "************PID_$app8 - $pid8************************" >> $DIR/PIDs

	    wait
	    freq=$freq8
            ;;
        9)	   
	    echo "************$runs************************" >> $DIR/PIDs
	    echo "************$runs************************" >> $DIR/"$app1"_time
	    echo "************$runs************************" >> $DIR/"$app2"_time
	    echo "************$runs************************" >> $DIR/"$app3"_time
	    echo "************$runs************************" >> $DIR/"$app4"_time
	    echo "************$runs************************" >> $DIR/"$app5"_time
	    echo "************$runs************************" >> $DIR/"$app6"_time
	    echo "************$runs************************" >> $DIR/"$app7"_time
	    echo "************$runs************************" >> $DIR/"$app8"_time
	    echo "************$runs************************" >> $DIR/"$app8"_time

	    cd "$HOME/spp/evals/parsec-3.0"
            source env.sh
	    parsecmgmt -a fullclean -p $app1 $app2 $app3 $app4 $app5 $app6 $app7 $app8 $app9
	    cd $HOME

	    LD_PRELOAD=/home/stella/Slimguard/LeanGuard/lib_$app1.so /usr/bin/time -v parsecmgmt -a run -p $app1 -i native >> $DIR/"$app1"_time 2>&1 &
	    pid1=$!

	    LD_PRELOAD=/home/stella/Slimguard/LeanGuard/lib_$app2.so /usr/bin/time -v parsecmgmt -a run -p $app2 -i native >> $DIR/"$app2"_time 2>&1 &
	    pid2=$!

	    LD_PRELOAD=/home/stella/Slimguard/LeanGuard/lib_$app3.so /usr/bin/time -v parsecmgmt -a run -p $app3 -i native >> $DIR/"$app3"_time 2>&1 &
	    pid3=$!

	    LD_PRELOAD=/home/stella/Slimguard/LeanGuard/lib_$app4.so /usr/bin/time -v parsecmgmt -a run -p $app4 -i native >> $DIR/"$app4"_time 2>&1 &
	    pid4=$!

	    LD_PRELOAD=/home/stella/Slimguard/LeanGuard/lib_$app5.so /usr/bin/time -v parsecmgmt -a run -p $app5 -i native >> $DIR/"$app5"_time 2>&1 &
	    pid5=$!

	    LD_PRELOAD=/home/stella/Slimguard/LeanGuard/lib_$app6.so /usr/bin/time -v parsecmgmt -a run -p $app6 -i native >> $DIR/"$app6"_time 2>&1 &
	    pid6=$!

	    LD_PRELOAD=/home/stella/Slimguard/LeanGuard/lib_$app7.so /usr/bin/time -v parsecmgmt -a run -p $app7 -i native >> $DIR/"$app7"_time 2>&1 &
	    pid7=$!

	    LD_PRELOAD=/home/stella/Slimguard/LeanGuard/lib_$app8.so /usr/bin/time -v parsecmgmt -a run -p $app8 -i native >> $DIR/"$app8"_time 2>&1 &
	    pid8=$!

	    LD_PRELOAD=/home/stella/Slimguard/LeanGuard/lib_$app9.so /usr/bin/time -v parsecmgmt -a run -p $app9 -i native >> $DIR/"$app9"_time 2>&1 &
	    pid9=$!

	    echo "************PID_$app1 - $pid1************************" >> $DIR/PIDs
	    echo "************PID_$app2 - $pid2************************" >> $DIR/PIDs
	    echo "************PID_$app3 - $pid3************************" >> $DIR/PIDs
	    echo "************PID_$app4 - $pid4************************" >> $DIR/PIDs
	    echo "************PID_$app5 - $pid5************************" >> $DIR/PIDs
	    echo "************PID_$app6 - $pid6************************" >> $DIR/PIDs
	    echo "************PID_$app7 - $pid7************************" >> $DIR/PIDs
	    echo "************PID_$app8 - $pid8************************" >> $DIR/PIDs
	    echo "************PID_$app8 - $pid9************************" >> $DIR/PIDs

	    wait
	    freq=$freq9
            ;;
esac

sysctl -w vm.drop_caches=3

killall dmesg.sh

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







