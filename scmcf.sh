#!/bin/bash

#**************************************
# Main Driving Script for SCAMDIAG
# Author: Xin Xie
#**************************************

#setting the SCAMDIAG code directory
export SCMDIAG_CODE=/R2/xxie/modelrun/scmdiag

#setting the test data directory and observation data directory
export NTIME=744
export NLEV=37
export INPUTOPT=cam4
export INPUTNC=/R2/xxie/modelrun/cfinput.nc
export WORKDIR=/R2/xxie/modelrun

export OBSDIR=obs_sta

#***********************DO NOT TOUCH HERE****************************

rm -f $WORKDIR/cf.nc
ncl -n opt=\"$INPUTOPT\" $SCMDIAG_CODE/data_cf.ncl

