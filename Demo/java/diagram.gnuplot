#!/bin/gnuplot

set term png
set output 'OUTPUT'

#set style fill solid 1.00 border lt -1
#set xtics 32
#set xrange [0:256]
set xlabel 'Number of packet'
#set yrange [0:1400000]
set ylabel 'Duration (us)'
set title "Radio state duration\nPlot as stacked histogram"
plot 'INPUT' using 2:($3+$4+$5+$6+$7) with filledcurves y1=0 lc rgb 'purple' title 'Transmitting', \
'' using 2:($3+$4+$5+$6) with filledcurves y1=0 lc rgb 'blue' title 'Receiving', \
'' using 2:($3+$4+$5) with filledcurves y1=0 lc rgb 'yellow' title 'Idle', \
'' using 2:($3+$4) with filledcurves y1=0 lc rgb 'green' title 'Power Down', \
'' using 2:($3) with filledcurves y1=0 lc rgb 'red' title 'Off'

