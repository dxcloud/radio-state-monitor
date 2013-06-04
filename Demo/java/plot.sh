#!/bin/sh

################################################################################
# Author: Chengwu HUANG
# Plot a Time diagram with `.png' extension
# The program `gnuplot' is needed
# The input file must have `.dat' extension
# The file `diagram.gnuplot' must be in the same directory as this file
#
# USAGE: ./plot.sh <filename> <nodeID>
################################################################################

if [ $# -eq 2 ] ; then

  filename=$(basename $1 .dat)
  nodeid="$2:"
  gnuplottemplate=diagram.gnuplot

  grep $nodeid $1 > tmp.dat

  sed '1 i\
  ID Sequence OFF PD IDLE RX TX RSSI Timestamp' tmp.dat > tmp1.dat

  sed -e "s/OUTPUT/${filename}_node_$2\.png/" \
  -e "s/INPUT/tmp1\.dat/" \
  $gnuplottemplate > $filename.gnuplot

  ### Plot with gnuplot
  gnuplot $filename.gnuplot

  ### Delete temporary files
  rm $filename.gnuplot
  rm tmp.dat tmp1.dat

else

  echo "Usage: <filename> <nodeID>"

fi

