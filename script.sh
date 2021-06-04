#!/bin/bash -l                                                  # -l needed to overcome CommandNotFonudError in slurm job
#SBATCH -p batch            	                                # partition (this is the queue your job will be added to) 
#SBATCH -N 2               	                                # number of nodes (no MPI, so we only use a single node)
#SBATCH -n 2             	                                # number of cores
#SBATCH --ntasks-per-node=1
#SBATCH --time=01:00:00    	                                # walltime allocation, which has the format (D-HH:MM:SS), here set to 1 hour
#SBATCH --mem=4GB         	                                # memory required per node (here set to 4 GB)

# Notification configuration 
#SBATCH --mail-type=END					    	# Send a notification email when the job is done (=END)
#SBATCH --mail-type=FAIL   					# Send a notification email when the job fails (=FAIL)
#SBATCH --mail-user=curtis.murray@adelaide.edu.au  		# Email to which notifications will be sent

module load Anaconda3/2020.07
module load R

conda activate /hpcfs/users/$USER/myconda/envs/gt

mpirun -np 2 ./my_program.sh

conda deactivate
