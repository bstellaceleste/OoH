val=`cat num`
sleep 60 && ./bench.sh none $val
echo $(($val+1)) > num
if [ $val -lt 5 ]; then poweroff; fi
