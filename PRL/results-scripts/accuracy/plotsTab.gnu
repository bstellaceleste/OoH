set terminal postscript enhanced eps color
set output "wss_res_prl_pml_vmware.eps"
set size 1,1
set multiplot layout 1,1

set datafile sep " "
set origin 0,0
set style line 80 lt 0 lc rgb "#808080"
set border 3 back ls 80 
set style line 81 lt 0 lc rgb "#808080" lw 0.5

set grid xtics
set grid ytics
set grid mxtics
set grid mytics

set yrange [0:512]
set xrange [0:330]
set ytics nomirror
set xtics 30
set xtics offset 0,0,0
set ylabel "WSS (MB)" offset 1,0,0  font ",14"
set xlabel "Time (sec)"  font ",14"
set ytics  norangelimit autofreq offset 1,0,0
set grid y
set title "RWRW workload"  font ",14"
set key right bottom
plot "./expe_vmware_prl_pml_constant" u 1:2 lc rgb "#D0D000" lt 2 lw 2 ps 1 pt 6 w lp t "PML",\
	"./expe_vmware_prl_pml_constant" u 1:3 lc rgb "#A00000" lt 3 lw 2 ps 1 pt 9 w lp t "PRL",\
	"./expe_vmware_prl_pml_constant" u 1:4 lc rgb "#0000A0" lt 4 lw 2 ps 1 pt 13 w lp t "VMWARE",\
	"./expe_vmware_prl_pml_constant" u 1:5 lc rgb "#B200B2" lt 5 lw 2 ps 0.5 pt 5 w lp t "EXPECTED",\

#############################################################################
reset 
#unset  multiplot

set origin 0,0
set size 1,1
set style line 80 lt 0 lc rgb "#808080"
set border 3 back ls 80 
set style line 81 lt 0 lc rgb "#808080" lw 0.5

set grid xtics
set grid ytics
set grid mxtics
set grid mytics

set yrange [0:512]
set xrange [0:330]
set ytics nomirror
set xtics  30
set xtics offset 0,0,0
set ylabel "WSS (MB)" offset 1,0,0  font ",14"
set xlabel "Time (sec)"  font ",14" 
set ytics  norangelimit autofreq offset 1,0,0
set grid y
set title "RRWW workload"  font ",14"
set key right bottom
plot "./expe_vmware_prl_pml_rrrwww" u 1:2 lc rgb "#D0D000"  lt 2 lw 2 ps 1 pt 6 w lp t "PML",\
	"./expe_vmware_prl_pml_rrrwww" u 1:3 lc rgb "#A00000" lt 3 lw 2 ps 1 pt 9 w lp t "PRL",\
	"./expe_vmware_prl_pml_rrrwww" u 1:4 lc rgb "#0000A0" lt 4 lw 2 ps 1 pt 13 w lp t "VMWARE",\
	"./expe_vmware_prl_pml_rrrwww" u 1:5 lc rgb "#B200B2" lt 5 lw 2 ps 1 pt 5 w lp t "EXPECTED",\
####################################################################################
reset 
#unset  multiplot
 
set origin 0,0
set size 1,1
set style line 80 lt 0 lc rgb "#808080"
set border 3 back ls 80 
set style line 81 lt 0 lc rgb "#808080" lw 0.5

set grid xtics
set grid ytics
set grid mxtics
set grid mytics

set yrange [0:512]
set xrange [0:330]
set ytics nomirror
set xtics  30
set xtics offset 0,0,0
set ylabel "WSS (MB)" offset 1,0,0  font ",14"
set xlabel "Time (sec)"  font ",14" 
set ytics  norangelimit autofreq offset 1,0,0
set grid y
set title "WWRR workload"  font ",14"
set key right bottom
plot "./expe_vmware_prl_pml_wwwrrr" u 1:2 lc rgb "#D0D000"  lt 2 lw 1 ps 1 pt 6 w lp t "PML",\
	"./expe_vmware_prl_pml_wwwrrr" u 1:3 lc rgb "#A00000" lt 3 lw 1 ps 1 pt 9 w lp t "PRL",\
	"./expe_vmware_prl_pml_wwwrrr" u 1:4 lc rgb "#0000A0" lt 4 lw 1 ps 1 pt 13 w lp t "VMWARE",\
	"./expe_vmware_prl_pml_wwwrrr" u 1:5 lc rgb "#B200B2" lt 5 lw 1 ps 1 pt 5 w lp t "EXPECTED",\


unset multiplot
