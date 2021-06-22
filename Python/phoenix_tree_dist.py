import pandas as pd
import numpy as np
import os
import timeit
import cProfile
import re
import time
import sys
import glob

if not os.path.exists("data/Tree_Distance"):
    os.system("mkdir data/Tree_Distance")

# INPUT number of samples
sample = int(sys.argv[1])

#os.system("touch data/Tree_Distance/running_sample_"+str(sample))
print("Tree distance on sample: " + str(sample))

if len(glob.glob("data/Tree_Distance/sample_"+str(sample)+".csv")) > 0:
    print("Already done " + str(sample))
    quit()
 
# Data loading
# Tidy topics
df = pd.read_csv("data/Tidy_Topics/tidy_topics_str.csv")
# Vocab
Vocab = pd.read_csv("data/Vocab/Vocab.csv")[['word_ID_full', 'freq']].set_index('word_ID_full').T.to_dict('list')
n_words = len(Vocab)

# Preprocessing data
# Filter to full data
full_data = df.query("Sample == 0")[["word_ID_full","topic"]].set_index('word_ID_full').T.to_dict('list')
# Get sample data
sample_data = df.query("Sample == @sample")[["word_ID_full","topic"]].set_index('word_ID_full').T.to_dict('list')

def total_dist(full_data, sample_data):
    total_d = 0
    max_depth_full = len(list(full_data.items())[1][1][0].split("-"))
    max_depth_sample = len(list(sample_data.items())[1][1][0].split("-"))
    # Nested through upper triangle of adjacency matrix computing weighted
    # path length on each itteration
    for i in range(1,n_words+1):
        for j in range(i+1,n_words+1):
            total_d += weighted_diff_path_length(i,j, full_data, sample_data, max_depth_full, max_depth_sample)
    return total_d

def weighted_diff_path_length(i,j, full_data, sample_data, max_depth_full, max_depth_sample):
    # Computed the weighted difference in path lenghts
    # weighted by p_word(i) and p_word(j)
    d_full = path_length(i,j, full_data, max_depth_full)
    d_samp = path_length(i,j, sample_data, max_depth_sample)
    d = abs((d_full - d_samp)*p_word(i)*p_word(j))
    return d

def p_word(i):
    # Returns p(word | full corpus)
    # Given as the empirical frequency
    p = Vocab.get(i)[0]
    return p

def path_length(i,j,data, max_depth):
    # Funciton to compute path lengths between distinct words

    topic_i = data.get(i)
    topic_j = data.get(j)
    # If either or both words are not part of the data return the max path length (2*depth)
    if (topic_i is None) | (topic_j is None):
        return max_depth*2
    # If the words are the same then the path length is 0
    # Never true as only take upper triangle
    if i == j:
        return 0
    topic_i = topic_i[0].split("-")
    topic_j = topic_j[0].split("-")
    # import string and look for substrings and stuff
    # Loop through hierarchy, starting at deepest level
    # If words are in same topic return distance (starting at 2)
    # Othewise move up hierarcy and add 2 to path length
    for depth in range(max_depth):
        if topic_i[depth] == topic_j[depth]:
            return (depth+1)*2

d = total_dist(full_data, sample_data)

print("Distance of " + str(d))

pd.DataFrame({"sample": [sample], "distance": [d]}).to_csv("data/Tree_Distance/sample_"+str(sample)+".csv", index = False, header=False)