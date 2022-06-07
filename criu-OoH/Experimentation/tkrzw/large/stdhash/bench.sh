#sleep 20 && 
tkrzw_dbm_perf sequence --set_only --random_key --iter 10000000 --buckets 100000 --record_comp zlib --threads 2 --dbm stdhash &> $1_$2
