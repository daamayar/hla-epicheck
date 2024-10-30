#!/bin/bash
#
# USAGE: ./run_batch_RMSF.sh  <number of frames> <data_directory> 
#
# <number of frames> corresponds to the number of frames to process.
#
# <data_directory> corresponds to the absolute path to the directory that contains the antigen directories which contain the data to be processed.
#
# Run the script from the same directory where it is located.
#
# This script will generate the RMSF data for each antigen on files like this : <antigen name>_RMSF.dat


CWD=$PWD
dir_data=$2

while read line
do
  cd $line
  antigen=${line%/}
  antigen=${antigen##*/}
  $CWD/run_vmd_RMSF.sh *psf *dcd ${antigen}_RMSF $1 $CWD
done < $dir_data/list_antigens.txt

