set terminal pdf 

green2 = "#8FBC8F"; orange2 = "#E69F00"; violet1="#8064A2"
newblue1 = "#87A7B3"; newblue2 = "#324756"; newblue3 = "#082032"
pink1 ="#FFB6C1"; pink2 ="#C71585"; pink3 ="#DB7093"
brown1 = "#D2B48C"; brown2 ="#BC8F8F"; brown3 = "#F4A460"

set style line 1 lc rgb 'black' lt 1 lw 1
set style line 2 lc rgb 'red' lt 1 lw 1
set style line 3 lc rgb newblue3 lt 1 lw 1

#set style line 1 lc rgb brown2 lt 1 lw 1 #proc
#set style line 2 lc rgb brown3 lt 2 lw 2 #epml
#set style line 3 lc rgb brown1 lt 2 lw 2 #spml

set style data histograms
set style histogram rowstacked
set offset -0.4,-0.4,0,0
set style fill pattern
set boxwidth .9 relative

set ylabel "Time (s)" font "Times,40"  offset -3.5
set ytics font "Times, 30"
set xtics center font "Times, 30" rotate by 90 right
set title font "Times, 40" offset 0,-2.3
set grid ytics
set tics nomirror
#----------------------------------------------------------------------------------------------------
set bmargin 10
set lmargin 10
set tmargin 3
#----------------------------------------------------------------------------------------------------
div=1000000
#--------------------------------------------------------------------------------------------------
unset key
set output 'baby_stacked.pdf'
set yrange [0:6]
set ytics 0,2,6

set title 'tkrzw - baby'

plot newhistogram "Large" font "Times, 35" offset 0,-5,\
     'stacked.data' using ($2/div):xtic(1) index 0 notitle ls 2 fill pattern 6,\
     '' 	       using ($3/div) index 0 notitle ls 1 fill pattern 2,\
     newhistogram "Medium" font "Times, 35" offset 0,-5,\
     'stacked.data' using ($2/div):xtic(1) index 1 notitle ls 2 fill pattern 6,\
     '' 	       using ($3/div) index 1 notitle ls 1 fill pattern 2,\
     newhistogram "Small" font "Times, 35" offset 0,-5,\
     'stacked.data' using ($2/div):xtic(1) index 2 t 'Memory Dump' ls 2 fill pattern 6,\
     '' 	       using ($3/div) index 2 t 'Rest of Checkpoint' ls 1 fill pattern 2

#--------------------------------------------------------------------------------------------------
set key font "Times,30" top right Left reverse maxcols 1 samplen 1.5 box
unset lmargin
set lmargin 12

set output 'cache_stacked.pdf'
set yrange [0:10]
set ytics 0,2.5,10

set title 'tkrzw - cache'

plot newhistogram "Large" font "Times, 35" offset 0,-5,\
     'stacked.data' using ($2/div):xtic(1) index 3 notitle ls 2 fill pattern 6,\
     '' 	       using ($3/div) index 3 notitle ls 1 fill pattern 2,\
     newhistogram "Medium" font "Times, 35" offset 0,-5,\
     'stacked.data' using ($2/div):xtic(1) index 4 notitle ls 2 fill pattern 6,\
     '' 	       using ($3/div) index 4 notitle ls 1 fill pattern 2,\
     newhistogram "Small" font "Times, 35" offset 0,-5,\
     'stacked.data' using ($2/div):xtic(1) index 5 t 'Memory Dump' ls 2 fill pattern 6,\
     '' 	       using ($3/div) index 5 t 'Rest of Checkpoint' ls 1 fill pattern 2

#--------------------------------------------------------------------------------------------------
unset key
set output 'stdhash_stacked.pdf'
set yrange [0:15]
set ytics 0,5,15

set title 'tkrzw - stdhash'

