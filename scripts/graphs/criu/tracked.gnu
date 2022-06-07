set terminal pdf

green2 = "#8FBC8F"; orange2 = "#E69F00"; violet1="#660066"; blue3 = "#56B4E9"
newblue1 = "#87A7B3"; newblue2 = "#324756"; newblue3 = "#082032"; newblue4 = "#045491"
pink1 = "#FFB6C1"; pink2 = "#C71585"; pink3 = "#DB7093"
brown1 = "#F5DEB3"; brown2 = "#BC8F8F"; brown3 = "#F4A460"

set style line 1 lc rgb green2 lt 1 lw 1
set style line 2 lc rgb 'black' lt 1 lw 1
set style line 3 lc rgb orange2 lt 2 lw 2
set style line 4 lc rgb newblue4 lt 2 lw 2

set ytics font "Times, 30"
set xtics font "Times, 35"
set ylabel "Time (s)" font "Times,40" offset -3
#set xlabel "Applicaton" font "Times,40" offset 0,-3.5
set title font "Times,40" offset 0,-1.5
set xtics rotate by 30 right
set xtics nomirror
set grid ytics
#--------------------------------------------------------------------------------------------------
set style data histograms
set style fill transparent solid 0.6 noborder
set style histogram cluster gap 1
set offset -0.4,-0.4,0,0
set boxwidth .9

set lmargin 12
set tmargin 5
#-------------------------------------------------------------------------------------------------
set style line 5 \
    linecolor 'black' \
    linetype 1 linewidth 1.5\
    pointtype 0 pointsize 0
#--------------------------------------------------------------------------------------------------
unset key
unset bmargin
set bmargin 7

set output 'tracked_large.pdf'
set yrange[0:350]
set ytics 0,100,300

set title 'tkrzw Config. Large'

plot 'tracked_large.data' u 2:xticlabels(1) notitle ls 2 fill pattern 6 border,\
     '' u 3 notitle ls 1,\
     '' u 4 notitle ls 4,\
     '' u 5 notitle ls 3,\
     'baseline.data' index 0 with linespoints linestyle 5 notitle, \
     ''              index 1 with linespoints linestyle 5 notitle,\
     ''              index 2 with linespoints linestyle 5 notitle,\
     ''              index 3 with linespoints linestyle 5 notitle,\
     ''              index 4 with linespoints linestyle 5 notitle
#--------------------------------------------------------------------------------------------------

set output 'tracked_medium.pdf'
set yrange[0:80]
set ytics 0,20,80

set title 'tkrzw Config. Medium'

plot 'tracked_medium.data'  u 2:xticlabels(1) notitle ls 2 fill pattern 6 border,\
     '' u 3 notitle ls 1,\
     '' u 4 notitle ls 4,\
     '' u 5 notitle ls 3,\
     'baseline.data' index 5 with linespoints linestyle 5 notitle, \
     ''              index 6 with linespoints linestyle 5 notitle,\
     ''              index 7 with linespoints linestyle 5 notitle,\
     ''              index 8 with linespoints linestyle 5 notitle,\
     ''              index 9 with linespoints linestyle 5 notitle

#--------------------------------------------------------------------------------------------------
unset tmargin
set lmargin 14
set output 'tracked_small.pdf'
set yrange[0:40]
set ytics 0,10,40

set title 'tkrzw Config. Small'

plot 'tracked_small.data'   u 2:xticlabels(1) notitle ls 2 fill pattern 6 border,\
     '' u 3 notitle ls 1,\
     '' u 4 notitle ls 4,\
     '' u 5 notitle ls 3,\
     'baseline.data' index 10 with linespoints linestyle 5 notitle, \
     ''              index 11 with linespoints linestyle 5 notitle,\
     ''              index 12 with linespoints linestyle 5 notitle,\
     ''              index 13 with linespoints linestyle 5 notitle,\
     ''              index 14 with linespoints linestyle 5 notitle

#u 2:xticlabels(1) t 'Baseline' ls 2 fs border lc rgb newblue3,\
#     '' u 3 t 'CRIU-EPML' ls 1,\
#     '' u 4 t 'CRIU-/proc' ls 4,\
#     '' u 5 t 'CRIU-SPML' ls 3,\

#--------------------------------------------------------------------------------------------------
set key font "Times,18" tmargin Left reverse maxrows 1 samplen 1.5 width .3 nobox
unset key

set output 'tracked_phoenix.pdf'
set yrange[0:90]
set ytics 0,30,90
set xtics norotate center
set title 'phoenix Config. Large'

plot 'tracked_phoenix.data' u 2:xticlabels(1) t 'Baseline' ls 2 fill pattern 6 border,\
     '' u 3 t 'CRIU-EPML' ls 1,\
     '' u 4 t 'CRIU-/proc' ls 4,\
     '' u 5 t 'CRIU-SPML' ls 3,\
     'baseline.data' index 15 with linespoints linestyle 5 notitle, \
     ''              index 16 with linespoints linestyle 5 notitle,\
     ''              index 17 with linespoints linestyle 5 notitle

