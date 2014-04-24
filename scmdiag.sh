#!/bin/bash

#**************************************
# Main Driving Script for SCAMDIAG
# Author: Xin Xie
#**************************************

#setting the SCAMDIAG code directory
export SCMDIAG_CODE=/R2/xxie/xxgit/scmdiag

#setting the test data directory and observation data directory
export TESTFILE=/R2/xxie/modeltest/camrun/camscm/run/camrun.cam.h0.1995-07-19-00000.nc
export OBSDIR=obs_sta

#setting name of the dir for plotting output
export PLOTDIR=test1

#setting the intermediate data output directory
export WORKDIR=/R2/xxie/mzhang

#variables list to plot
export SCMSLEVVARS="CLDHGH CLDLOW CLDMED CLDTOT FLNS FLNT FSDS FSNS FSNT FSNTC"
export SCMSLEVVARS=$SCMSLEVVARS" LHFLX SHFLX LWCF SWCF PBLH PRECC PRECL PRECT TREFHT TS"
#export SCMSLEVVARS="PBLH"
export SCMMLEVVARS="CLDICE CLDLIQ CLOUD ICIMR ICWMR OMEGA Q T"
#export SCMMLEVVARS="CLOUD"

export IMGDENSITY=100


#***********************DO NOT TOUCH HERE****************************

#running of the plotting for multi-level and single-level
sh $SCMDIAG_CODE/plot_mlev.sh
sh $SCMDIAG_CODE/plot_slev.sh
cp $SCMDIAG_CODE/scmdiag_webshow.html $WORKDIR/$PLOTDIR

