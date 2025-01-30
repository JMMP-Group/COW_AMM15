#!/bin/bash
#SBATCH --qos=highmem
#SBATCH --partition=highmem
#SBATCH --tasks-per-node=256
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
# Account
#SBATCH --account=<YourProjectAccount>
# Job Name
#SBATCH --job-name=TESTww3
#SBATCH --time=00:30:00


echo Run started at `date` > WaveWatch_slurmlog.txt
echo ==================================== >> WaveWatch_slurmlog.txt

pwd &> WaveWatch_slurmlog.txt

# the environment consistent with the model build (does this matter??)
module switch PrgEnv-cray PrgEnv-gnu
module load cray-hdf5
module load cray-netcdf
export WWATCH3_NETCDF=NC4
export NETCDF_CONFIG=$(which nc-config)
export WWATCH3_F90=ftn

#export OMP_NUM_THREADS=16
srun --ntasks=256 ./exe/ww3_shel &> wavemodel.log
#srun ./ww3_shel


echo ==================================== >> WaveWatch_slurmlog.txt
echo Run ended at `date` >> WaveWatch_slurmlog.txt

