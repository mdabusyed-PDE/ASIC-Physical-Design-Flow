restoreDesign DESIGN/cts.inn.dat darkram
setDesignMode -topRoutingLayer 5

set_interactive_constraint_modes [all_constraint_modes ]
set_propagated_clock [all_clocks ]
set_global report_timing_format {instance arc cell net load delay arrival required }
set timing_enable_simultaneous_setup_hold_mode false

#antenna fix and ant cell name
setNanoRouteMode -route_antenna_cell_name ANTENNA
setNanoRouteMode -route_antenna_diode_insertion true
setNanoRouteMode -route_diode_insertion_for_clock_nets true
set timing_enable_simultaneous_setup_hold_mode false
setAnalysisMode -analysisType onChipVariation

# setup and hold margin (setOptMode target_slack
#setOptMode -opt_setup_target_slack 0.1
#setOptMode -opt_hold_target_slack 0.05

routeDesign
saveDesign DESIGN/route1.inn
#globalNetConnect VDD -instanceBasename * -pin VDD -verbose
#globalNetConnect VSS -instanceBasename * -pin VSS -verbose
#saveNetlist test.v -includePhysicalInst -includePowerGround

#verify_drc -limit 99999 > output/drc.rpt
set step route
checkDesign -all > report/route/checkdesign.rpt
report_timing -path_type full_clock -from [all_inputs ] -to [all_registers ] -max_slack 0 -max_paths 9999 > report/route/setup_in2reg.rpt
report_timing -path_type full_clock -from [all_registers ] -to [all_registers ] -max_slack 0 -max_paths 9999 > report/route/setup_reg2reg.rpt
report_timing -path_type full_clock -from [all_registers ] -to [all_outputs ] -max_slack 0 -max_paths 9999 > report/route/setup_reg2out.rpt
set timing_enable_simultaneous_setup_hold_mode true
report_timing -path_type full_clock -check_type hold -from [all_inputs ] -to [all_registers ] -max_slack 0 -max_paths 99999 > report/route/hold_in2reg.rpt
report_timing -path_type full_clock -check_type hold -from [all_registers ] -to [all_registers ] -max_slack 0 -max_paths 99999 > report/route/hold_reg2reg.rpt
report_timing -path_type full_clock -check_type hold -from [all_registers ] -to [all_outputs ] -max_slack 0 -max_paths 99999 > report/route/hold_reg2out.rpt
set timing_enable_simultaneous_setup_hold_mode false
setAnalysisMode -analysisType onChipVariation

# setup and hold margin (setOptMode target_slack
#setOptMode -opt_setup_target_slack 0.1
#setOptMode -opt_hold_target_slack 0.05

#optDesign -postRoute
#checkDesign -all > report/route/optcheckdesign.rpt
#report_timing -path_type full_clock -from [all_inputs ] -to [all_registers ] -max_slack 0 -max_paths 9999 > report/route/setup_in2regopt.rpt
#report_timing -path_type full_clock -from [all_registers ] -to [all_registers ] -max_slack 0 -max_paths 9999 > report/route/setup_reg2regopt.rpt
#report_timing -path_type full_clock -from [all_registers ] -to [all_outputs ] -max_slack 0 -max_paths 9999 > report/route/setup_reg2outopt.rpt
#set timing_enable_simultaneous_setup_hold_mode true
#report_timing -path_type full_clock -check_type hold -from [all_inputs ] -to [all_registers ] -max_slack 0 -max_paths 99999 > report/route/hold_in2regopt.rpt
#report_timing -path_type full_clock -check_type hold -from [all_registers ] -to [all_registers ] -max_slack 0 -max_paths 99999 > report/route/hold_reg2regopt.rpt
#report_timing -path_type full_clock -check_type hold -from [all_registers ] -to [all_outputs ] -max_slack 0 -max_paths 99999 > report/route/hold_reg2outopt.rpt
#verify_drc -limit 99999 > output/drc.rpt

saveDesign DESIGN/route3.inn

set timing_enable_simultaneous_setup_hold_mode false

setOptMode -opt_setup_target_slack 0.1
setOptMode -opt_hold_target_slack 0.05

optDesign -postroute
saveDesign DESIGN/route4.inn
checkDesign -all > report/route/optholdcheckdesign.rpt
report_timing -path_type full_clock -from [all_inputs ] -to [all_registers ] -max_slack 0 -max_paths 9999 > report/route/setup_in2regopt2.rpt
report_timing -path_type full_clock -from [all_registers ] -to [all_registers ] -max_slack 0 -max_paths 9999 > report/route/setup_reg2regopt2.rpt
report_timing -path_type full_clock -from [all_registers ] -to [all_outputs ] -max_slack 0 -max_paths 9999 > report/route/setup_reg2outopt2.rpt
set timing_enable_simultaneous_setup_hold_mode true
report_timing -path_type full_clock -check_type hold -from [all_inputs ] -to [all_registers ] -max_slack 0 -max_paths 99999 > report/route/hold_in2regopt2.rpt
report_timing -path_type full_clock -check_type hold -from [all_registers ] -to [all_registers ] -max_slack 0 -max_paths 99999 > report/route/hold_reg2regopt2.rpt
report_timing -path_type full_clock -check_type hold -from [all_registers ] -to [all_outputs ] -max_slack 0 -max_paths 99999 > report/route/hold_reg2outopt2.rpt

set timing_enable_simultaneous_setup_hold_mode false
globalNetConnect VDD -instanceBasename * -pin VDD -verbose
globalNetConnect VSS -instanceBasename * -pin VSS -verbose
saveNetlist test.v -includePhysicalInst -includePowerGround
verify_drc -limit 999999 > output/drc.rpt
verifyConnectivity > output/connect.rpt

#source scripts/FILLerCell.tcl
addFiller -cell FILL1 FILL16 FILL2 FILL32 FILL4 FILL64 FILL8 FILL_DECAP16 FILL_DECAP8

# Export Design Data
saveNetlist output/darkram_pnr.v -includePhysicalinst -includePOwerGround -excludeCellInst "FILL1 FILL16 FILL2 FILL32 FILL4 FILL64 FILL8"
streamOut -merge "/pdk/sky130_scl_9T_0.1.2/sky130_scl_9T/gds/sky130_scl_9T.gds /pdk/sky130_scl_9T_0.1.2/sky130_scl_9T_tech/gds/sky130_scl_9T_phyCells.gds /pdk/sky130_scl_9T_0.1.2/sky130_scl_9T_HS/gds/sky130_scl_9T_HS.gds /pdk/sky130_scl_9T_0.1.2/sky130_scl_9T_LP/gds/sky130_scl_9T_LP.gds " -mapFile  /pdk/sky130_scl_9T_0.1.2/sky130_scl_9T/gds/sky130_stream.mapFile output/darkram.gds

defOut -netlist -floorplan output/darkram.def
write_lef_abstract -stripePin -PGPinLayers { 4 5 } output/darkram.lef
set_analysis_view -setup {func_slow_125_1v62 func_fast_0_1v98 func_typical_25_1v8} -hold {func_slow_125_1v62 func_fast_0_1v98 func_typical_25_1v8}
do_extract_model -view func_slow_125_1v62 output/darkram_slow.lib
do_extract_model -view func_fast_0_1v98 output/darkram_fast.lib
do_extract_model -view func_typical_25_1v8 output/darkram_typical.lib
checkDesign -all > report/route/streamoutcheckdesign.rpt

saveDesign DESIGN/route5.inn
#exit
