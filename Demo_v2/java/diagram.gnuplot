#!/bin/gnuplot

set term png
set output 'OUTPUT'

set style fill solid 1.00 border lt -1
set key outside right top vertical Left reverse noenhanced autotitles columnhead nobox

set style data histograms
set style histogram rowstacked title  offset character 0, 0, 0

set xlabel 'Packet number'
set ylabel 'Duration (us)'

set title "Radio state duration\nPlot as stacked histogram"

i = 7
plot 'INPUT' using 3:xtic(2), for [i=4:7] '' using i

