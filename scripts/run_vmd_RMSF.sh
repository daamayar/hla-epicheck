#!/bin/bash

dir_script=$5
bash -l -c "source ~/.bashrc; vmd -dispdev text -e $dir_script/RMSF.tcl -args $1 $2 $3 $4 &"
