set terminal pdf size 6,2.5

red2 = "#B22222"; green2 = "#8FBC8F"; blue3 = "#56B4E9"; blue2 = "#20B2AA"; brown = "#492201"; orange2 = "#E69F00"; violet1="#660066"
newblue1 = "#87A7B3"; newblue2 = "#324756"; newblue3 = "#082032"; newblue4 = "#045491"; gray = "#696969"
set style line 1 lc rgb green2 lt 1 lw 1
set style line 2 lc rgb 'black' lt 1 lw 1
set style line 3 lc rgb orange2 lt 2 lw 2
set style line 4 lc rgb newblue4 lt 2 lw 2

set style data histograms
set style histogram cluster gap 1
set style fill transparent solid 0.7 noborder
set boxwidth .9 relative

set ylabel "Time (s)" font "Times,20" offset -1
set ytics font "Times, 18"
set xtics center font "Times, 18" rotate by 90 right
set grid ytics
#set border 2 front 
set tics nomirror scale 0.75
set format '%g'
#-----------------------------------------------------------------------------------------------------
set bmargin 7
set lmargin 8
set tmargin 3
#----------------------------------------------------------------------------------------------------
mili=1000000
#--------------------------------------------------------------------------------------------------
set style line 5 \
    linecolor 'black' \
    linetype 3 dt 3 linewidth 1\
    pointtype 0 pointsize 0
#--------------------------------------------------------------------------------------------------
set key font "Times,14" above Left reverse maxrow 1 samplen .8 width .3 nobox
#unset key
set output 'mem_write.pdf'
set yrange [0:1.2]
set ytics 0,0.3,1.2

set label at 4.15,1.25 "1.6"  right font "Times Bold,16" #cache
set label at 8.15,1.25 "4.1"  right font "Times Bold,16" #stdhash
set label at 12.15,1.25 "4.4"  right font "Times Bold,16" #stdtree
set label at 16.15,1.25 "5.2"  right font "Times Bold,16" #tiny
set label at 17.15,1.25 "2.7"  right font "Times Bold,16" #tiny
set label at 18.15,1.25 "1.4"  right font "Times Bold,16" #tiny
set label at 21.15,1.25 "3.0"  right font "Times Bold,16" #pca

plot newhistogram "baby" font "Times, 20"  offset 0,-2.5,\
     'mem_write.data' using ($2/mili):xtic(1) index 0 t 'CRIU-/proc' ls 4,\
     '' 	       using ($3/mili) index 0 t 'CRIU-SPML' ls 3,\
     '' 	       using ($4/mili) index 0 t 'CRIU-EPML' ls 1,\
     ''		       index 6 with linespoints linestyle 5 notitle,\
     newhistogram "cache" font "Times, 20"  offset 0,-2.5,\
     'mem_write.data' using ($2/mili):xtic(1) index 1 notitle ls 4,\
     '' 	       using ($3/mili) index 1 notitle ls 3,\
     '' 	       using ($4/mili) index 1 notitle ls 1,\
     ''		       index 7 with linespoints linestyle 5 notitle,\
     newhistogram "stdhash" font "Times, 20"  offset 0,-2.5,\
     'mem_write.data' using ($2/mili):xtic(1) index 2 notitle ls 4,\
     '' 	       using ($3/mili) index 2 notitle ls 3,\
     '' 	       using ($4/mili) index 2 notitle ls 1,\
     ''		       index 8 with linespoints linestyle 5 notitle,\
     newhistogram "stdtree" font "Times, 20"  offset 0,-2.5,\
     'mem_write.data' using ($2/mili):xtic(1) index 3 notitle ls 4,\
     '' 	       using ($3/mili) index 3 notitle ls 3,\
     '' 	       using ($4/mili) index 3 notitle ls 1,\
     ''		       index 9 with linespoints linestyle 5 notitle,\
     newhistogram "tiny" font "Times, 20"  offset 0,-2.5,\
     'mem_write.data' using ($2/mili):xtic(1) index 4 notitle ls 4,\
     '' 	       using ($3/mili) index 4 notitle ls 3,\
     '' 	       using ($4/mili) index 4 notitle ls 1,\
     ''		       index 10 with linespoints linestyle 5 notitle,\
     newhistogram "phoenix" font "Times, 20"  offset 0,-2.5,\
     'mem_write.data' using ($2/mili):xtic(1) index 5 notitle ls 4,\
     '' 	       using ($3/mili) index 5 notitle ls 3,\
     '' 	       using ($4/mili) index 5 notitle ls 1,\
#-------------------------------------------------------------------------------------------------
