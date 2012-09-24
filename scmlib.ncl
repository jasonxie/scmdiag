
;-------------------------------------------------------
; SCM Library
;-------------------------------------------------------

;-------------------------------------------------------
; Function to change the units for human reading.
;-------------------------------------------------------
; Input Arguments:
; input: resource needed to be modified.
; ratio; X/Y ratio.
;-------------------------------------------------------
undef("easyunits")
procedure easyunits(x:numeric)
begin

if (x@units .eq. "kg/kg") then
  x = (/x*1000/)
  x@units = "g/kg"
end if
if (x@units .eq. "K/s") then
  x = (/x*3600/)
  x@units = "K/hour"
end if
if (x@units .eq. "m/s") then
  x = (/x*86400000/)
  x@units = "mm/day"
end if

end


;-------------------------------------------------------
; Function to set the proper contour range.
;-------------------------------------------------------
; Input Arguments:
; input: resource needed to be modified.
; ratio; X/Y ratio.
;-------------------------------------------------------
undef("cam_minmax")
procedure cam_minmax(var:string, res:logical)
begin
;==========================================
; setting for special var 
;==========================================
  if ( var .eq. "ICLDTWP") then
    res@cnLevelSelectionMode = "ManualLevels"
    res@cnLevelSpacingF = 0.025
    res@cnMinLevelValF  = 0.0
    res@cnMaxLevelValF  = 0.3
  end if
  if ( var .eq. "CLOUD") then
    res@cnLevelSelectionMode = "ManualLevels"
    res@cnLevelSpacingF = 0.1
    res@cnMinLevelValF  = 0.0
    res@cnMaxLevelValF  = 1.0
  end if
  if ( var .eq. "TESTLIQ") then
    res@cnLevelSelectionMode = "ManualLevels"
    res@cnLevelSpacingF = 0.01
    res@cnMinLevelValF  = 0.0
    res@cnMaxLevelValF  = 0.2
  end if
  if ( var .eq. "TESTICE") then
    res@cnLevelSelectionMode = "ManualLevels"
    res@cnLevelSpacingF = 0.01
    res@cnMinLevelValF  = 0.0
    res@cnMaxLevelValF  = 0.2
  end if
  if ( var .eq. "CLDICE") then
    res@cnLevelSelectionMode = "ManualLevels"
    res@cnLevelSpacingF = 0.01
    res@cnMinLevelValF  = 0.0
    res@cnMaxLevelValF  = 0.2
  end if
  if ( var .eq. "CLDLIQ") then
    res@cnLevelSelectionMode = "ManualLevels"
    res@cnLevelSpacingF = 0.02
    res@cnMinLevelValF  = 0.0
    res@cnMaxLevelValF  = 0.3
   end if
  if ( var .eq. "QRL") then
    res@cnLevelSelectionMode = "ManualLevels"
    res@cnLevelSpacingF = 0.02
    res@cnMinLevelValF  = 0.0
    res@cnMaxLevelValF  = 0.5
   end if
  if ( var .eq. "QRS") then
    res@cnLevelSelectionMode = "ManualLevels"
    res@cnLevelSpacingF = 0.02
    res@cnMinLevelValF  = 0.0
    res@cnMaxLevelValF  = 0.5
   end if
  if ( var .eq. "ICIMR") then
    res@cnLevelSelectionMode = "ManualLevels"
    res@cnLevelSpacingF = 0.0002
    res@cnMinLevelValF  = 0.0
    res@cnMaxLevelValF  = 0.002
  end if
  if ( var .eq. "ICWMR") then
    res@cnLevelSelectionMode = "ManualLevels"
    res@cnLevelSpacingF = 0.002
    res@cnMinLevelValF  = 0.0
    res@cnMaxLevelValF  = 0.02
  end if
  if ( var .eq. "OMEGA") then
    res@cnLevelSelectionMode = "ManualLevels"
    res@cnLevelSpacingF =  0.2
    res@cnMinLevelValF  = -2.0
    res@cnMaxLevelValF  =  2.0
  end if
  if ( var .eq. "Q") then
    res@cnLevelSelectionMode = "ManualLevels"
    res@cnLevelSpacingF =  0.005
    res@cnMinLevelValF  =  0.0
    res@cnMaxLevelValF  =  0.03
  end if
  if ( var .eq. "T") then
    res@cnLevelSelectionMode = "ManualLevels"
    res@cnLevelSpacingF =   10.0
    res@cnMinLevelValF  =  180.0
    res@cnMaxLevelValF  =  300.0
  end if


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
    res@trYMinF = -300.0
    res@trYMaxF =  300.0
  end if
  if (var .eq. "SWCF") then
    res@trYMinF = -800.0
    res@trYMaxF =  800.0
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
  if (var .eq. "PRECC") then
    res@trYMinF = 0.0
    res@trYMaxF = 50.0
  end if
  if (var .eq. "PRECL") then
    res@trYMinF = 0.0
    res@trYMaxF = 50.0
  end if
  if (var .eq. "PRECT") then
    res@trYMinF = 0.0
    res@trYMaxF = 50.0
  end if

end


