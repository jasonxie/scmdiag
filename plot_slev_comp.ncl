
load "$SCMDIAG_CODE/utils/load.ncl"

begin

  about    = "SCMDIAG"

  test_fptr = addfile(testfile, "r")
  obs_fptr  = addfile(obsfile , "r")
; obs_fptr  = addfile("./"+obsdir +"/"+case+"_"+var+".nc", "r")

  testname    = test_fptr@case
  indata_test = test_fptr->$var$(:, 0, 0)
; indata_obs  = indata_test
  indata_obs  = obs_fptr->$var$(:, 0, 0)
  indata_time = test_fptr->time

  easyunits(indata_test)
  easyunits(indata_obs)


;==========================================
; initialize graphic workstation
;==========================================
  wks_res = "ps"
  wks_res@wkPaperSize = "letter"
; wks_res@wkPaperHeightF = 8.0
; wks_res@wkPaperWidthF  = 11.0
; wks_res@wkOrientation  = "landscape"
  wks  = gsn_open_wks(wks_res, plotdir+"/SCM_slev_"+var)

  res  = True

  res@vpKeepAspect = True
  res@vpHeightF = 0.3
  res@vpWidthF  = 0.7
  res@gsnMaximize    = True
  res@gsnBoxMargin   = 0.0 ; for X11
  res@gsnPaperMargin = 0.0 ; for PS,PDF
; res@gsnPaperOrientation = "landscape"

  cam_minmax(var, res)

;==========================================
; tick mark setting
;==========================================
; res@tmXBMode   = "Explicit"
; res@tmXBValues = (/1, 8, 16, 26/)
; res@tmXBLabels = (/"jan 18", "jan 25", "feb 2", "feb 12"/)

;==========================================
; Line pattern setting
;==========================================
  res@gsnYRefLine = 0
  res@xyLineThicknesses  = (/2, 2/)
  res@xyDashPatterns     = (/0, 0/)
  res@xyLineColors       = (/"black", "red"/)

  res@tiMainString  = var+":"+indata_test@long_name
  res@tiXAxisString = indata_test&time@units
  res@tiYAxisOn     = False

  stdfontht = 0.015
  res@tiMainFontHeightF    = stdfontht
  res@tiXAxisFontHeightF   = stdfontht*0.9
  res@tmXBLabelFontHeightF = stdfontht*0.9
  res@tmYLLabelFontHeightF = stdfontht*0.9

  res@gsnRightString  = indata_test@units
  res@gsnLeftString   = testname

  ccof     = esccr( indata_obs, indata_test, 0 )
  avg_test = avg(indata_test)
  avg_obs  = avg(indata_obs)

  res@gsnStringFontHeightF = 10
  res@gsnCenterString = "CONTROL Mean:"+sprintf("%10.3f",avg_obs)+"~C~"+"TEST Mean:"+sprintf("%10.3f",avg_test)+"~C~CC:" + sprintf("%10.3f",ccof)
  
  plot = gsn_csm_xy(wks, indata_time, (/indata_obs, indata_test/), res)
; plot = gsn_csm_xy(wks, indata_time, indata_test, res)

end

