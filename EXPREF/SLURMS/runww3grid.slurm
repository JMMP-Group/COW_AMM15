#!/bin/bash
#SBATCH --qos=standard
#SBATCH --partition=standard
#SBATCH --tasks-per-node=256
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
# Account
#SBATCH --account=<YourProjectAccount>
# Job Name
#SBATCH --job-name=WW3_grid
#SBATCH --time=00:05:00


echo Run started at `date` > WaveWatch_slurmlog.txt
echo ==================================== >> WaveWatch_slurmlog.txt

#pwd &> WaveWatch_slurmlog.txt

#cd ${FORCE_DIR}/ww3forcing/AMM15-coupled

pwd &> WaveWatch_slurmlog.txt

#run executable
srun ./exe/ww3_grid


echo ==================================== >> WaveWatch_slurmlog.txt
echo Run ended at `date` >> WaveWatch_slurmlog.txt

