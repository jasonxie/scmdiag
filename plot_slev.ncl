
load "$SCMDIAG_CODE/utils/load.ncl"

begin

  about    = "SCMDIAG"

  test_fptr = addfile(testfile, "r")
; obs_fptr  = addfile("./"+obsdir +"/"+case+"_"+var+".nc", "r")

  testname    = test_fptr@case
  indata_test = test_fptr->$var$(:, 0, 0)
  indata_obs  = indata_test
; indata_obs  = obs_fptr->$var$
  indata_time = test_fptr->time

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


;==========================================
; setting for special var
;==========================================
a = True
if (a .eq. True) then
  if (var .eq. "CLDHGH") then
    res@trYMinF = 0.0
    res@trYMaxF = 1.2
  end if
  if (var .eq. "CLDMED") then
    res@trYMinF = 0.0
    res@trYMaxF = 1.2
  end if
  if (var .eq. "CLDLOW") then
    res@trYMinF = 0.0
    res@trYMaxF = 1.2
  end if
  if (var .eq. "CLDTOT") then
    res@trYMinF = 0.0
    res@trYMaxF = 1.2
  end if

  if (var .eq. "FLNS") then
    res@trYMinF =    0.0
    res@trYMaxF = 1400.0
  end if
  if (var .eq. "FLNT") then
    res@trYMinF =    0.0
    res@trYMaxF = 1400.0
  end if
  if (var .eq. "FLNTC") then
    res@trYMinF =    0.0
    res@trYMaxF = 1400.0
  end if
  if (var .eq. "FSDS") then
    res@trYMinF =    0.0
    res@trYMaxF = 1400.0
  end if
  if (var .eq. "FSNS") then
    res@trYMinF =    0.0
    res@trYMaxF = 1400.0
  end if
  if (var .eq. "FSNT") then
    res@trYMinF =    0.0
    res@trYMaxF = 1400.0
  end if
  if (var .eq. "FSNTC") then
    res@trYMinF =    0.0
    res@trYMaxF = 1400.0
  end if
  if (var .eq. "LHFLX") then
    res@trYMinF =-300.0
    res@trYMaxF = 300.0
  end if
  if (var .eq. "SHFLX") then
    res@trYMinF =-300.0
    res@trYMaxF = 300.0
  end if
 if (var .eq. "LWCF") then
    res@trYMinF = -400.0
    res@trYMaxF =  400.0
  end if
  if (var .eq. "SWCF") then
    res@trYMinF = -400.0
    res@trYMaxF =  400.0
  end if
  if (var .eq. "PRECC") then
    if ( indata_test@units .eq. "m/s" ) then
	  indata_test = (/ indata_test*86400000 /)
	  indata_test@units = "mm/day"
	end if
    res@trYMinF = 0.0
    res@trYMaxF = 50.0
    indata_test@long_name = "Convective Precipitation"
  end if
  if (var .eq. "PRECL") then
    if ( indata_test@units .eq. "m/s" ) then
	  indata_test = (/ indata_test*86400000 /)
	  indata_test@units = "mm/day"
	end if
    res@trYMinF = 0.0
    res@trYMaxF = 50.0
    indata_test@long_name = "Large scale Precipitation"
  end if
  if (var .eq. "PRECT") then
    if ( indata_test@units .eq. "m/s" ) then
	  indata_test = (/ indata_test*86400000 /)
	  indata_test@units = "mm/day"
	end if
    res@trYMinF = 0.0
    res@trYMaxF = 50.0
    indata_test@long_name = "PRECC+PRECL"
  end if
  if (var .eq. "PBLH") then
    res@trYMinF = 0.0
    res@trYMaxF = 1500.0
  end if
  if (var .eq. "TREFHT") then
    res@trYMinF = 0.0
    res@trYMaxF = 350.0
  end if
  if (var .eq. "TS") then
    res@trYMinF = 250.0
    res@trYMaxF = 320.0
  end if
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
  res@xyLineThicknesses  = (/1, 1/)
; res@xyDashPatterns     = (/0, 1/)
  res@xyLineColors       = (/"black", "red"/)

  res@tiMainString  = var+":"+indata_test@long_name
  res@tiXAxisString = indata_test&time@units
  res@tiYAxisOn     = False


  res@gsnStringFontHeightF = 10
  res@tiMainFontHeightF    = 0.02
  res@tiXAxisFontHeightF   = 0.015
  res@tmXBLabelFontHeightF = 0.015
  res@tmYLLabelFontHeightF = 0.015

  res@gsnRightString  = indata_test@units
  res@gsnLeftString   = testname

  ccof     = esccr( indata_obs, indata_test, 0 )
  avg_test = avg(indata_test)
  avg_obs  = avg_test

 res@gsnCenterString = "OBS Mean:"+avg_obs+"~C~"+"TEST Mean:"+avg_test+"~C~CC:" + ccof
  
; plot = gsn_csm_xy(wks, indata_time, (/indata_test, indata_obs/), res)
  plot = gsn_csm_xy(wks, indata_time, indata_test, res)

end

