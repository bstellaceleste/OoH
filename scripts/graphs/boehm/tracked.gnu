set terminal pdf size 6,2.3

red2 = "#B22222"; green2 = "#8FBC8F"; blue3 = "#56B4E9"; blue2 = "#20B2AA"; brown = "#492201"; orange2 = "#E69F00"; violet1="#660066"
newblue1 = "#87A7B3"; newblue2 = "#324756"; newblue3 = "#082032"; newblue4 = "#045491"; gray = "#696969"
set style line 1 lc rgb green2 lt 1 lw 1
set style line 2 lc rgb 'black' lt 1 lw 1
set style line 3 lc rgb orange2 lt 2 lw 2
set style line 4 lc rgb newblue4 lt 2 lw 2

#set style line 1 lc rgb green2 lt 1 lw 1
#set style line 2 lc rgb 'black' lt 1 lw 1
#set style line 3 lc rgb blue3 lt 2 lw 2
#set style line 4 lc rgb orange2 lt 2 lw 2
#set style line 6 lc rgb newblue4 lt 2 lw 2

set ytics font "Times, 25"
set xtics font "Times, 30"
set grid ytics
set tics nomirror
set ylabel "Time (s)" font "Times,30" offset -1
set xtics rotate by 90 right

set title font "Times,30" offset 0,-1.5
set bmargin 8
set lmargin 9
set tmargin 3

div=1000
#--------------------------------------------------------------------------------------------------

set style data histograms
set style fill transparent solid 0.6 noborder
set style histogram cluster gap 2
set offset -0.4,-0.4,0,0
set boxwidth .9
#--------------------------------------------------------------------------------------------------
set style line 5 \
    linecolor 'black' \
    linetype 1 linewidth 1.5\
    pointtype 0 pointsize 0
#--------------------------------------------------------------------------------------------------
unset key

set output 'tracked_large.pdf'
set yrange[0:12]
set ytics 0,4,12

set title 'Benchmark Config. Large'

plot 'tracked_large.data' u ($2/div):xticlabels(1) t 'Baseline' ls 2 fill pattern 6 border,\
     '' u ($3/div) t 'Boehm-EPML' ls 1,\
     '' u ($4/div) t 'Boehm-/proc' ls 4,\
     '' u ($5/div) t 'Boehm-SPML' ls 3,\
     'baseline.data' index 0 with linespoints linestyle 5 notitle, \
     ''              index 1 with linespoints linestyle 5 notitle,\
     ''              index 2 with linespoints linestyle 5 notitle,\
     ''              index 3 with linespoints linestyle 5 notitle,\
     ''              index 4 with linespoints linestyle 5 notitle,\
     ''              index 5 with linespoints linestyle 5 notitl
#--------------------------------------------------------------------------------------------------
unset key
#set key at 4.6,2.5 font "Times,15" Left reverse maxrows 2 samplen 1.2 width .5 box
unset lmargin
set lmargin 7

set output 'tracked_medium.pdf'
unset yrange
set yrange[0:3]
set ytics 0,1,3

set title 'Benchmark Config. Medium'

plot 'tracked_medium.data'   u ($2/div):xticlabels(1) t 'Baseline' ls 2 fill pattern 6 border,\
     '' u ($3/div) t 'Boehm-EPML' ls 1,\
     '' u ($4/div) t 'Boehm-/proc' ls 4,\
     '' u ($5/div) t 'Boehm-SPML' ls 3,\
     'baseline.data' index 6 with linespoints linestyle 5 notitle, \
     ''              index 7 with linespoints linestyle 5 notitle,\
     ''              index 8 with linespoints linestyle 5 notitle,\
     ''              index 9 with linespoints linestyle 5 notitle,\
     ''              index 10 with linespoints linestyle 5 notitle,\
     ''              index 11 with linespoints linestyle 5 notitle

#--------------------------------------------------------------------------------------------------
set key font "Times,18" top center Left reverse maxrows 2 samplen 1.2 width .5 box
unset lmargin
set lmargin 9

set output 'tracked_small.pdf'
set yrange[0:2]
set ytics 0,.5,2

set title 'Benchmark Config. Small'

plot 'tracked_small.data'   u ($2/div):xticlabels(1) t 'Baseline' ls 2 fill pattern 6 border,\
     '' u ($3/div) t 'Boehm-EPML' ls 1,\
     '' u ($4/div) t 'Boehm-/proc' ls 4,\
     '' u ($5/div) t 'Boehm-SPML' ls 3,\
     'baseline.data' index 12 with linespoints linestyle 5 notitle, \
     ''              index 13 with linespoints linestyle 5 notitle,\
     ''              index 14 with linespoints linestyle 5 notitle,\
     ''              index 15 with linespoints linestyle 5 notitle,\
     ''              index 16 with linespoints linestyle 5 notitle,\
     ''              index 17 with linespoints linestyle 5 notitle

#--------------------------------------------------------------------------------------------------


