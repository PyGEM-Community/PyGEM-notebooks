#!/bin/bash
: << 'EOF'
example shell script for running global PyGEM calibration and simulation, followed by regional aggregation.
this is meant strictly as an example wrapper template.
note, in practice it is recommended to wrap calibration, simulation, and aggregation separately in case any issues arise
and to keep job run time manageable. in this example we've combined these for simplicity.  

call and execute this script like so:
$./pygem_wrapper.sh
note, if the script does not execute at first you may need to make this wrapper an executable file first like so:
$chmod u+x ./pygem_wrapper.sh
note, to store the output of this shell script call and redirect to a text file like so:
$./pygem_wrapper.sh > output.txt
EOF


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
ncores=4                # how many cores to parallize across - 
                        # note this is currently set up  to parallize
                        # a given region across the specified number of cores
                        # hence if 28 cores are specified, the ~27000 glaciers 
                        # run for Alaska (region 1) will be divided into <1000 
                        # glacier batches that are each processed on a CPU core
                        # set `ncores=1` for no parallelization
########################
#### gcms/scenarios ####
########################
gcms=("BCC-CSM2-MR" "CESM2" "CESM2-WACCM" "EC-Earth3" "EC-Earth3-Veg" "FGOALS-f3-L" "GFDL-ESM4" "INM-CM4-8" "INM-CM5-0" "MPI-ESM1-2-HR" "MRI-ESM2-0" "NorESM2-MM")      # CMIP6 GCMS
scenarios=("ssp245" "ssp370" "ssp585")
########################
######## other #########
########################
nsims=1                 # number of simulations to run for each glacier (1 takes median parameter values from MCMC calibration)
SECONDS=0               # reset time
########################
###### environment #####
########################
source activate /path/to/your/environment
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
        done
    done
done
########################


########################
### aggregation loop ###
########################
# note, directing output elswhere for aggregation, since stats will be printed on the % of glaciers successfully simulated
# also note that the $ncores needed for aggregation may differ 
# aggregation is typically done by region and scenario, so max number of cores needed is typically (#regions) x (#scenarios), i.e. 76 in this case ((19 regions) x (4 scenarios))
postproc_compile_simulations -rgi_region01 $regions -gcm_name $gcms -scenario $scenarios -gcm_startyear 2000 -gcm_endyear 2100 -option_calibration MCMC -ncores $ncores > compile_log.txt
########################


# display runtime
echo "TOTAL RUNTIME: "$(($SECONDS / 3600)) hrs $((($SECONDS / 60) % 60)) min $(($SECONDS % 60)) sec""