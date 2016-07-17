#!/bin/sh
#PBS -q hpc
#PBS -l nodes=1:ppn=32
#PBS -l walltime=1:00:00
#PBS -l vmem=32gb

# change to submit directory (with executable)
cd $PBS_O_WORKDIR/../experiments

export MALLOC_ARENA_MAX=4

# Load Module
module load matlab/R2016a

# Run experiment
matlab -nodisplay -nosplash -nodesktop -r "optimalControl"
