
load "$SCMDIAG_CODE/load.ncl"
load "$SCMDIAG_CODE/scmio.ncl"

begin

  opt   = getenv("INPUTOPT")
  about = "SCMDIAG"

  workdir = getenv("WORKDIR")
  cf_fptr = addfile(workdir+"/"+case+".nc", "crw")

  if (opt .eq. "cam4") then
    inputnc      = getenv("INPUTNC")
    inputnc_fptr = addfile(inputnc, "r")
    nlev  = dimsizes( inputnc_fptr->lev)
    ntime = dimsizes( inputnc_fptr->time)
  end if

  if (opt .eq. "arm") then
    inputnc      = getenv("INPUTNC")
    inputnc_fptr = addfile(inputnc, "r")
    nlev  = dimsizes( inputnc_fptr->lev)
    ntime = dimsizes( inputnc_fptr->time)
;    nlev  = stringtointeger( getenv("NLEV")  )
;    ntime = stringtointeger( getenv("NTIME") )
  end if
  print("data source from "+opt)
  print("inputfile: "+inputnc)


  print("target time number "+ntime)
  print("target level number "+nlev)
  nlat = 1
  nlon = 1

;create dimension variables "time" and "lev"
  time  = new( (/ntime/), float)
  time  = 0.0
  time@units = ""

  lev   = new( (/nlev/) , float)
  lev   = 0.0
  lev@units  = "Pa"

  lat   = new( (/nlat/) , float)
  lat   = 0.
  lat@units = "degree_north"

  lon   = new( (/nlon/) , float)
  lon   = 0.
  lon@units = "degree_east"

;create data variable for data to fill
  slevvar = new( (/ntime, nlat, nlon/), float)
  slevvar!0 = "time"
  slevvar!1 = "lat"
  slevvar!2 = "lon"
  slevvar&lat  = lat
  slevvar&lon  = lon
  slevvar&time = time

  mlevvar = new( (/ntime, nlev, nlat, nlon/), float)
  mlevvar!0 = "time"
  mlevvar!1 = "lev"
  mlevvar!2 = "lat"
  mlevvar!3 = "lon"
  mlevvar&lat  = lat
  mlevvar&lon  = lon
  mlevvar&lev  = lev
  mlevvar&time = time

  slevvars=(/ (/"Ps"    , "[E]Surface Pressure"          , "Pa"   , "float", "E"/), \
      	     (/"Ptend" , "[I]Surface Pressure Tendency" , "Pa/s" , "float", "I"/), \
              (/"lhflx" , "[O]Surface Latent Heat Flux"  , "W/m2" , "float", "O"/), \
              (/"shflx" , "[O]Surface Sensible Heat Flux", "W/m2" , "float", "O"/), \
              (/"Tsair" , "[O]Surface Air Temperature"   , "K"    , "float", "O"/), \
              (/"Tg"    , "[O]Surface Temperature"       , "K"    , "float", "O"/)  \
       	  /)
  mlevvars=(/ (/"T"       , "[E]Temperature"                        , "K"      , "float", "E"/), \
              (/"divT"    , "[E]Horizontal Temp Advection Tendency" , "K/s"    , "float", "E"/), \
       	     (/"vertdivT", "[E]Vertical Temp Advection Tendency"   , "K/s"    , "float", "E"/), \
              (/"q"       , "[E]Water Vapor Mixing Ratio"           , "kg/kg"  , "float", "E"/), \
              (/"divq"    , "[E]Horizontal Q Advection Tendency"    , "kg/kg/s", "float", "E"/), \
              (/"vertdivq", "[E]Vertical Q Advection Tendency"      , "kg/kg/s", "float", "E"/), \
      	     (/"omega"   , "[E]Vertical Pressure Velocity"         , "Pa/s"   , "float", "E"/), \
              (/"u"       , "[I]U Wind"                             , "m/s"    , "float", "I"/), \
              (/"v"       , "[I]V Wind"                             , "m/s"    , "float", "I"/), \
              (/"divT3d"  , "[O]3D Temp Advection Tendency"         , "K/s"    , "float", "O"/), \
              (/"divq3d"  , "[O]3D Q Advection Tendency"            , "kg/kg/s", "float", "O"/), \
              (/"div"     , "[O]Large Scale Divergence Tendency"    , "1/s"    , "float", "O"/)  \
           /)
			  
 timevars=(/  (/"tsec"   , "[E]Second", "seconds", "double", "E"/), \
              (/"YEAR"   , "Year"     , "na"     , "float" , "O"/), \
			     (/"MONTH"  , "Month"    , "na"     , "float" , "O"/), \
			     (/"DAY"    , "Day"      , "na"     , "float" , "O"/), \
			     (/"HOUR"   , "Hour"     , "na"     , "float" , "O"/), \
			     (/"MINUTE" , "Minute"   , "na"     , "float" , "O"/)  \
          /)

  dimslevvars = dimsizes( slevvars )
  nslevvars = dimslevvars(0)
  dimmlevvars = dimsizes( mlevvars )
  nmlevvars = dimmlevvars(0)
  print("")
  print("Forcing Data Variable List:")
  do i = 0, nslevvars-1
    print(slevvars(i,0)+" "+slevvars(i,1))
  end do
  do i = 0, nmlevvars-1
    print(mlevvars(i,0)+" "+mlevvars(i,1))
  end do
  print("")

