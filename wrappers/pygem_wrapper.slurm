#!/bin/bash
: << 'EOF'
example shell script for running global PyGEM calibration and simulation

call and execute this script like so:
$sbatch ./pygem_wrapper.slurm
note, if the script does not execute at first you may need to make this wrapper an executable file first like so:
$chmod u+x ./pygem_wrapper.slurm
EOF

#SBATCH -J pygem_wrapper            # job name
#SBATCH --nodes=1                   # number of nodes
#SBATCH --ntasks=1                  # number of tasks
#SBATCH --cpus-per-task=128         # how many cores to parallize across???

# variable declarations
########################
###### RGI region ######
########################
regs=$(seq 1 19)        # say we want to do a global run, all RGI regions
# regs=(1)                # say we want to run just Alaska
# regs=(13 14 15)         # say we want to run just High-Mountain Asia
########################
### parallelization? ###
########################
export ncores=$SLURM_CPUS_PER_TASK
                        # how many cores to parallize across - 
                        # note this is currently set up  to parallize
                        # a given region across the specified number of cores
                        # hence if 28 cores are specified, the ~27000 glaciers 
                        # run for Alaska (region 1) will be divided into <1000 
                        # glacier batches that are each processed on a CPU core
                        # set `ncores=1` for no parallelization
########################
#### gcms/scenarios ####
########################
gcms=("AWI-CM-1-1-MR" "CMCC-ESM2" "EC-Earth3" "INM-CM4-8" "MPI-ESM1-2-HR" "MRI-ESM2-0" "NorESM2-MM" "TaiESM1")      # CMIP6 GCMS
scenarios=("ssp245" "ssp370" "ssp585")
########################
######## other #########
########################
nsims=1                 # number of simulations to run for each glacier (1 takes median parameter values from MCMC calibration)
SECONDS=0               # reset time
########################
###### environment #####
########################
# modify anaconda module loading and environment activation based on your machine setup
module load aocc/3.2.0  
module load anaconda3/2021.05
source activate /trace/group/rounce/btober/.conda/envs/pygem
########################


########################
### calibration loop ###
########################
# note, this loop can be commented out and skipped if using calibration results from Rounce et al. (2023)
for reg in ${regs[@]}; do
    # create emulator
    run_calibration -rgi_region01 $reg -ref_startyear 2000 -ref_endyear 2020 -ref_gcm_name ERA5 -ncores $ncores -option_calibration emulator
    # develop priors from emulator
    run_mcmc_priors -rgi_region01 $reg
    # MCMC calibration
    run_calibration -rgi_region01 $reg -ref_startyear 2000 -ref_endyear 2020 -ref_gcm_name ERA5 -ncores $ncores -option_calibration MCMC
done
########################


########################
### simulation loop ####
########################
# note, this nested for loop goes through the specified gcm's, scenarios, and regions
# change the simulation start and end year as desired
for gcm in ${gcms[@]}; do
    for scen in ${scenarios[@]}; do
        for reg in ${regions[@]}; do
            run_simulation -rgi_region01 $reg -gcm_startyear 2000 -gcm_endyear 2100 -gcm_name $gcm -scenario $scen -ncores $ncores  -option_dynamics OGGM -option_calibration MCMC -nsims 1
########################

# display runtime
echo "TOTAL RUNTIME: "$(($SECONDS / 3600)) hrs $((($SECONDS / 60) % 60)) min $(($SECONDS % 60)) sec""