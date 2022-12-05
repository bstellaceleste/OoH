#!/bin/bash

mkdir -p cdf_subpg
for freq in 2 3 5 10 15 20 50 #10 9 8 7 6 5 4 3 2 1
do
	cd freq_$freq
	for app in blackscholes #bodytrack canneal dedup freqmine streamcluster swaptions ferret fluidanimate x264
	do
		total=$(grep SPPEXPEMEM: nb_subpages | wc -l)		
		grep SPPEXPEMEM: nb_subpages |awk '{ print $7 }' | awk '{print $1}' | sort -n | uniq -c | awk '{ sum+=$1; print $2,sum/tot}' tot=$total > cdf_subpg/subpg_$freq
	done
	cd ../
done