plot newhistogram "Large" font "Times, 35" offset 0,-5,\
     'stacked.data' using ($2/div):xtic(1) index 6 notitle ls 2 fill pattern 6,\
     '' 	       using ($3/div) index 6 notitle ls 1 fill pattern 2,\
     newhistogram "Medium" font "Times, 35" offset 0,-5,\
     'stacked.data' using ($2/div):xtic(1) index 7 notitle ls 2 fill pattern 6,\
     '' 	       using ($3/div) index 7 notitle ls 1 fill pattern 2,\
     newhistogram "Small" font "Times, 35" offset 0,-5,\
     'stacked.data' using ($2/div):xtic(1) index 8 t 'Memory Dump' ls 2 fill pattern 6,\
     '' 	       using ($3/div) index 8 t 'Rest of Checkpoint' ls 1 fill pattern 2

#--------------------------------------------------------------------------------------------------
unset key
set output 'stdtree_stacked.pdf'
set yrange [0:15]
set ytics 0,5,15

set title 'tkrzw - stdtree'

plot newhistogram "Large" font "Times, 35" offset 0,-5,\
     'stacked.data' using ($2/div):xtic(1) index 9 notitle ls 2 fill pattern 6,\
     '' 	       using ($3/div) index 9 notitle ls 1 fill pattern 2,\
     newhistogram "Medium" font "Times, 35" offset 0,-5,\
     'stacked.data' using ($2/div):xtic(1) index 10 notitle ls 2 fill pattern 6,\
     '' 	       using ($3/div) index 10 notitle ls 1 fill pattern 2,\
     newhistogram "Small" font "Times, 35" offset 0,-5,\
     'stacked.data' using ($2/div):xtic(1) index 11 t 'Memory Dump' ls 2 fill pattern 6,\
     '' 	       using ($3/div) index 11 t 'Rest of Checkpoint' ls 1 fill pattern 2

#--------------------------------------------------------------------------------------------------
unset key
set output 'tiny_stacked.pdf'
set yrange [0:15]
set ytics 0,5,15

set title 'tkrzw - tiny'

plot newhistogram "Large" font "Times, 35" offset 0,-5,\
     'stacked.data' using ($2/div):xtic(1) index 12 notitle ls 2 fill pattern 6,\
     '' 	       using ($3/div) index 12 notitle ls 1 fill pattern 2,\
     newhistogram "Medium" font "Times, 35" offset 0,-5,\
     'stacked.data' using ($2/div):xtic(1) index 13 notitle ls 2 fill pattern 6,\
     '' 	       using ($3/div) index 13 notitle ls 1 fill pattern 2,\
     newhistogram "Small" font "Times, 35" offset 0,-5,\
     'stacked.data' using ($2/div):xtic(1) index 14 t 'Memory Dump' ls 2 fill pattern 6,\
     '' 	       using ($3/div) index 14 t 'Rest of Checkpoint' ls 1 fill pattern 2

#--------------------------------------------------------------------------------------------------
unset key
set output 'phoenix_stacked.pdf'
unset yrange

set yrange [0:24]
set ytics 0,6,24

set title 'phoenix'

proc="36.5"
spml="27.9"
set obj 1 rect front at 4,15 size char strlen(proc), char 1.5 fc rgb "white"
set obj 2 rect front at 5,19 size char strlen(spml), char 1.5 fc rgb "white"
set label 1 proc at 4,15 front center font "Times Bold,18"
set label 2 spml at 5,19 front center font "Times Bold,18"

#set label at 2,18 "36.5" right font "Times Bold,22" box

plot newhistogram "kmeans" font "Times, 35" offset 0,-5,\
     'stacked.data' using ($2/div):xtic(1) index 12 notitle ls 2 fill pattern 6,\
     '' 	       using ($3/div) index 15 notitle ls 1 fill pattern 2,\
     newhistogram "pca" font "Times, 35" offset 0,-5,\
     'stacked.data' using ($2/div):xtic(1) index 16 notitle ls 2 fill pattern 6,\
     '' 	       using ($3/div) index 16 notitle ls 1 fill pattern 2,\
     newhistogram "word-count" font "Times, 35" offset 0,-5,\
     'stacked.data' using ($2/div):xtic(1) index 17 t 'Memory Dump' ls 2 fill pattern 6,\
     '' 	       using ($3/div) index 17 t 'Rest of Checkpoint' ls 1 fill pattern 2

