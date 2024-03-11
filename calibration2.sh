#!/bin/bash
#$ -cwd
#$ -j y
#$ -pe smp 24
#$ -l h_rt=48:0:0
#$ -l h_vmem=3G
#$ -m e
echo "Job starting now."
# load matlab module
module load 'matlab'
# run code
matlab -nosoftwareopengl -nojvm -nodisplay -noFigureWindows -nosplash -nodesktop < init_val_calibration.m > result.log
echo "Job ending now."