;define dimension information
  dim_names = (/ "time", "lev", "lat", "lon" /)
  dim_sizes = (/     -1,  nlev,  nlat,  nlon /)
  dim_unlim = (/   True, False, False, False /)
  filedimdef(cf_fptr, dim_names, dim_sizes, dim_unlim)


;define variable information
;scalar
  filevardef(cf_fptr, "bdate", "integer", "ncl_scalar" )
  filevardef(cf_fptr, "phis" , "float"  , "ncl_scalar" )
  filevardef(cf_fptr, "lon"  , "float"  , "lon" )
  filevardef(cf_fptr, "lat"  , "float"  , "lat" )
  filevardef(cf_fptr, "lev"  , "float"  , "lev" )
;single level
  do i = 0, nslevvars-1
    filevardef(cf_fptr, slevvars(i, 0), slevvars(i, 3), (/ "time", "lat", "lon" /) )
  end do
;multiple level
  do i = 0, nmlevvars-1
    filevardef(cf_fptr, mlevvars(i, 0), mlevvars(i, 3), (/ "time", "lev", "lat", "lon" /) )
  end do
;time variables
  dimtimevars = dimsizes( timevars )
  ntimevars = dimtimevars(0)
  do i = 0, ntimevars-1
    filevardef(cf_fptr, timevars(i, 0), timevars(i, 3), (/ "time" /) )
  end do

;put variable attributes
  do i = 0, nslevvars-1
    var = slevvars(i, 0)
    var@long_name = slevvars(i, 1)
	 var@units = slevvars(i, 2)
    filevarattdef(cf_fptr, var, var )
  end do
  do i = 0, nmlevvars-1
    var = mlevvars(i, 0)
    var@long_name = mlevvars(i, 1)
	 var@units = mlevvars(i, 2)
    filevarattdef(cf_fptr, var, var )
  end do
  do i = 0, ntimevars-1
    var = timevars(i, 0)
  	 var@units = timevars(i, 2)
    var@long_name = timevars(i, 1)
    filevarattdef(cf_fptr, var, var )
  end do


  var@units = "yyyymmdd"
  var@long_name = "[E]Base Date"
  filevarattdef(cf_fptr, "bdate", var)
  var@units = "m2/s2"
  var@long_name = "[E]Surface Geopotential"
  filevarattdef(cf_fptr, "phis", var)

;some misc time variables
  year   = new( ntime, "float" )
  month  = new( ntime, "float" )
  day    = new( ntime, "float" )
  hour   = new( ntime, "float" )
  minute = new( ntime, "float" )
  cf_fptr->YEAR   = 1.
  cf_fptr->MONTH  = 1.
  cf_fptr->DAY    = 1.
  cf_fptr->HOUR   = 1.
  cf_fptr->MINUTE = 1.


