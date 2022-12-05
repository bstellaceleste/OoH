#!/bin/bash

mkdir -p plot
#rm plot/*
for app in raytrace #blackscholes bodytrack canneal dedup freqmine streamcluster swaptions fluidanimate x264
do
	echo "#freq	guarnary(MB) LeanGuard	guard page(MB)" > plot/$app"_wss"
	for freq in 2 3 5 10 15 20 50 #1 2 3 4 5 6 7 8 9 10
	do
		cd freq_$freq
		grep "Maximum resident set size (kbytes):" $app"_output" | awk '{ print $6*1.0/1000 }' > var #| sed -n '1p ; $p' >> 
		gn=$(sed -n 3p var)
		lg=$(sed -n 5p var)
		gp=$(sed -n 4p var)
		cd ../
		echo "$freq $gn $lg $gp" >> plot/$app"_wss"
	done
done
