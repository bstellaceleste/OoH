set terminal pdf

set output 'test_line.pdf'

set style line 5 \
    linecolor 'gray' \
    linetype 2 linewidth 3\
    pointtype 0 pointsize 0

set yrange[0:300]
plot 'baseline.data' index 0 with linespoints linestyle 5 notitle, \
     ''                   index 1 with linespoints linestyle 5 notitle
