for freq in 2 #3 5 10 15 20 50
do
	grep 33mSlim+GP freq_$freq/blackscholes_output | awk '{ print $3 }' | sort -n | wc -l > tmp
	awk '{
	if ($1 < 4096)
	$((sp++));
	} END {print sp, NR-sp}' tmp
done

