#!/bin/bash


while read size
do
	for freq in {2..10}
	do
		dist=0
		for i in $(seq 1 $freq)
		do
			inc=$((($i-1)*$size))
			((dist+=$inc))
		done
		echo "$freq: `echo "$dist*1.0/$freq" | bc`" >> distance_$size
	done
done <sizes
