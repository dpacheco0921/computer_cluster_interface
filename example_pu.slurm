#!/bin/bash

#SBATCH -n 1

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
# --mail-user=*@princeton.edu
# to get email notifications after job is finished

# ****************** Load specific matlab module ******************
module load matlab/R2016b

# ****************** Move to data folder ******************
#cd /jukebox/*

# *** if using MATLAB paralel parpool ***
# Create a local work directory
# mkdir -p /tmp/$USER-$SLURM_JOB_ID

# ****************** Run matlab script ******************
matlab -nodesktop -nodisplay -nosplash -r "pwd"
# matlab -nodesktop -nodisplay -nosplash -r "fill with matlab script/function"

# *** if using MATLAB paralel parpool ***
# Cleanup local work directory
# rm -rf /tmp/$USER-$SLURM_JOB_ID
