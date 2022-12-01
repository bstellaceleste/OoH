set terminal pdf
set output 'test.pdf'
set style data histogram
box_wd = 0.3
set boxwidth box_wd
set style fill solid
unset key

#plot 'test.data' using 2:xtic(1), '' u 3

set style histogram rowstacked
plot  newhistogram "Small",\
 'test.data' using 2:xtic(1) index 0,\
     '' using 3 index 0,\
newhistogram "Small",\
 'test.data' using 2:xtic(1) index 1,\
     '' using 3 index 1
