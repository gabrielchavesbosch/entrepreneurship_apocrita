#!/bin/bash
#$ -cwd
#$ -j y
#$ -pe parallel 48
#$ -l h_rt=24:0:0
#$ -l infiniband=sdv-ii
#$ -o running_hello.log
#$ -m e
echo "Job starting now."
# load matlab module
module load 'matlab'
# run code
matlab -nodisplay < init_val_calibration.m > result_hello.log
echo "Job ending now."