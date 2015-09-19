
load "$SCMDIAG_CODE/load.ncl"

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

  cam_minmax(var, 1, res)
  upper = max ((/max(indata_test), max(indata_obs)/) )
  if ( upper .gt. res@trYMaxF ) then
     res@trYMaxF = upper
  end if

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
  res@xyLineThicknesses  = (/3, 3/)
  res@xyDashPatterns     = (/0, 0/)
  res@xyLineColors       = (/"black", "red"/)

  res@tiMainString  = indata_test@long_name
  res@tiXAxisString = indata_test&time@units
  res@tiYAxisOn     = False

  easyfonts(res, 0.02)

; res@gsnLeftString   = testname

  ccof     = esccr( indata_obs, indata_test, 0 )
  avg_test = avg(indata_test)
  avg_obs  = avg(indata_obs)

  res@gsnStringFontHeightF = 12
  res@gsnRightString = indata_test@units
  res@gsnLeftString  = "CC:" + sprintf("%8.3f",ccof)
  res@gsnCenterString = "CNTR Mean:"+sprintf("%8.3f",avg_obs)+" TEST Mean:"+sprintf("%8.3f",avg_test)
  
  plot = gsn_csm_xy(wks, indata_time, (/indata_obs, indata_test/), res)
; plot = gsn_csm_xy(wks, indata_time, indata_test, res)

end

