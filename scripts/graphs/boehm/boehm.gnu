set terminal pdf 

green2 = "#8FBC8F"; orange2 = "#E69F00"; violet1="#8064A2"
newblue1 = "#87A7B3"; newblue2 = "#324756"; newblue3 = "#082032"
pink1 ="#FFB6C1"; pink2 ="#C71585"; pink3 ="#DB7093"
brown1 = "#D2B48C"; brown2 ="#BC8F8F"; brown3 = "#F4A460"

set style line 1 lc rgb 'black' lt 1 lw 1
set style line 2 lc rgb 'red' lt 1 lw 1
set style line 3 lc rgb newblue3 lt 1 lw 1

#set style line 1 lc rgb newblue3 lt 1 lw 1 #proc
#set style line 2 lc rgb brown2 lt 2 lw 2 #epml
#set style line 3 lc rgb newblue2 lt 2 lw 2 #spml

set style data histograms
set style histogram rowstacked
set offset -0.4,-0.4,0,0
set style fill pattern
set boxwidth .9 relative

set title font "Times, 30" offset 0,-1.5
set ylabel "Time (ms)" font "Times,30" offset -1.5
set ytics font "Times, 25"
set xtics font "Times, 25" rotate by 90 right #tc rgb newblue2
set grid ytics
set tics nomirror
set key font "Times,20" top right Left reverse invert maxcols 1 samplen 2 width .4 box

set bmargin 8
set lmargin 10
set tmargin 4

mili=1000
#-------------------------------------------------------------------------------------------------------------------------------------
#unset key
set output 'gcbench_stacked.pdf'
set yrange [0:280]
set ytics 0,70,280

set title 'GCbench' 
plot newhistogram "Large" font "Times, 28" offset 0,-3.5,\
     'stacked.data' using 2:xtic(1) index 0 notitle ls 1 fill pattern 2,\
     '' 	       using 3 index 0 notitle ls 2 fill pattern 6,\
     newhistogram "Medium" font "Times, 28" offset 0,-3.5,\
     'stacked.data' using 2:xtic(1) index 1 notitle ls 1 fill pattern 2,\
     '' 	       using 3 index 1 notitle ls 2 fill pattern 6,\
     newhistogram "Small" font "Times, 28" offset 0,-3.5,\
     'stacked.data' using 2:xtic(1) index 2 t 'Other Cycles' ls 1 fill pattern 2,\
     '' 	       using 3 index 2 t 'First Cycle' ls 2 fill pattern 6
     
#-------------------------------------------------------------------------------------------------------------------------------------
unset key

set output 'pca_stacked.pdf'
set yrange [0:50]
set ytics 0,10,50

set title 'pca'

plot newhistogram "Large" font "Times, 28" offset 0,-3.5,\
     'stacked.data' using ($2/mili):xtic(1) index 3 notitle ls 1 fill pattern 2,\
     '' 	       using ($3/mili) index 3 notitle ls 2 fill pattern 6,\
     newhistogram "Medium" font "Times, 28" offset 0,-3.5,\
     'stacked.data' using ($2/mili):xtic(1) index 4 notitle ls 1 fill pattern 2,\
     '' 	       using ($3/mili) index 4 notitle ls 2 fill pattern 6,\
     newhistogram "Small" font "Times, 28" offset 0,-3.5,\
     'stacked.data' using ($2/mili):xtic(1) index 5 t 'Other Cycles' ls 1 fill pattern 2,\
     '' 	       using ($3/mili) index 5 t 'First Cycle' ls 2 fill pattern 6
#-------------------------------------------------------------------------------------------------------------------------------------

set output 'kmeans_stacked.pdf'
set yrange [0:65]
set ytics 0,15,65

set title 'kmeans'

plot newhistogram "Large" font "Times, 28" offset 0,-3.5,\
     'stacked.data' using ($2/mili):xtic(1) index 6 notitle ls 1 fill pattern 2,\
     '' 	       using ($3/mili) index 6 notitle ls 2 fill pattern 6,\
     newhistogram "Medium" font "Times, 28" offset 0,-3.5,\
     'stacked.data' using ($2/mili):xtic(1) index 7 notitle ls 1 fill pattern 2,\
     '' 	       using ($3/mili) index 7 notitle ls 2 fill pattern 6,\
     newhistogram "Small" font "Times, 28" offset 0,-3.5,\
     'stacked.data' using ($2/mili):xtic(1) index 8 t 'Other Cycles' ls 1 fill pattern 2,\
     '' 	       using ($3/mili) index 8 t 'First Cycle' ls 2 fill pattern 6

