#!/bin/bash

<<<<<<< HEAD
rm log*
touch log

echo "Deleting old samples" >> log
wait
rm data/Samples/*
rm data/Samples.info/*
rm data/Vocab/*
rm data/Tidy_Topics/*
rm data/Tree_Distance/*
wait
echo "Deleting old samples: Done" >> log
wait

echo "Generating sample info" >> log
wait

R CMD BATCH R/phoenix_gen_sample_info.R

wait
echo "Generating sample info: Done" >> log

wait

source n_samp

wait

echo "Running hSBM on $n_samp samples" >> log
wait

for i in $(seq 0 $n_samp)
do
python3 Python/phoenix_hSBM.py $i &
done

wait
echo "Running hSBM on $n_samp samples: Done" >> log

wait

echo "Tidying data" >> log

wait
R CMD BATCH R/phoenix_tidy.R

wait
echo "Tidying data: Done" >> log

wait

echo "Getting tree distances" >> log
wait
for i in $(seq 1 $n_samp)
do
python3 Python/phoenix_tree_dist.py $i &
done
wait
echo "Getting tree distances: Done" >> log
wait
=======
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
>>>>>>> 5f48ec99b77a9ead0a4511862584a84d06c8c204
