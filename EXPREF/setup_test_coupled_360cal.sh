#Set-up Coupled TEST RUN for Ecowind ACCELERATE
#executables should have already been linked in the auto-compile script.
#the ocean *xml files for the 360 calendar should also already be in the directory

##############################################################################
#EXPORT PATHS - should match compile script setup_Coupled_AMM15_WW3Local
##############################################################################
export REPO_DIR=/<path>/<to>/<your>/<GIT>/<repository> #ecowind git repository path eg. /work/n01/n01/<user>/<wherever_you_cloned_the_GITrepo>/COW_AMM15/
export RUN_DIR=$(pwd) #Run directory (EXPREF)

#set RESTART directory within the run dir.(used in namelist_cfg)
mkdir RESTART

# NEMO files #########################################################
# 2018 May/June 
ln -s /work/n01/n01/shared/COW_AMM15/May2018Test/

# namelists
cp -r $REPO_DIR/EXPREF/files_test_coupled_360cal/namelist_2018_360cal_cfg $RUN_DIR/namelist_oceanonly_cfg
cp -r $REPO_DIR/EXPREF/files_test_coupled_360cal/namelist_cplO2W_360_cfg $RUN_DIR/namelist_cplO2W_360_cfg
cp -r $REPO_DIR/EXPREF/files_test_coupled_360cal/namelist_cplO2W_360_cfg $RUN_DIR/namelist_cfg
cp -r $REPO_DIR/EXPREF/files_test_coupled_360cal/namelist_cpl_ref $RUN_DIR/namelist_ref

# coordinate files 
ln -s ./May2018Test/AMM15/360Cal/COORDS/* .

# rivers 
ln -s /work/n01/n01/shared/jrule/May2018Test/AMM15/Rivers/rivers.nc .

# ocean.nc (made from amm15.restart) for the coupling
ln -s ./May2018Test/AMM15/360Cal/RESTART/ocean.nc $RUN_DIR

# OASIS files ########################################################
cp $REPO_DIR/EXPREF/files_test_coupled_360cal/namcouple $RUN_DIR
ln -s ./May2018Test/OASIS/RMP/* $RUN_DIR #obtained from the Met Office

# WW3 files ##########################################################
#cp wind.nc file from shared directory for testing
#to generate you own wind.nc type file, rotated for the amm15 grid, from ERA5 data see the rotated_pole_coordinate_maker.py script. 
ln -s /May2018Test/WW3/360Cal/NETCDF/*.nc $RUN_DIR

# Alternatively, copy the binary file directly
cp /work/n01/n01/shared/jrule/May2018Test/WW3/360Cal/WIND/2018may_rot_wind.ww3 $RUN_DIR/wind.ww3
cp /work/n01/n01/shared/jrule/May2018Test/WW3/360Cal/WIND/mod_def.ww3 $RUN_DIR

# Copy the ww3_*.nml and ww3_*.inp (the should be generate during the ww3 compile and need ammending for your run - copy for ease)
cp $REPO_DIR/WW3/NML/BACK-ww3_grid.nml $RUN_DIR
cp $REPO_DIR/WW3/NML/params.nml $RUN_DIR
cp $REPO_DIR/WW3/NML/ww3_grid.nml $RUN_DIR
cp $REPO_DIR/WW3/NML/ww3_prnc_052018.nml $RUN_DIR/ww3_prnc.nml
cp $REPO_DIR/WW3/NML/ww3_shel_coupled.nml $RUN_DIR/ww3_shel.nml
cp $REPO_DIR/WW3/NML/ww3_ounf_052018.nml $RUN_DIR/ww3_ounf.nml
#
cp $REPO_DIR/WW3/INP/ww3_prnc.inp $RUN_DIR/ww3_prnc.inp
cp $REPO_DIR/WW3/INP/ww3_shel_052018.inp $RUN_DIR/ww3_shel.inp

#copy nest file - comes from nested run on global ww3 (made by LB).  
cp ./May2018Test/WW3/360Cal/NESTS/nest_GS256A_HadGEM_052018.ww3 $RUN_DIR/nest.ww3

# cp dat - come from the Met Office repo for amm15-ww3 coupled.
# If you want to run ww3 alone but on the amm15 grid the *.dat that you need are the same as for the coupled model.
# the pubblic repository is https://zenodo.org/record/7148687#.Y-tzgoTP2Uk
# To download and unzip the *.dat you can:
#wget "https://zenodo.org/record/7148687/files/AMM15-coupled.tar.gz"
#gunzip AMM15-coupled.tar.gz
#tar -xf AMM15-coupled.tar
#cp $REPO_DIR/WW3/DAT/* $RUN_DIR
cp ./May2018Test/WW3/DAT/* $RUN_DIR

# add points file
cp $REPO_DIR/WW3/points $RUN_DIR

# OTHER FILES ########################################################## 

#slurms
cp $REPO_DIR/EXPREF/SLURMS/runnemo.slurm $RUN_DIR
cp $REPO_DIR/EXPREF/SLURMS/runcoupled.slurm $RUN_DIR
cp $REPO_DIR/EXPREF/SLURMS/runww3grid.slurm $RUN_DIR
cp $REPO_DIR/EXPREF/SLURMS/runww3prnc.slurm $RUN_DIR
cp $REPO_DIR/EXPREF/SLURMS/runww3.slurm $RUN_DIR

#cp executables
# if you used setup_AMM15_ecowind they should already be in you rundir
# if you are building the wind somewhere else, then copy them.

# make sure you're in the run directory
cd $RUN_DIR
