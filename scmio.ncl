
;-------------------------------------------------------
; SCMDIAG's IO Function
;-------------------------------------------------------

undef("scmdiag_putvar_cam4")
procedure scmdiag_putvar_cam4(outfptr:file,infptr:file,varname:string,opt:string)
begin
  if ( isfilevar(infptr, varname) ) then
    outfptr->$varname$ = (/ infptr->$varname$ /)
  else
    if ( opt .eq. "E") then
      print("["+opt+"] Variable "+varname+" missing in input file!exit...")
	   exit()
    else
      print("["+opt+"] Variable "+varname+" missing in input file!")
    end if
  end if
end


;-------------------------------------------------------
; Function to check dimension consistency
;-------------------------------------------------------
undef("scmdiag_checksdim")
function scmdiag_checksdim(testvar:numeric, needvar:numeric)

begin
  testvardim = dimsizes(testvar)
  needvardim = dimsizes(needvar)
  if ( testvardim(0) .ne. needvardim(0) ) then
    print("single dimension check not passed in var "+testvar@varname+"!")
    exit()
  else
    print("single dimension check passed in var "+testvar@varname+"...")
  end if
  return (/ testvar /)
end


undef("scmdiag_checkmdim")
function scmdiag_checkmdim(testvar:numeric, needvar:numeric)
begin
  testvardim = dimsizes(testvar)
  needvardim = dimsizes(needvar)
  if ( any(testvardim(0:1) .ne. needvardim(0:1)) ) then
    print("multi dimension check not passed in var "+testvar@varname+"!")
    exit()
  else
    print("multi dimension check passed in var "+testvar@varname+"...")
  end if
  return (/ testvar /)
end


undef("scmunits")
function scmunits(x:numeric)
begin
  oldunits = x@units
  newunits = oldunits
  if ( oldunits .eq. "mb/hour" ) then
    newunits = "Pa/s"
    x = (/x/)*0.0277777778
  end if
  if ( oldunits .eq. "g/kg/hour" ) then
    newunits = "kg/kg/s"
    x = (/x/)/3600000.
  end if
  if ( oldunits .eq. "K/hour" ) then
    newunits = "K/s"
    x = (/x/)/3600.
  end if
  if ( oldunits .eq. "g/kg" ) then
    newunits = "kg/kg"
    x = (/x/)/1000.
  end if
  if ( (oldunits .eq. "mb") .or. (oldunits .eq. "hP") ) then
    newunits = "Pa"
    x = (/x/)*100.
  end if
  if ( oldunits .eq. "C" ) then
    newunits = "K"
    x = (/x/)+273.
  end if
  if ( oldunits .ne. newunits) then
    x@units = newunits
    print(" ("+x@long_name+") Converting "+oldunits+" to "+newunits)
  end if
  if ( isatt(x, "missing_value") .and. (x@missing_value .ne. x@_FillValue) ) then
    x@_FillValue = x@missing_value
    print(" ("+x@long_name+") Conforming _FillValue to missing_value")
  end if

  return x
end