#-------------------------------------------------------------------------------------------------------------------------------------
set output 'string-match_stacked.pdf'
set yrange [0:50]
set ytics 0,10,50

set title 'string-match'

plot newhistogram "Large" font "Times, 28" offset 0,-3.5,\
     'stacked.data' using ($2/mili):xtic(1) index 9 notitle ls 1 fill pattern 2,\
     '' 	       using ($3/mili) index 9 notitle ls 2 fill pattern 6,\
     newhistogram "Medium" font "Times, 28" offset 0,-3.5,\
     'stacked.data' using ($2/mili):xtic(1) index 10 notitle ls 1 fill pattern 2,\
     '' 	       using ($3/mili) index 10 notitle ls 2 fill pattern 6,\
     newhistogram "Small" font "Times, 28" offset 0,-3.5,\
     'stacked.data' using ($2/mili):xtic(1) index 11 t 'Other Cycles' ls 1 fill pattern 2,\
     '' 	       using ($3/mili) index 11 t 'First Cycle' ls 2 fill pattern 6

#-------------------------------------------------------------------------------------------------------------------------------------

set output 'histogram_stacked.pdf'
set yrange [0:250]
set ytics 0,50,250

set title 'histogram'

plot newhistogram "Large" font "Times, 28" offset 0,-3.5,\
     'stacked.data' using ($2/mili):xtic(1) index 12 notitle ls 1 fill pattern 2,\
     '' 	       using ($3/mili) index 12 notitle ls 2 fill pattern 6,\
     newhistogram "Medium" font "Times, 28" offset 0,-3.5,\
     'stacked.data' using ($2/mili):xtic(1) index 13 notitle ls 1 fill pattern 2,\
     '' 	       using ($3/mili) index 13 notitle ls 2 fill pattern 6,\
     newhistogram "Small" font "Times, 28" offset 0,-3.5,\
     'stacked.data' using ($2/mili):xtic(1) index 14 t 'Other Cycles' ls 1 fill pattern 2,\
     '' 	       using ($3/mili) index 14 t 'First Cycle' ls 2 fill pattern 6

#-------------------------------------------------------------------------------------------------------------------------------------

set output 'word-count_stacked.pdf'
set yrange [0:60]
set ytics 0,20,60

set title 'word-count'

plot newhistogram "Large" font "Times, 28" offset 0,-3.5,\
     'stacked.data' using ($2/mili):xtic(1) index 15 notitle ls 1 fill pattern 2,\
     '' 	       using ($3/mili) index 15 notitle ls 2 fill pattern 6,\
     newhistogram "Medium" font "Times, 28" offset 0,-3.5,\
     'stacked.data' using ($2/mili):xtic(1) index 16 notitle ls 1 fill pattern 2,\
     '' 	       using ($3/mili) index 16 notitle ls 2 fill pattern 6,\
     newhistogram "Small" font "Times, 28" offset 0,-3.5,\
     'stacked.data' using ($2/mili):xtic(1) index 17 t 'Other Cycles' ls 1 fill pattern 2,\
     '' 	       using ($3/mili) index 17 t 'First Cycle' ls 2 fill pattern 6

#-------------------------------------------------------------------------------------------------------------------------------------
#set key Left tmargin reverse maxrows 3 samplen 1.2 width 1 box font "Times,16"

set output 'matrix-mul_stacked.pdf'
set yrange [0:50]
set ytics 0,10,50

set title 'matrix-mutltiply'

plot newhistogram "Large" font "Times, 28" offset 0,-3.5,\
     'stacked.data' using ($2/mili):xtic(1) index 18 notitle ls 1 fill pattern 2,\
     '' 	       using ($3/mili) index 18 notitle ls 2 fill pattern 6,\
     newhistogram "Medium" font "Times, 28" offset 0,-3.5,\
     'stacked.data' using ($2/mili):xtic(1) index 19 notitle ls 1 fill pattern 2,\
     '' 	       using ($3/mili) index 19 notitle ls 2 fill pattern 6,\
     newhistogram "Small" font "Times, 28" offset 0,-3.5,\
     'stacked.data' using ($2/mili):xtic(1) index 20 t 'Other Cycles' ls 1 fill pattern 2,\
     '' 	       using ($3/mili) index 20 t 'First Cycle' ls 2 fill pattern 6
#-------------------------------------------------------------------------------------------------------------------------------------

