#!/bin/bash
#$ -cwd
#$ -j y
#$ -pe smp 48
#$ -l h_rt=24:0:0
#$ -o running_hello.log
#$ -m e
echo "Job starting now."
# load matlab module
module load 'matlab'
# run code
matlab -nodisplay < init_val_calibration.m > result_hello.log
echo "Job ending now."