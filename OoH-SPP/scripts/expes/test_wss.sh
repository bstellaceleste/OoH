#!/bin/bash
taskset -c 3 parsecmgmt -a run -p raytrace -i native & > out_app 2&>1
taskset -c 0 sleep 5
taskset -c 2 ./wss.pl -s 0 $(pidof rtview) 30 & > out_wss 2&>1
