#!/bin/bash

rm log*
touch log

echo "Deleting old samples" >> log

rm data/Samples/*
rm data/Samples.info/*
rm data/Vocab/*
rm data/Tidy_Topics/*
rm data/Tree_Distance/*


echo "Deleting old samples: Done" >> log

wait

echo "Generating sample info" >> log

R CMD BATCH R/phoenix_gen_sample_info.R

echo "Generating sample info: Done" >> log

wait

source n_samp

wait

echo "Running hSBM on $n_samp samples" >> log

for i in $(seq 0 $n_samp)
do
python3.9 Python/phoenix_hSBM.py $i &
done

echo "Running hSBM on $n_samp samples: Done" >> log

wait

echo "Tidying data" >> log

R CMD BATCH R/phoenix_tidy.R

echo "Tidying data: Done" >> log

wait

echo "Getting tree distances" >> log

for i in $(seq 1 $n_samp)
do
python3.9 Python/phoenix_tree_dist.py $i &
done

echo "Getting tree distances: Done" >> log