;fill in the data
;global attribution
  cf_fptr@Title = "IOP Analysis"
  cf_fptr@num_time_step = " "



if (opt .eq. "cam4") then
  inputnc= getenv("INPUTNC")
  infptr = addfile(inputnc, "r")
;some essential varibales
  scmdiag_putvar_cam4(cf_fptr, infptr, "bdate", "E" )
  scmdiag_putvar_cam4(cf_fptr, infptr, "tsec" , "E" )
  scmdiag_putvar_cam4(cf_fptr, infptr, "phis" , "E" )
;some dimension variables
  scmdiag_putvar_cam4(cf_fptr, infptr, "lon" , "E" )
  scmdiag_putvar_cam4(cf_fptr, infptr, "lat" , "E" )
  scmdiag_putvar_cam4(cf_fptr, infptr, "lev" , "E" )
;some single level data
  do i=0, nslevvars-1
    scmdiag_putvar_cam4(cf_fptr, infptr, slevvars(i, 0), slevvars(i, 4) )
  end do
;some multiple level data
  do i=0, nmlevvars-1
    scmdiag_putvar_cam4(cf_fptr, infptr, mlevvars(i, 0), mlevvars(i, 4) )
  end do
end if




if (opt .eq. "arm") then
  inputnc= getenv("INPUTNC")
  infptr = addfile(inputnc, "r")
  cf_fptr->time = infptr->time

  if ( isfilevar(infptr, "lat") ) then
    cf_fptr->lat  = (/infptr->lat/)
  else if ( isfilevar(infptr, "y") ) then
    cf_fptr->lat  = (/infptr->y/)
  else
    print("WARNING: lat info missing!!!")
  end if
  end if

  if ( isfilevar(infptr, "lon") ) then
    cf_fptr->lon  = (/infptr->lon/)
  else if ( isfilevar(infptr, "y") ) then
    cf_fptr->lon  = (/infptr->x/)
  else
    print("WARNING: lon info missing!!!")
  end if
  end if

  if ( infptr->lev(0) .lt. infptr->lev(1) ) then
    lev_sign = 1
  else
    lev_sign = -1
  end if
  cf_fptr->lev  = tofloat( (/ scmunits( infptr->lev(::lev_sign) ) /) )
