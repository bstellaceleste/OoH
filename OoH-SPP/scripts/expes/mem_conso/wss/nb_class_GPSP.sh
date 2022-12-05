for app in blackscholes bodytrack canneal dedup freqmine streamcluster swaptions x264
do
	grep 33mSlim+GP freq_2/$app"_output" | awk '{ print $3 }' | sort -n > tmp
	awk '{
	if ($1 % 4096 != 0)
	$((sp++));
	} END {print sp, NR-sp}' tmp >> out
done

