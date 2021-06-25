#!/bin/bash

source n_samp

for i in $(seq 251 $n_samp)
do
  	echo $(date -u) "Running tree dist on samp $i"
        sbatch --dependency=afterany:7837755 tree_dist.sh $i 
done






