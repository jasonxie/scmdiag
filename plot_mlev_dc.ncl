
load "$SCMDIAG_CODE/utils/load.ncl"

;*************************************************
; Plotting NCL Script
; For multi-level diurnal cycle 
; Author: Xin Xie
;*************************************************

begin

  about    = "SCMDIAG"

  test_fptr = addfile(testfile, "r")
; obs_fptr  = addfile("./"+obsdir +"/"+case+"_"+var+".nc", "r")

  testname    = test_fptr@case
  indata_test = test_fptr->$var$(:, :, 0, 0)
  indata_obs  = indata_test
; indata_obs  = obs_fptr->$var$


  ntime = dimsizes(indata_test&time)
  nlev  = dimsizes(indata_test&lev)


;Get the time information and convert to "minute" unit
  indata_time = indata_test&time
  time   = ut_calendar( indata_time, 0)
  minute_tmp =  time(:,3)*60 + time(:,4)

;sometimes time info in the data is not accurate
;tune it a little
  minute = floattointeger(minute_tmp)
  filltenind = ind( (minute % 10) .eq. 9)
  minute(filltenind) = minute(filltenind) + 1
; print(time(:,3) +" "+time(:,4)+" "+minute+" "+indata_time)
  zerominute = ind(minute .eq. 1440)
  if ( .not. ismissing(zerominute) ) then
    minute( zerominute ) = 0
  end if
  minutestep = floattointeger(minute(1)-minute(0))

;get the daily cycle time length
  ndc = 1440/minutestep
  timedc = new( ndc, integer)
  do i = 0, ndc-1
    timedc(i) = minutestep*(i)
  end do

;Construct the new daily variation data array
  indata_test_dc = new( (/ndc, nlev/), typeof(indata_test), getFillValue(indata_test) )
  indata_test_dc = 0
  indata_test_dc!0 = "time"
  indata_test_dc!1 = "lev"

  indata_test_dc&time = timedc
  indata_test_dc&time@unit = "the minute of the day"

;average the at the same time of the day
;fill the data in indata_test_dc
  do i = 0, ndc-1
    index = ind( minute .eq. timedc(i) )
    if (dimsizes(index) .gt. 1) then
       indata_test_dc(i,:) = dim_avg_Wrap( indata_test(lev|:, time|index) )
    else
       indata_test_dc(i,:) = indata_test(lev|:, time|index)
    end if
    delete(index)
  end do


; ccof     = esccr( indata_obs, indata_test, 0 )
; avg_test = avg(indata_test)
; avg_obs  = avg(indata_obs)


;==========================================
; initialize graphic workstation
;==========================================

  wks  = gsn_open_wks("pdf", plotdir+"/SCM_mlev_dc_"+var)

  res  = True

  res@gsnDraw = False
  res@gsnFrame = False

  res@cnFillOn = True
  res@cnLinesOn = False
  res@cnLevelFlags = "LineOnly"

  cmap = RGBtoCmap(scmdiag_code+"/rgb/amwg.rgb")
  gsn_define_colormap(wks, cmap)

  res@gsnSpreadColors   = True
  res@lbLabelAutoStride = True
  res@lbOrientation     = "vertical"
  res@pmLabelBarWidthF  = 0.08
  res@lbLabelFontHeightF= 0.015

  stdfontht = 0.015
  res@tiMainFontHeightF    = stdfontht
  res@tmXBLabelFontHeightF = stdfontht
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
  res@tiMainString  = var+":"+indata_test@long_name
  res@tiXAxisString = indata_test&time@units
; res@tiYAxisOn     = False
  res@tiYAxisString = "Pressure"

  res@gsnStringFontHeightF = 15
  res@gsnRightString  = indata_test@units
  res@gsnLeftString   = testname
; res@gsnCenterString = "OBS Mean:"+avg_obs+"~C~"+"TEST Mean:"+avg_test+"~C~CC:" + ccof
  
  res@vpKeepAspect = True
  res@vpHeightF = 0.45
  res@vpWidthF  = 0.7

;==========================================
; setting for special var
;==========================================
  if ( var .eq. "CLOUD") then
    res@cnLevelSelectionMode = "ManualLevels"
    res@cnLevelSpacingF = 0.1
    res@cnMinLevelValF  = 0.0
    res@cnMaxLevelValF  = 1.0
  end if
  if ( var .eq. "CLDICE") then
    res@cnLevelSelectionMode = "ManualLevels"
    res@cnLevelSpacingF = 0.01
    res@cnMinLevelValF  = 0.0
    res@cnMaxLevelValF  = 0.2
    res@gsnRightString  = "g/kg"
    tempdata = indata_test_dc
    indata_test_dc = indata_test_dc*1000
    copy_VarMeta(tempdata, indata_test_dc)
  end if
  if ( var .eq. "CLDLIQ") then
    res@cnLevelSelectionMode = "ManualLevels"
    res@cnLevelSpacingF = 0.02
    res@cnMinLevelValF  = 0.0
    res@cnMaxLevelValF  = 0.3
    res@gsnRightString  = "g/kg"
    tempdata = indata_test_dc
    indata_test_dc = indata_test_dc*1000
    copy_VarMeta(tempdata, indata_test_dc)
   end if
  if ( var .eq. "ICIMR") then
    res@cnLevelSelectionMode = "ManualLevels"
    res@cnLevelSpacingF = 0.00002
    res@cnMinLevelValF  = 0.0
    res@cnMaxLevelValF  = 0.0001
  end if
  if ( var .eq. "ICWMR") then
    res@cnLevelSelectionMode = "ManualLevels"
    res@cnLevelSpacingF = 0.00002
    res@cnMinLevelValF  = 0.0
    res@cnMaxLevelValF  = 0.0002
  end if
  if ( var .eq. "OMEGA") then
    res@cnLevelSelectionMode = "ManualLevels"
    res@cnLevelSpacingF =  0.01
    res@cnMinLevelValF  = -0.05
    res@cnMaxLevelValF  =  0.05
  end if
  if ( var .eq. "Q") then
    res@cnLevelSelectionMode = "ManualLevels"
    res@cnLevelSpacingF = 0.002
    res@cnMinLevelValF  = 0.0
    res@cnMaxLevelValF  = 0.02
  end if
  if ( var .eq. "T") then
    res@cnLevelSelectionMode = "ManualLevels"
    res@cnLevelSpacingF =  10.0
    res@cnMinLevelValF  = 180
    res@cnMaxLevelValF  = 300
  end if


  indata_obs_dc = indata_test_dc

  plot_test = gsn_csm_contour(wks, indata_test_dc(lev|:, time|:), res)

  res@gsnLeftString = "obs"
  plot_obs  = gsn_csm_contour(wks, indata_obs_dc(lev|:, time|:), res)

  panelres = True
  panelres@gsnPanelRowSpec = True

  gsn_panel(wks, (/plot_test, plot_obs/), (/1,1/), panelres)

end

