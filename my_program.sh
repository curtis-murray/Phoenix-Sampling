#!/bin/bash

R CMD BATCH R/phoenix_gen_sample_info.R

source n_samp

for i in $(seq 0 $n_samp)
do
python3.9 Python/phoenix_hSBM.py $i &
done

R CMD BATCH R/phoenix_tidy.R

for i in $(seq 1 $n_samp)
do
python3.9 Python/phoenix_tree_dist.py $i &
done
