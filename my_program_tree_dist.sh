#!/bin/bash

source n_samp

R CMD BATCH R/phoenix_tidy.R
wait
for i in $(seq 1 $n_samp)
do
python3.9 Python/phoenix_tree_dist.py $i &
done
