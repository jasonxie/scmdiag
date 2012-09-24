#!/bin/bash

#**************************************
# Main Driving Script for SCAMDIAG
# Author: Xin Xie
#**************************************

case=test

#setting the SCAMDIAG code directory
export SCMDIAG_CODE=/home/xiexin/xxcode/scmdiag

#setting the test data directory and observation data directory
export TESTFILE=/home/xiexin/modelrun/scam/testdata/test.nc

export OBSFILE=/home/xiexin/modelrun/scam/testdata/cntr0.nc

export OBSDIR=obs_sta

#setting name of the dir for plotting output
export PLOTDIR=test

#setting the intermediate data output directory
export WORKDIR=/home/xiexin/modelrun/scam/plots

#variables list to plot
export SCMSLEVVARS="CLDHGH CLDLOW CLDMED CLDTOT FLNS FLNT FLNTC FSDS FSNS FSNT FSNTC"
export SCMSLEVVARS=$SCMSLEVVARS" LHFLX SHFLX LWCF SWCF PBLH PRECC PRECL PRECT TREFHT TS"
#export SCMSLEVVARS="PBLH"
export SCMMLEVVARS="ICLDTWP GCLDLWP CLDICE CLDLIQ CLOUD ICIMR ICWMR OMEGA Q T VD01 QRL QRS"
#export SCMMLEVVARS="CLOUD"

export IMGDENSITY=100



#***********************DO NOT TOUCH HERE****************************

#running of the plotting for multi-level and single-level
sh $SCMDIAG_CODE/plot_mlev_comp.sh
sh $SCMDIAG_CODE/plot_slev_comp.sh
cp $SCMDIAG_CODE/scmdiag_webshow_comp.html $WORKDIR/$PLOTDIR