; print(cf_fptr->lev)

  
  cf_fptr->bdate = (/ ut_calendar(infptr->base_time, -2) /)
  cf_fptr->tsec  = (/ infptr->time_offset /)
  cf_fptr->phis  = (/ infptr->phis /)


  if ( isfilevar(infptr, "p_srf_aver") ) then
    cf_fptr->Ps    = (/ scmunits(infptr->p_srf_aver) /)
  else if ( isfilevar(infptr, "Central_Facility_Ps") ) then
    cf_fptr->Ps    = (/ scmunits(infptr->Central_Facility_Ps ) /)
  else
    print("WARNING: Ps info missing!!!")
  end if
  end if


  cf_fptr->Ptend = 0.
  cf_fptr->lhflx = (/ scmunits(infptr->LH) /)
  cf_fptr->shflx = (/ scmunits(infptr->SH) /)

  if ( isfilevar(infptr, "T_srf") ) then
    cf_fptr->Tsair = (/ scmunits(infptr->T_srf) /)
  else if ( isfilevar(infptr, "Ts_Air") ) then
    cf_fptr->Tsair = (/ scmunits(infptr->Ts_Air) /)
  else
    print("WARNING: Tsair info missing!!!")
  end if
  end if

  if ( isfilevar(infptr, "T_skin") ) then
    cf_fptr->Tg    = (/ scmunits(infptr->T_skin) /)
  else if ( isfilevar(infptr, "Tg_Soil") ) then
    cf_fptr->Tg    = (/ scmunits(infptr->Tg_Soil) /)
  else
    print("WARNING: Tg info missing!!!")
  end if
  end if

  if ( isfilevar(infptr, "T") ) then
    cf_fptr->T     = (/ infptr->T(:,::lev_sign) /)
  else if ( isfilevar(infptr, "Temp") ) then
    cf_fptr->T     = (/ infptr->Temp(:,::lev_sign,:,:) /)
  else
    print("WARNING: T info missing!!!")
  end if
  end if

  if ( isfilevar(infptr, "T_adv_h") ) then
    cf_fptr->divT  = (/ scmunits(infptr->T_adv_h(:,::lev_sign)) /)
  else if ( isfilevar(infptr, "Horizontal_Temp_Advec") ) then
    cf_fptr->divT  = (/ scmunits(infptr->Horizontal_Temp_Advec(:,::lev_sign,:,:) ) /)
  else
    print("WARNING: divT info missing!!!")
  end if
  end if

  if ( isfilevar(infptr, "T_adv_v") ) then
    cf_fptr->vertdivT = (/ scmunits(infptr->T_adv_v(:,::lev_sign)) /)
  else if ( isfilevar(infptr, "Vertical_T_Advec") ) then
    cf_fptr->vertdivT  = (/ scmunits(infptr->Vertical_T_Advec(:,::lev_sign,:,:)) /)
  else
    print("WARNING: vertdivT info missing!!!")
  end if
  end if

  if ( isfilevar(infptr, "q") ) then
    cf_fptr->q     = (/ scmunits( infptr->q(:,::lev_sign) ) /)
  else if ( isfilevar(infptr, "H2O_Mixing_Ratio") ) then
    cf_fptr->q     = (/ scmunits( infptr->H2O_Mixing_Ratio(:,::lev_sign,:,:) ) /)
  else
    print("WARNING: q info missing!!!")
  end if
  end if

  if ( isfilevar(infptr, "q_adv_h") ) then
    cf_fptr->divq  = (/ scmunits( infptr->q_adv_h(:,::lev_sign)) /)
  else if ( isfilevar(infptr, "Horizontal_q_Advec") ) then
    cf_fptr->divq  = (/ scmunits( infptr->Horizontal_q_Advec(:,::lev_sign,:,:) ) /)
  else
    print("WARNING: divq info missing!!!")
  end if
  end if

  if ( isfilevar(infptr, "q_adv_v") ) then
    cf_fptr->vertdivq = (/ scmunits(infptr->q_adv_v(:,::lev_sign)) /)
  else if ( isfilevar(infptr, "Vertical_q_Advec") ) then
    cf_fptr->vertdivq = (/ scmunits(infptr->Vertical_q_Advec(:,::lev_sign,:,:) ) /)
  else
    print("WARNING: vertdivq info missing!!!")
  end if
  end if

  if ( dimsizes(getfilevardimsizes(infptr, "omega")) .eq. 2 ) then
    cf_fptr->omega = (/ scmunits( infptr->omega(:,::lev_sign) ) /)
  else if ( dimsizes(getfilevardimsizes(infptr, "omega")) .eq. 4 ) then
    cf_fptr->omega = (/ scmunits( infptr->omega(:,::lev_sign,:,:) ) /)
  else
    print("WARNING: omega info missing!!!")
  end if
  end if

  if ( isfilevar(infptr, "u") ) then
    cf_fptr->u = (/ scmunits( infptr->u(:,::lev_sign) ) /)
  else if ( isfilevar(infptr, "u_wind") ) then
    cf_fptr->u = (/ scmunits( infptr->u_wind(:,::lev_sign,:,:) ) /)
  else
    print("WARNING: u info missing!!!")
  end if
  end if

  if ( isfilevar(infptr, "v") ) then
    cf_fptr->v = (/ scmunits( infptr->v(:,::lev_sign) ) /)
  else if ( isfilevar(infptr, "v_wind") ) then
    cf_fptr->v = (/ scmunits( infptr->v_wind(:,::lev_sign,:,:) ) /)
  else
    print("WARNING: v info missing!!!")
  end if
  end if



end if

;print(cf_fptr)



end

