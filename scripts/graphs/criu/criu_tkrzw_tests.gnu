set terminal eps size 10,5#large size 1920,1080
set output 'test2.eps'

#set key at screen 0.9,0.9 maxcols 1

set multiplot layout 4,3 #title "Multiplot layout 3, 1" font ",14"

red2 = "#B22222"; green2 = "#8FBC8F"; blue3 = "#56B4E9"; blue2 = "#20B2AA"; brown = "#800000"; orange2 = "#E69F00"
set style line 1 lc rgb blue3 lt 1 lw 1
set style line 2 lc rgb green2 lt 1 lw 1
set style line 3 lc rgb orange2 lt 1 lw 1

set style data histograms
set style histogram cluster gap 1
set offset -0.4,-0.4,0,0
set style fill solid
set boxwidth -1 relative

set ylabel "Time (ms)" font "Times,18"
set xlabel "Benhmark Configuration" font "Times,16"
set ytics font "Times, 18"
set ytics font "Times, 18"
set grid ytics
#set key font "Times, 14"

#******************************

set yrange [0:550]
#set key Left tmargin center reverse maxrows 1 samplen 1 nobox

set label "5.0s" at 2,592 rotate by 90 right font "Times,10"
set label "1.1s" at 2.2,592 rotate by 90 right font "Times,10"
set label "5.5s" at 2.3,592 rotate by 90 right font "Times,10"

set title 'baby'

#set size 0.33,0.6

p 'baby.data' u ($2/1000):xticlabels(1) notitle ls 1 fs pattern 2,\
	    '' u ($3/1000) ls 3 notitle fs pattern 2,\
	    '' u ($4/1000) ls 2 notitle fs pattern 2,\
	    '' u ($5/1000) ls 1 notitle,\
	    '' u ($6/1000) ls 3 notitle,\
	    '' u ($7/1000) ls 2 notitle,\
	    '' u ($8*1000) ls 1 notitle fill pattern 4,\
	    '' u ($9*1000) ls 3 notitle fill pattern 4,\
	    '' u ($10*1000) ls 2 notitle fill pattern 4


set yrange [0:550]
set label "5.0s" at 2,592 rotate by 90 right font "Times,10"
set label "1.1s" at 2.2,592 rotate by 90 right font "Times,10"
set label "5.5s" at 2.3,592 rotate by 90 right font "Times,10"

set title 'baby2'
#set key Left tmargin center reverse maxrows 1 samplen 1 nobox

#set size 0.33,0.6

#set origin 0.33, 0.0
p 'baby.data' u ($2/1000):xticlabels(1) notitle ls 1 fs pattern 2,\
	    '' u ($3/1000) ls 3 notitle fs pattern 2,\
	    '' u ($4/1000) ls 2 notitle fs pattern 2,\
	    '' u ($5/1000) ls 1 notitle,\
	    '' u ($6/1000) ls 3 notitle,\
	    '' u ($7/1000) ls 2 notitle,\
	    '' u ($8*1000) ls 1 notitle fill pattern 4,\
	    '' u ($9*1000) ls 3 notitle fill pattern 4,\
	    '' u ($10*1000) ls 2 notitle fill pattern 4

set yrange [0:550]

set label "5.0s" at 2,592 rotate by 90 right font "Times,10"
set label "1.1s" at 2.2,592 rotate by 90 right font "Times,10"
set label "5.5s" at 2.3,592 rotate by 90 right font "Times,10"

set title 'baby2'
#set key Left tmargin center reverse maxrows 1 samplen 1 nobox

#set size 0.33,0.6

#set origin 0.66, 0.0
p 'baby.data' u ($2/1000):xticlabels(1) notitle ls 1 fs pattern 2,\
	    '' u ($3/1000) ls 3 notitle fs pattern 2,\
	    '' u ($4/1000) ls 2 notitle fs pattern 2,\
	    '' u ($5/1000) ls 1 notitle,\
	    '' u ($6/1000) ls 3 notitle,\
	    '' u ($7/1000) ls 2 notitle,\
	    '' u ($8*1000) ls 1 notitle fill pattern 4,\
	    '' u ($9*1000) ls 3 notitle fill pattern 4,\
	    '' u ($10*1000) ls 2 notitle fill pattern 4



#******************************
#*******************************

set yrange [0:550]
set label "5.0s" at 2,592 rotate by 90 right font "Times,10"
set label "1.1s" at 2.2,592 rotate by 90 right font "Times,10"
set label "5.5s" at 2.3,592 rotate by 90 right font "Times,10"

#set size 0.33,0.5

set title 'baby'
#set origin 0.0, -1
p 'baby.data' u ($2/1000):xticlabels(1) notitle ls 1 fs pattern 2,\
	    '' u ($3/1000) ls 3 notitle fs pattern 2,\
	    '' u ($4/1000) ls 2 notitle fs pattern 2,\
	    '' u ($5/1000) ls 1 notitle,\
	    '' u ($6/1000) ls 3 notitle,\
	    '' u ($7/1000) ls 2 notitle,\
	    '' u ($8*1000) ls 1 notitle fill pattern 4,\
	    '' u ($9*1000) ls 3 notitle fill pattern 4,\
	    '' u ($10*1000) ls 2 notitle fill pattern 4


set yrange [0:550]
set label "5.0s" at 2,592 rotate by 90 right font "Times,10"
set label "1.1s" at 2.2,592 rotate by 90 right font "Times,10"
set label "5.5s" at 2.3,592 rotate by 90 right font "Times,10"

set size 0.33,0.5

