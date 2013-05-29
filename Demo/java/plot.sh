#!/bin/sh

############################################
# Author: Chengwu HUANG                    #
# Plot a Time diagram with .png extension  #
# The program 'gnuplot' must be installed  #
# The input file must have .dat extension  #
# Check the location of gnuplottemplate    #
#                                          #
# USAGE: ./plot.sh <filename> <nodeID>     #
############################################

if [ $# -eq 2 ] ; then

  filename=$(basename $1 .dat)
  nodeid="$2:"
  gnuplottemplate=diagram.gnuplot

  grep $nodeid $1 > tmp.dat

  sed -e "s/OUTPUT/${filename}_node_$2\.png/" \
  -e "s/INPUT/tmp\.dat/" \
  $gnuplottemplate > $filename.gnuplot

  # Plot with gnuplot
  gnuplot $filename.gnuplot

  rm $filename.gnuplot
  rm tmp.dat

else

  echo "Usage: <filename> <nodeID>"

fi

