
load "$TWPICE_CODE/utils/load.ncl"

begin

  TEST  = getenv("TEST")
  case  = "sta"
  about = "TWP-ICE-NWP"

  var1 = "ZMDT"
  var2 = "CMFDT"
  var3 = "DTCOND"
  var4 = "QRS"
  var5 = "QRL"
  var6 = "DTV"

  vart = "Q1-G"
  varo = "Q1"

  p1_fptr = addfile("./"+testdir+"/"+case+"_"+var1+".nc", "r")
  p2_fptr = addfile("./"+testdir+"/"+case+"_"+var2+".nc", "r")
  p3_fptr = addfile("./"+testdir+"/"+case+"_"+var3+".nc", "r")
  p4_fptr = addfile("./"+testdir+"/"+case+"_"+var4+".nc", "r")
  p5_fptr = addfile("./"+testdir+"/"+case+"_"+var5+".nc", "r")
  p6_fptr = addfile("./"+testdir+"/"+case+"_"+var6+".nc", "r")

  obsq_fptr = addfile("./"+obsdir +"/"+case+"_"+varo+".nc", "r")

  time_tmp  = p1_fptr->time

;==========================================
; initialize graphic workstation
;==========================================

  res  = True
;==========================================
; general settings.
;==========================================
; res@gsnDraw = False
; res@gsnFrame = False

res@pmLegendDisplayMode    = "Always"            ; turn on legend
res@pmLegendSide           = "Top"               ; Change location of 
res@pmLegendParallelPosF   =  0.85               ; move units right
res@pmLegendOrthogonalPosF = -0.32               ; move units down
res@pmLegendWidthF         = 0.1                 ; Change width and
res@pmLegendHeightF        = 0.2                 ; height of legend.
res@lgLabelFontHeightF     = 0.015

res@xyExplicitLegendLabels = (/"Q1(obs)", vart, var1, var2, var3 /)

res@trYReverse        = True
res@tiMainFontHeightF = 0.03
res@tmXBLabelFontHeightF = 0.01

res@gsnXRefLine       = 0.0


setviewratio(res, 0.7, False)

;==========================================
; setting for special var
;==========================================

res@xyLineThicknesses  = (/7, 7, 4, 4, 4, 4/)
; res@xyDashPatterns     = (/0, 1, 2, 3/)
res@xyLineColors       = (/"red", "black", "black"/)

; res@gsnStringFontHeightF = 15
res@gsnLeftString   = TEST
res@gsnRightString  = "K/hour"

begind = (/ 1,  9, 17 /)
endind = (/ 8, 16, 27 /)
range  = (/1.0, 0.5, 0.5/)

nind = dimsizes(begind)

do i = 0, nind-1

timeind  = ind( (time_tmp .ge. begind(i)) .and. (time_tmp .lt. endind(i)) )
ntime    = dimsizes(timeind)
yyyymmdd = ut_calendar( time_tmp(timeind), -2)
begtime  = yyyymmdd(0)
endtime  = yyyymmdd(ntime-1)

d1_tm = 3600*dim_avg_Wrap( p1_fptr->$var1$( {lev|1005:0}, time|timeind) )
d2_tm = 3600*dim_avg_Wrap( p2_fptr->$var2$( {lev|1005:0}, time|timeind) )
d3_tm = 3600*dim_avg_Wrap( p3_fptr->$var3$( {lev|1005:0}, time|timeind) )
d4_tm = 3600*dim_avg_Wrap( p4_fptr->$var4$( {lev|1005:0}, time|timeind) )
d5_tm = 3600*dim_avg_Wrap( p5_fptr->$var5$( {lev|1005:0}, time|timeind) )
d6_tm = 3600*dim_avg_Wrap( p6_fptr->$var6$( {lev|1005:0}, time|timeind) )
dt_tm = d3_tm + d4_tm + d5_tm + d6_tm
do_tm = dim_avg_Wrap( obsq_fptr->$varo$( {lev|1005:0}, time|timeind) )

lev = do_tm&lev

wks = gsn_open_wks("ps", plotdir+"/"+test+"_"+varo+"_"+begtime+"-"+endtime+"_STAPF")

res@gsnCenterString = begtime+"-"+endtime
res@trXMinF = -range(i)
res@trXMaxF =  range(i)

;plot_test = gsn_csm_xy(wks, (/ do_tm, dt_tm, d1_tm, d2_tm, d3_tm, d4_tm, d5_tm, d6_tm /) , lev, res)
plot_test = gsn_csm_xy(wks, (/ do_tm, dt_tm, d1_tm, d2_tm, d3_tm /) , lev, res)

delete(plot_test)
delete(wks)
delete(timeind)
delete(yyyymmdd)

end do

; panelres = True
; panelres@gsnPanelRowSpec = True
; gsn_panel(wks, (/plot_test, plot_obs/), (/1,1/), panelres)

end

