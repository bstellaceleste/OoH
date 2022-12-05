grep -v "ERROR: can't open /proc/" $1 | grep -v "Watching PID" | grep -v "Est(s)     " | awk '{ print $2}' | grep -v -e '^$' > file_$1.txt

#ecart-type
awk '{for(i=1;i<=NF;i++) {sum[i] += $i; sumsq[i] += ($i)^2}} 
          END {for (i=1;i<=NF;i++) {
          printf "%f \n", sqrt((sumsq[i]-sum[i]^2/NR)/NR)}
         }' file_$1.txt >> tmp_ecart_type_$1

#moyenne
count=0; total=0; for i in $( awk '{ print $1; }' file_$1.txt );do total=$(echo $total+$i | bc ); ((count++)); done; echo "scale=2; $total / $count" | bc >> tmp_moyenne_$1
#mediane
sort -n file_$1.txt | awk ' { a[i++]=$1; } END { print a[int(i/2)]; }' >> tmp_mediane_$1
#max
awk -v a=0 '{if (($1)>a){ a=($1); fi}} END{print a}' file_$1.txt >> tmp_max_$1

#format ecart-type | max | mediane | moyenne
declare -a array
i=1
for file in tmp*
do
    readarray -t tmp < $file
    array+=($tmp)
    if [ $i -eq 4 ]
    then
        echo $1 "${array[*]}" >> stats_finales
    fi
    i=$((i+1))
done

rm tmp_*
rm file_*
echo "${array[*]}"