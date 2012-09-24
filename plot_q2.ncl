
load "$TWPICE_CODE/utils/load.ncl"

begin

TEST  = getenv("TEST")
case  = "sta"
about = "TWP-ICE-NWP"

var1 = "ZMDQ"
var2 = "CMFDQ"
var3 = "DCQ"
var4 = "VD01"

vart = "Q2-G"
varo = "Q2"

p1_fptr = addfile("./"+testdir+"/"+case+"_"+var1+".nc", "r")
p2_fptr = addfile("./"+testdir+"/"+case+"_"+var2+".nc", "r")
p3_fptr = addfile("./"+testdir+"/"+case+"_"+var3+".nc", "r")
p4_fptr = addfile("./"+testdir+"/"+case+"_"+var4+".nc", "r")

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

res@xyExplicitLegendLabels = (/varo+"(obs)", vart, var1, var2, var3, var4 /)

res@trYReverse        = True
res@tiMainFontHeightF = 0.03
res@tmXBLabelFontHeightF = 0.01

res@gsnXRefLine       = 0.0

setviewratio(res, 0.7, False)

;==========================================
; setting for special var
;==========================================

res@xyLineThicknesses  = (/4, 4, 1.5, 1.5, 1.5, 1.5/)
; res@xyDashPatterns     = (/0, 1, 2, 3/)
res@xyLineColors       = (/"red", "black", "black"/)

; res@gsnStringFontHeightF = 15
res@gsnLeftString   = TEST
res@gsnRightString  = "g/Kg/hour"

begind = (/ 1,  8, 16 /)
endind = (/ 8, 16, 27 /)
range  = (/1.5, 0.5, 0.5/)

nind = dimsizes(begind)

do i = 0, nind-1

timeind  = ind( (time_tmp .ge. begind(i)) .and. (time_tmp .lt. endind(i)) )
ntime    = dimsizes(timeind)
yyyymmdd = ut_calendar( time_tmp(timeind), -2)
begtime  = yyyymmdd(0)
endtime  = yyyymmdd(ntime-1)

d1_tm = 3600*1000*dim_avg_Wrap( p1_fptr->$var1$( {lev|1005:0}, time|timeind) )
d2_tm = 3600*1000*dim_avg_Wrap( p2_fptr->$var2$( {lev|1005:0}, time|timeind) )
d3_tm = 3600*1000*dim_avg_Wrap( p3_fptr->$var3$( {lev|1005:0}, time|timeind) )
d4_tm = 3600*1000*dim_avg_Wrap( p4_fptr->$var4$( {lev|1005:0}, time|timeind) )
dt_tm = d3_tm + d4_tm
do_tm = dim_avg_Wrap( obsq_fptr->$varo$( {lev|1005:0}, time|timeind) )

lev = do_tm&lev

wks = gsn_open_wks("ps", plotdir+"/"+test+"_"+varo+"_"+begtime+"-"+endtime+"_STAPF")

res@gsnCenterString = begtime+"-"+endtime
res@trXMinF = -range(i)
res@trXMaxF =  range(i)

plot_test = gsn_csm_xy(wks, (/ do_tm, dt_tm, d1_tm, d2_tm, d3_tm, d4_tm /) , lev, res)

delete(plot_test)
delete(wks)
delete(timeind)
delete(yyyymmdd)

end do

; panelres = True
; panelres@gsnPanelRowSpec = True
; gsn_panel(wks, (/plot_test, plot_obs/), (/1,1/), panelres)

end

