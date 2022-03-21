#!/bin/bash

#SBATCH -n 1

# partition to use (priority, short, medium, long, mpi, interactive)
#SBATCH -p short

# time to request
#SBATCH --time=1:00:00

# RAM memory to request
#SBATCH --mem=4000

# number of jobs to submit
#SBATCH --array=1

# number of cores to use for this task
#SBATCH --cpus-per-task=1

# You could also add:
# --mail-type=END
# Options: BEGIN, END, FAIL, ALL
# --mail-user=*@hms.harvard.edu
# to get email notifications after job is finished

#SBATCH -o slurm_%A_%a.out

# ****************** Load specific matlab module ******************
module load matlab/2021b

# ****************** Move to data folder ******************
#cd /jukebox/*

# *** if using MATLAB paralel parpool ***
# Create a local work directory
# mkdir -p /tmp/$USER-$SLURM_JOB_ID

# ****************** Run matlab script ******************
matlab -nodesktop -nodisplay -nosplash -batch "pwd"
# matlab -nodesktop -nodisplay -nosplash -batch "fill with matlab script/function"

# *** if using MATLAB paralel parpool ***
# Cleanup local work directory
# rm -rf /tmp/$USER-$SLURM_JOB_ID
