#!/bin/bash

for nb in {2..9} 
do
	file="$1_pf/$nb"
	cat $file | awk '{print $1}' | sort -n | uniq -c | awk '{ sum+=$1; print $2*1.0/1000,sum/tot }' tot=$(cat $file | wc -l) > $1_pf/$nb"_cdf"

done
