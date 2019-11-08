#!/bin/bash

#SBATCH -n 1
#SBATCH --time=1:00:00
#SBATCH --mem=4000
#SBATCH --array=1
#SBATCH --mail-type=END

# ****************** Load specific matlab module ******************
module load matlab/R2016b

# ****************** Move to data folder ******************
#cd /jukebox/*

# ****************** Run matlab script ******************
matlab -nodesktop -nodisplay -nosplash -r "pwd"
# matlab -nodesktop -nodisplay -nosplash -r "fill with matlab script/function"