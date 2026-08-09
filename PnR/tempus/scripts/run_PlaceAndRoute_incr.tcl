source ../design/ECO_INIT_11_optSetup.enc

setExtractRCMode -coupled true -engine postRoute -effortLevel low
setMultiCpuUsage -localCpu 8 
extractRC

source DRV_eco_innovus.tcl
source SETUP_eco_innovus.tcl
source HOLD_eco_innovus.tcl

source eco_innovus.tcl
_
ecoRoute
extractRC

saveDesign ECO_INIT_11_optSetup_postECO.enc
defOut -floorplan -placement -netlist -routing -ioRow  ECO_INIT_11_optSetup_postECO.def


set fpw2 [open spef_after.tcl w]
if {[file exists SPEF_AFTER]==0} {catch [exec mkdir SPEF_AFTER]}
foreach rc [all_setup_hold_rc_corners] {
    rcOut -rc_corner $rc -spef SPEF_AFTER/$rc.spef.gz
    puts $fpw2 "read_spef -rc_corner $rc SPEF_AFTER/$rc.spef.gz"}
close $fpw2

exit

