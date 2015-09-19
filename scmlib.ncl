
;-------------------------------------------------------
; SCM Library
;-------------------------------------------------------


;-------------------------------------------------------
; Function to set the proper contour range.
;-------------------------------------------------------
; Input Arguments:
; input: resource needed to be modified.
; ratio; X/Y ratio.
;-------------------------------------------------------
undef("cam_minmax")
procedure cam_minmax(var:string, dim:integer, res:logical)
begin
;==========================================
; setting for special var 
;==========================================
if ( dim .eq. 2) then
  if ( var .eq. "ICLDTWP") then
    cnstep = 0.025
    cnmin  = 0.0
    cnmax  = 0.3
  end if
  if ( var .eq. "ICLDIWP") then
    cnstep = 0.025
    cnmin  = 0.0
    cnmax  = 0.3
  end if
  if ( var .eq. "CLOUD") then
    cnstep = 0.1
    cnmin  = 0.0
    cnmax  = 1.0
  end if
  if ( var .eq. "TESTLIQ") then
    cnstep = 0.01
    cnmin  = 0.0
    cnmax  = 0.2
  end if
  if ( var .eq. "TESTICE") then
    cnstep = 0.01
    cnmin  = 0.0
    cnmax  = 0.2
  end if
  if ( var .eq. "CLDICE") then
    cnstep = 0.01
    cnmin  = 0.0
    cnmax  = 0.2
  end if
  if ( var .eq. "CLDLIQ") then
    cnstep = 0.02
    cnmin  = 0.0
    cnmax  = 0.3
   end if
  if ( var .eq. "QRL") then
    cnstep = 0.02
    cnmin  = 0.0
    cnmax  = 0.5
   end if
  if ( var .eq. "QRS") then
    cnstep = 0.02
    cnmin  = 0.0
    cnmax  = 0.5
   end if
  if ( var .eq. "ICIMR") then
    cnstep = 0.001
    cnmin  = 0.0
    cnmax  = 0.03
  end if
  if ( var .eq. "ICWMR") then
    cnstep = 0.02
    cnmin  = 0.0
    cnmax  = 0.3
  end if
  if ( var .eq. "OMEGA") then
    cnstep =  0.2
    cnmin  = -2.0
    cnmax  =  2.0
  end if
  if ( var .eq. "Q") then
    cnstep =  0.005
    cnmin  =  0.0
    cnmax  =  0.03
  end if
  if ( var .eq. "T") then
    cnstep =   10.0
    cnmin  =  180.0
    cnmax  =  300.0
  end if

  delete(res@trYMinF)
  delete(res@trYMaxF)

  res@cnLevelSelectionMode = "ManualLevels"
  res@cnLevelSpacingF =  cnstep
  res@cnMinLevelValF  =  cnmin
  res@cnMaxLevelValF  =  cnmax

end if

if ( dim .eq. 1) then
  if (var .eq. "TGCLDCWP") then
    res@trYMinF = 0.0
    res@trYMaxF = 0.8
  end if
  if (var .eq. "TGCLDLWP") then
    res@trYMinF = 0.0
    res@trYMaxF = 0.8
  end if
  if (var .eq. "TGCLDIWP") then
    res@trYMinF = 0.0
    res@trYMaxF = 0.8
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
    res@trYMaxF = 80.0
  end if
  if (var .eq. "PRECL") then
    res@trYMinF = 0.0
    res@trYMaxF = 80.0
  end if
  if (var .eq. "PRECT") then
    res@trYMinF = 0.0
    res@trYMaxF = 80.0
  end if
end if

end


