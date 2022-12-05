#!/bin/bash

DIR="/home/ens/Documents/sources/spp/SlimGuard_IntelSPP/implementation_evaluation/KONE-GP-standard"
while read app; do LD_PRELOAD=$DIR/libSlimGuard.so taskset -c 7 parsecmgmt -a run -p $app &> $app"_gp1" && echo "*******$app******" >> background1 && while read p; do grep "Real_wss(KB)): $p " $app"_gp1" | tail -1 | awk '{ print $8, $9, $10 }'; done <sizes | awk '{ conso+= $2; real+= $3 } END {print conso/real }' >> background1; done <apps_parsec


#echo "*******$1******" >> background1 &&  while read p; do grep "Real_wss(KB)): $p " $1 | tail -1 | awk '{ print $9, $10, $11, $12 }'; done <sizes | awk '{ conso+= $3; real+= $4 } END {print conso/real }' >> background1
