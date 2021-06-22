#!/bin/bash -l
#SBATCH -p batch            	                                # partition (this is the queue your job will be added to) 
<<<<<<< HEAD
#SBATCH -N 2               	                                # number of nodes (no MPI, so we only use a single node)
#SBATCH -n 2             	                                # number of cores
#SBATCH --ntasks-per-node=1
#SBATCH --time=01:00:00    	                                # walltime allocation, which has the format (D-HH:MM:SS), here set to 1 hour
=======
#SBATCH -N 5               	                                # number of nodes (no MPI, so we only use a single node)
#SBATCH -n 5            	                                # number of cores
#SBATCH --ntasks-per-node=1
#SBATCH --time=3-00:00:00    	                                # walltime allocation, which has the format (D-HH:MM:SS), here set to 1 hour
>>>>>>> 5f48ec99b77a9ead0a4511862584a84d06c8c204
#SBATCH --mem=16GB         	                                # memory required per node (here set to 4 GB)

# Notification configuration 
#SBATCH --mail-type=END					    	# Send a notification email when the job is done (=END)
#SBATCH --mail-type=FAIL   					# Send a notification email when the job fails (=FAIL)
#SBATCH --mail-user=curtis.murray@adelaide.edu.au  		# Email to which notifications will be sent

module load Anaconda3/2020.07
module load R

<<<<<<< HEAD
conda activate gt

mpirun -np 2 ./my_program.sh
=======
conda activate /hpcfs/users/$USER/myconda/envs/gt

mpirun -np 1 ./my_program.sh
>>>>>>> 5f48ec99b77a9ead0a4511862584a84d06c8c204

conda deactivate
