
if {[info exists ::env(FIRST_RUN)] && $::env(FIRST_RUN) == 1} {
source innovus_postECO.inn} \
else {
source ../DESIGN/route.inn}

setExtractRCMode -coupled true -engine postRoute -effortLevel high
setMultiCpuUsage -localCpu 8 
extractRC

catch {source DRV_eco_innovus.tcl}
catch {source SETUP_eco_innovus.tcl}
catch {source HOLD_eco_innovus.tcl}

ecoRoute
extractRC

saveDesign innovus_postECO.inn
defOut -floorplan -placement -netlist -routing -ioRow  postroute_postECO.def
saveNetlist innovus_postECO.v

set fpw2 [open spef_after.tcl w]
if {[file exists SPEF_AFTER]==0} {catch [exec mkdir SPEF_AFTER]}
foreach rc [all_setup_hold_rc_corners] {
    rcOut -rc_corner $rc -spef SPEF_AFTER/$rc.spef.gz
    puts $fpw2 "read_spef -rc_corner $rc SPEF_AFTER/$rc.spef.gz"}
close $fpw2

exit

