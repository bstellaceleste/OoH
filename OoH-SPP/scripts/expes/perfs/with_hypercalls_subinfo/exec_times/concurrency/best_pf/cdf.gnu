set terminal pdf

set ytics font "Times, 20"
set xtics font "Times, 20"
set grid
set tics nomirror
#unset border
#set border 3

set ylabel "CDF" font "Times,20" offset -.5 
set xlabel "Security Distance (KB)" font "Times,20" offset 0,-.5
set key right Left invert reverse maxcols 1 samplen 1 width .7 nobox font "Times,18"

set bmargin 4
#set lmargin 10

#path="freq_10/plot"

set format x "10^{%L}"
#set xrange [0.004:1000]
set ytics .2
set logscale x
set mxtics 10 #minor xtics --> for subgraduations
#set yrange [0:1]
#set ytics 0,.2,1

set output "cdf_concurrency.pdf"

plot "2_cdf" u 1:2 t '#app=2' w lp lw .2,\
     "3_cdf" u 1:2 t '#app=3' w lp lw .2,\
     "4_cdf" u 1:2 t '#app=4' w lp lw .2,\
     "5_cdf" u 1:2 t '#app=5' w lp lw .2,\
     "6_cdf" u 1:2 t '#app=6' w lp lw .2,\
     "7_cdf" u 1:2 t '#app=7' w lp lw .2,\
     "8_cdf" u 1:2 t '#app=8' w lp lw .2,\
     "9_cdf" u 1:2 t '#app=9' w lp lw .2
