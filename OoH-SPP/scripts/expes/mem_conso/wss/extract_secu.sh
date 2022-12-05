for i in 2 3 5 10 15 20 50; do grep malloc_class freq_"$i"/x264_output | awk '{sum+=$5} END {print sum/NR}'; done
