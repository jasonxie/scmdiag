

load "$SCMDIAG_CODE/load.ncl"

;*************************************************
; Plotting Script for multi-level time series
; Author: Xin Xie
;*************************************************

begin

  about    = "SCMDIAG"

  test_fptr  = addfile(testfile, "r")
  cntr_fptr  = addfile(cntrfile , "r")

  testname    = test_fptr@case
  indata_test = test_fptr->$var$(:, :, 0, 0)
  indata_cntr = cntr_fptr->$var$(:, :, 0, 0)
  indata_time = test_fptr->time


  easyunits(indata_test)
  easyunits(indata_cntr)

  avg_test = avg(indata_test)
  avg_cntr = avg(indata_cntr)
; ccof     = esccr( indata_cntr, indata_test, 0 )

;==========================================
; initialize graphic workstation
;==========================================

  wks  = gsn_open_wks("oldps", plotdir+"/SCM_mlev_"+var)

  res  = True

; res@gsnDraw = False
; res@gsnFrame = False

  res@cnFillOn = True
  res@cnFillMode = "RasterFill"
  res@cnLinesOn  = False
; res@cnLevelFlags = "LineOnly"

  cmap = RGBtoCmap(scmdiag_code+"/rgb/amwg.rgb")
  ;gsn_define_colormap(wks, cmap)
  gsn_define_colormap(wks, "ncl_default")
  ;gsn_define_colormap(wks, "MPL_rainbow")

  res@gsnSpreadColors   = True
  res@lbLabelAutoStride = True
  res@lbOrientation     = "vertical"
  res@pmLabelBarWidthF  = 0.08
  res@lbLabelFontHeightF= 0.015

; stdfontht = 0.02
; res@tiMainFontHeightF    = stdfontht
; res@tmXBLabelFontHeightF = stdfontht*0.9
; res@tmYLLabelFontHeightF = stdfontht*0.9

; res@tiXAxisFontHeightF   = stdfontht*0.9
  easyfonts( res, 0.02)

  res@trYReverse = True


;==========================================
; tick mark setting
;==========================================
; res@tmXBMode   = "Explicit"
; res@tmXBValues = (/1, 8, 16, 26/)
; res@tmXBLabels = (/"jan 18", "jan 25", "feb 2", "feb 12"/)

;==========================================
; Line pattern setting
;==========================================
  res@tiMainString  = indata_test@long_name
  res@tiXAxisString = indata_test&time@units
; res@tiYAxisOn     = False
  res@tiYAxisString = "Pressure"

  res@gsnStringFontHeightF = 12
  res@gsnRightString  = indata_test@units
; res@gsnCenterString = "OBS Mean:"+avg_cntr+"~C~"+"TEST Mean:"+avg_test+"~C~CC:" + ccof
  
  res@vpKeepAspect = True
  res@vpHeightF = 0.45
  res@vpWidthF  = 0.65

  cam_minmax(var, 2, res)

  res@gsnLeftString   = "mean:"+decimalPlaces(avg_cntr, 2, True)
  plot_cntr = gsn_csm_contour(wks, indata_cntr(lev|:, time|:), res)
  res@gsnLeftString   = "mean:"+decimalPlaces(avg_test, 2, True)
  plot_test = gsn_csm_contour(wks, indata_test(lev|:, time|:), res)

  diff = indata_test
;  printVarSummary(indata_test)
;  printVarSummary(indata_cntr)
  diff = (/ indata_test-indata_cntr /)
  diffmag = max( abs(diff) )

  cnlevels = decimalPlaces(fspan(-diffmag, diffmag, 12), 2, True)
  res@cnLevelSelectionMode = "ExplicitLevels"
  res@cnLevels = cnlevels
;  res@cnLevelSpacingF =  2.*diffmag/13.
;  res@cnMinLevelValF  = -diffmag
;  res@cnMaxLevelValF  =  diffmag

  ;gsn_define_colormap(wks, "BlueWhiteOrangeRed")

  delete(res@gsnLeftString)
  plot_diff = gsn_csm_contour(wks, diff(lev|:, time|:), res)

end

