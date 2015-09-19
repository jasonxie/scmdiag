
load "$SCMDIAG_CODE/load.ncl"

;*************************************************
; Plotting Script for multi-level average profile
; Author: Xin Xie
;*************************************************

begin

  about    = "SCMDIAG"

  test_fptr = addfile(testfile, "r")
  cntr_fptr = addfile(cntrfile, "r")
; obs_fptr  = addfile("./"+obsdir +"/"+case+"_"+var+".nc", "r")

  testname    = test_fptr@case
  indata_test = test_fptr->$var$(:, :, 0, 0)
  indata_cntr = cntr_fptr->$var$(:, :, 0, 0)

  indata_test_avg = dim_avg_Wrap(indata_test(lev|:, time|:))
  indata_cntr_avg = dim_avg_Wrap(indata_cntr(lev|:, time|:))
; indata_obs_avg  = indata_test

; indata_obs  = obs_fptr->$var$
  indata_time = test_fptr->time
  lev = indata_test_avg&lev

  easyunits( indata_cntr_avg )
  easyunits( indata_test_avg )

; ccof     = esccr( indata_obs, indata_test, 0 )
; avg_test = avg(indata_test)
; avg_obs  = avg(indata_obs)

;==========================================
; initialize graphic workstation
;==========================================

  wks  = gsn_open_wks("oldps", plotdir+"/SCM_mlev_avg_"+var)

  res  = True

  setviewratio( res, 0.75, False)
  easyfonts( res, 0.02)

  ;res@vpWidthF = 0.3
  ;res@vpHeightF = 0.6
  ;res@vpXF = 0.35
  ;res@vpYF = 0.8

; res@gsnDraw = False
; res@gsnFrame = False

; stdfontht = 0.015
; res@tiMainFontHeightF    = stdfontht
; res@tmXBLabelFontHeightF = stdfontht

  res@trYReverse = True

;==========================================
; Line pattern setting
;==========================================
  res@tiMainString  = indata_test@long_name
; res@tiXAxisString = indata_test&time@units
; res@tiYAxisOn     = False
  res@tiYAxisString = "Pressure"

; res@gsnStringFontHeightF = 15
  res@gsnRightString  = indata_test@units
; res@gsnLeftString   = testname
; res@gsnCenterString = "OBS Mean:"+avg_obs+"~C~"+"TEST Mean:"+avg_test+"~C~CC:" + ccof
  
; res@vpKeepAspect = True
; res@vpHeightF = 0.45
; res@vpWidthF  = 0.7

  res@xyLineThicknesses  = (/3, 2/)
  res@xyDashPatterns     = (/0, 0/)
  res@xyLineColors       = (/"black", "red"/)

;==========================================
; setting for special var
;==========================================
  if ( var .eq. "CLOUD") then
    res@trXMinF = 0.0
    res@trXMaxF = 1.0
  end if
;  if ( var .eq. "CLDICE") then
;    res@trXMinF = 0.0
;    res@trXMaxF = 0.00005
;  end if
;  if ( var .eq. "CLDLIQ") then
;    res@trXMinF = 0.0
;    res@trXMaxF = 0.0001
;  end if
;  if ( var .eq. "ICIMR") then
;    res@trXMinF = 0.0
;    res@trXMaxF = 0.0001
;  end if
;  if ( var .eq. "ICWMR") then
;    res@trXMinF = 0.0
;    res@trXMaxF = 0.0005
;  end if
  if ( var .eq. "OMEGA") then
    res@trXMinF = -0.1
    res@trXMaxF =  0.1
  end if
;  if ( var .eq. "Q") then
;    res@trXMinF = 0.0
;    res@trXMaxF = 0.02
;  end if
  if ( var .eq. "T") then
    res@trXMinF = 250
    res@trXMaxF = 300
  end if

  plot = gsn_csm_xy(wks, (/indata_cntr_avg, indata_test_avg/), lev, res)

end

