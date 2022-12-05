set size 1, 1
set term pdf
set title "sk plot"
set output "label.pdf"
set boxwidth 0.75
set style fill solid
plot "label.data"  using 2:xtic(1) with boxes,\
  ""  using 0:2:(sprintf("%3.2f",$2)) with labels notitle,\
  ""  using 0:($3+.1):(sprintf("%3.2f",$3)) with labels notitle
