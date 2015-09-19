#!/bin/bash

#**************************************
# Driving Script for SCAMDIAG
# For single-level plotting
# Author: Xin Xie
#**************************************

#VARS="PRECT"
VARS=$SCMSLEVVARS

NOWDIR=$(pwd)

PLOTDIR=$WORKDIR/$PLOTDIR


if [ ! -d $PLOTDIR ]; then
  echo "$PLOTDIR does not exisit, creating..."
  mkdir -pv $PLOTDIR
fi

echo
echo "PLOTTING SINGLE LEVEL VARIABLES..."
for VAR in $VARS
do

  echo $VAR"..."
  ncl var=\"$VAR\" plotdir=\"$PLOTDIR\" obsdir=\"$OBSDIR\" testfile=\"$TESTFILE\" obsfile=\"$OBSFILE\" $SCMDIAG_CODE/plot_slev_comp.ncl
  convert -trim -density $IMGDENSITY -border 5 -rotate -90 -bordercolor '#fff' +repage -trim $PLOTDIR/SCM_slev_$VAR.ps $PLOTDIR/SCM_slev_$VAR.png
  rm -f $PLOTDIR/SCM_slev_$VAR.ps
done

