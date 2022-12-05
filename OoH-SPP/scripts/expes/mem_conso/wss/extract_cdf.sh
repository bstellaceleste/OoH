#!/bin/bash

for freq in 1 #2 3 5 10 15 20 50 #10 9 8 7 6 5 4 3 2 1
do
	cd freq_$freq
	mkdir -p plot
	for app in blackscholes bodytrack canneal dedup freqmine streamcluster swaptions ferret fluidanimate x264
	do
		total=$(grep 33mSlim+GP $app"_output" | wc -l)		
		grep 33mSlim+GP $app"_output" | awk '{ print $5 }' | awk '{print $1}' | sort -n | uniq -c | awk '{ sum+=$1; print $2*1.0/1024,sum/tot }' tot=$total > plot/$app"_cdf"
	done
	cd ../
done
