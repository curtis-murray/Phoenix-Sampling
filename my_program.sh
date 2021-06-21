#!/bin/bash

rm data/Samples/*
rm data/Samples.info/*
rm data/Tidy_Topics/*
rm data/Tree_Distance/*
wait
R CMD BATCH R/phoenix_gen_sample_info.R
wait
source n_samp
wait
t=0
for i in $(seq 0 $(($n_samp/5)))
do
  for j in $(seq 1 5)
  do
    python3.9 Python/phoenix_hSBM.py $(($i*5+$j-1)) &
  done
  wait
done
wait
R CMD BATCH R/phoenix_tidy.R
wait
for i in $(seq 1 $n_samp)
do
python3.9 Python/phoenix_tree_dist.py $i &
done
