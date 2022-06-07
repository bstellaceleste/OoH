#sleep 20 && 
tkrzw_dbm_perf sequence --set_only --random_key --iter 10000000 --threads 2 --dbm stdtree &> $1_$2
