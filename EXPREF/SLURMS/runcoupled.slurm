#!/bin/bash
#SBATCH --qos=standard
#SBATCH --partition=standard
#SBATCH --nodes=28
#SBATCH --cpus-per-task=1

# Account
#SBATCH --account=<YOUR-ACCOUNT>

# Job Name
#SBATCH --job-name=acc_test
#SBATCH --time=00:15:00


echo Run started at `date` > Coupled_slurmlog.txt
echo ==================================== >> Coupled_slurmlog.txt

pwd &> Coupled_slurmlog.txt

# the environment consistent with the model build (does this matter??)
module swap PrgEnv-cray/8.3.3 PrgEnv-gnu/8.3.3
module swap craype-network-ofi craype-network-ucx
module swap cray-mpich cray-mpich-ucx
module load cray-hdf5-parallel/1.12.2.1
module load cray-netcdf-hdf5parallel/4.9.0.1
module load libfabric

export WWATCH3_NETCDF=NC4
export NETCDF_CONFIG=$(which nc-config)
export WWATCH3_F90=ftn

#  RUN
export OMP_NUM_THREADS=1
SHARED_ARGS="--distribution=block:block --hint=nomultithread --cpus-per-task=2"

#Supposed to do the slurm equivalent of something like:
#mpiexec -np 14 ./nemo : -np 14 ./ww3_shel.exe &> test.log &

srun --unbuffered --het-group=0 --nodes=12 --ntasks-per-node=64 ${SHARED_ARGS} ./nemo.exe : \
 --unbuffered --het-group=1 --nodes=12 --ntasks-per-node=64 ${SHARED_ARGS} ./exe/ww3_shel : \
 --unbuffered --het-group=2 --nodes=2 --ntasks-per-node=64 ${SHARED_ARGS} ./xios_server.exe &> coupled.log

# TEST INDIVIDUALLY TO DEBUG
#srun nemo   #see slurm-3924507.out
#srun ww3_shel  #see slurm-3924514.out
echo ==================================== >> Coupled_slurmlog.txt
echo Run ended at `date` >> Coupled_slurmlog.txt