set title 'baby2'
#set origin 0.33, 1
p 'baby.data' u ($2/1000):xticlabels(1) notitle ls 1 fs pattern 2,\
	    '' u ($3/1000) ls 3 notitle fs pattern 2,\
	    '' u ($4/1000) ls 2 notitle fs pattern 2,\
	    '' u ($5/1000) ls 1 notitle,\
	    '' u ($6/1000) ls 3 notitle,\
	    '' u ($7/1000) ls 2 notitle,\
	    '' u ($8*1000) ls 1 notitle fill pattern 4,\
	    '' u ($9*1000) ls 3 notitle fill pattern 4,\
	    '' u ($10*1000) ls 2 notitle fill pattern 4

set yrange [0:550]

set label "5.0s" at 2,592 rotate by 90 right font "Times,10"
set label "1.1s" at 2.2,592 rotate by 90 right font "Times,10"
set label "5.5s" at 2.3,592 rotate by 90 right font "Times,10"

#set size 0.33,0.5

set title 'baby2'
#set origin 0.66, 1
p 'baby.data' u ($2/1000):xticlabels(1) notitle ls 1 fs pattern 2,\
	    '' u ($3/1000) ls 3 notitle fs pattern 2,\
	    '' u ($4/1000) ls 2 notitle fs pattern 2,\
	    '' u ($5/1000) ls 1 notitle,\
	    '' u ($6/1000) ls 3 notitle,\
	    '' u ($7/1000) ls 2 notitle,\
	    '' u ($8*1000) ls 1 notitle fill pattern 4,\
	    '' u ($9*1000) ls 3 notitle fill pattern 4,\
	    '' u ($10*1000) ls 2 notitle fill pattern 4
#*********************************
#*******************************

set yrange [0:550]
set label "5.0s" at 2,592 rotate by 90 right font "Times,10"
set label "1.1s" at 2.2,592 rotate by 90 right font "Times,10"
set label "5.5s" at 2.3,592 rotate by 90 right font "Times,10"

#set size 0.33,0.5

set title 'baby'
#set origin 0.0, -1
p 'baby.data' u ($2/1000):xticlabels(1) notitle ls 1 fs pattern 2,\
	    '' u ($3/1000) ls 3 notitle fs pattern 2,\
	    '' u ($4/1000) ls 2 notitle fs pattern 2,\
	    '' u ($5/1000) ls 1 notitle,\
	    '' u ($6/1000) ls 3 notitle,\
	    '' u ($7/1000) ls 2 notitle,\
	    '' u ($8*1000) ls 1 notitle fill pattern 4,\
	    '' u ($9*1000) ls 3 notitle fill pattern 4,\
	    '' u ($10*1000) ls 2 notitle fill pattern 4


set yrange [0:550]
set label "5.0s" at 2,592 rotate by 90 right font "Times,10"
set label "1.1s" at 2.2,592 rotate by 90 right font "Times,10"
set label "5.5s" at 2.3,592 rotate by 90 right font "Times,10"

set size 0.33,0.5

set title 'baby2'
#set origin 0.33, 1
p 'baby.data' u ($2/1000):xticlabels(1) notitle ls 1 fs pattern 2,\
	    '' u ($3/1000) ls 3 notitle fs pattern 2,\
	    '' u ($4/1000) ls 2 notitle fs pattern 2,\
	    '' u ($5/1000) ls 1 notitle,\
	    '' u ($6/1000) ls 3 notitle,\
	    '' u ($7/1000) ls 2 notitle,\
	    '' u ($8*1000) ls 1 notitle fill pattern 4,\
	    '' u ($9*1000) ls 3 notitle fill pattern 4,\
	    '' u ($10*1000) ls 2 notitle fill pattern 4

set yrange [0:550]

set label "5.0s" at 2,592 rotate by 90 right font "Times,10"
set label "1.1s" at 2.2,592 rotate by 90 right font "Times,10"
set label "5.5s" at 2.3,592 rotate by 90 right font "Times,10"

#set size 0.33,0.5

set title 'baby2'
#set origin 0.66, 1
p 'baby.data' u ($2/1000):xticlabels(1) notitle ls 1 fs pattern 2,\
	    '' u ($3/1000) ls 3 notitle fs pattern 2,\
	    '' u ($4/1000) ls 2 notitle fs pattern 2,\
	    '' u ($5/1000) ls 1 notitle,\
	    '' u ($6/1000) ls 3 notitle,\
	    '' u ($7/1000) ls 2 notitle,\
	    '' u ($8*1000) ls 1 notitle fill pattern 4,\
	    '' u ($9*1000) ls 3 notitle fill pattern 4,\
	    '' u ($10*1000) ls 2 notitle fill pattern 4
#*********************************
set yrange [0:550]

set label "5.0s" at 2,592 rotate by 90 right font "Times,10"
set label "1.1s" at 2.2,592 rotate by 90 right font "Times,10"
set label "5.5s" at 2.3,592 rotate by 90 right font "Times,10"

#set size 0.33,0.5

set title 'baby2'
#set origin 0.66, 1
p 'baby.data' u ($2/1000):xticlabels(1) notitle ls 1 fs pattern 2,\
	    '' u ($3/1000) ls 3 notitle fs pattern 2,\
	    '' u ($4/1000) ls 2 notitle fs pattern 2,\
	    '' u ($5/1000) ls 1 notitle,\
	    '' u ($6/1000) ls 3 notitle,\
	    '' u ($7/1000) ls 2 notitle,\
	    '' u ($8*1000) ls 1 notitle fill pattern 4,\
	    '' u ($9*1000) ls 3 notitle fill pattern 4,\
	    '' u ($10*1000) ls 2 notitle fill pattern 4
unset multiplot
