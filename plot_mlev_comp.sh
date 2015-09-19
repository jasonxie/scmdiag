#!/bin/bash

#**************************************
# Driving Script for SCAMDIAG
# For multi-level plotting
# Author: Xin Xie
#**************************************

#VARS="PRECT"
VARS=$SCMMLEVVARS

NOWDIR=$(pwd)

PLOTDIR=$WORKDIR/$PLOTDIR


if [ ! -d $PLOTDIR ]; then
  echo "$PLOTDIR does not exisit, creating..."
  mkdir -pv $PLOTDIR
fi

echo
echo "PLOTTING MULTIPLE LEVEL VARIABLES..."
for VAR in $VARS
do

  echo $VAR"..."

  ncl var=\"$VAR\" plotdir=\"$PLOTDIR\" obsdir=\"$OBSDIR\" testfile=\"$TESTFILE\" cntrfile=\"$OBSFILE\" scmdiag_code=\"$SCMDIAG_CODE\" $SCMDIAG_CODE/plot_mlev_comp.ncl
  convert -density $IMGDENSITY -trim -border 5 -bordercolor '#fff' +repage $PLOTDIR/SCM_mlev_$VAR.ps $PLOTDIR/SCM_mlev_$VAR.png
  rm -f $PLOTDIR/SCM_mlev_$VAR.ps

  ncl var=\"$VAR\" plotdir=\"$PLOTDIR\" obsdir=\"$OBSDIR\" testfile=\"$TESTFILE\" cntrfile=\"$OBSFILE\" scmdiag_code=\"$SCMDIAG_CODE\" $SCMDIAG_CODE/plot_mlev_avg_comp.ncl
  convert -density $IMGDENSITY -trim -border 5 -bordercolor '#fff' +repage $PLOTDIR/SCM_mlev_avg_$VAR.ps $PLOTDIR/SCM_mlev_avg_$VAR.png
  rm -f $PLOTDIR/SCM_mlev_avg_$VAR.ps

#  ncl var=\"$VAR\" plotdir=\"$PLOTDIR\" obsdir=\"$OBSDIR\" testfile=\"$TESTFILE\" scmdiag_code=\"$SCMDIAG_CODE\" $SCMDIAG_CODE/plot_mlev_dc.ncl
#  convert -trim -density 200 -border 5 -bordercolor '#fff' +repage $PLOTDIR/SCM_mlev_dc_$VAR.pdf $PLOTDIR/SCM_mlev_dc_$VAR.png
#  rm -f $PLOTDIR/SCM_mlev_dc_$VAR.pdf

done

