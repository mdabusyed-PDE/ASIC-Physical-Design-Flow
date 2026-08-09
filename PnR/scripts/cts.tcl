#restoreDesign DESIGN/place.inn.dat darksocv
#setDesignMode -topRoutingLayer 5
#setOptMode -opt_setup_target_slack 0.1
#setOptMode -opt_hold_target_slack 0.05
#ccopt_design -cts
#set_interactive_constraint_modes [all_constraint_modes ]
#set_propagated_clock [all_clocks ]
#set_global report_timing_format {instance arc cell net load delay arrival required }
#set timing_enable_simultaneous_setup_hold_mode true
#mkdir -p report/postCTS
#checkDesign -all > report/postCTS/checkDesign.rpt

#report_timing -from [all_inputs ] -to [all_registers ] -max_slack 0 -max_paths 999999 > report/postCTS/setup_in2reg.rpt
#report_timing -from [all_registers ] -to [all_registers ] -max_slack 0 -max_paths 999999 > report/postCTS/setup_reg2reg.rpt
#report_timing -from [all_registers ] -to [all_outputs ] -max_slack 0 -max_paths 999999 > report/postCTS/setup_reg2out.rpt

#report_timing -check_type hold -from [all_inputs ] -to [all_registers ] -max_slack 0 -max_paths 999999 > report/postCTS/hold_in2reg.rpt
#report_timing -check_type hold -from [all_registers ] -to [all_registers ] -max_slack 0 -max_paths 999999 > report/postCTS/hold_reg2reg.rpt
#report_timing -check_type hold -from [all_registers ] -to [all_outputs ] -max_slack 0 -max_paths 999999 > report/postCTS/hold_reg2out.rpt
#set timing_enable_simultaneous_setup_hold_mode false
#optDesign -hold -postCTS -prefix postCTS
#checkDesign -all > report/postCTS/optcheckDesign.rpt

#report_timing -from [all_inputs ] -to [all_registers ] -max_slack 0 -max_paths 999999 > report/postCTS/setup_in2regopt.rpt
#report_timing -from [all_registers ] -to [all_registers ] -max_slack 0 -max_paths 999999 > report/postCTS/setup_reg2regopt.rpt
#report_timing -from [all_registers ] -to [all_outputs ] -max_slack 0 -max_paths 999999 > report/postCTS/setup_reg2outopt.rpt

#set timing_enable_simultaneous_setup_hold_mode true
#report_timing -check_type hold -from [all_inputs ] -to [all_registers ] -max_slack 0 -max_paths 999999 > report/postCTS/hold_in2regopt.rpt
#report_timing -check_type hold -from [all_registers ] -to [all_registers ] -max_slack 0 -max_paths 999999 > report/postCTS/hold_reg2regopt.rpt
#report_timing -check_type hold -from [all_registers ] -to [all_outputs ] -max_slack 0 -max_paths 999999 > report/postCTS/hold_reg2outopt.rpt

#saveDesign DESIGN/cts.inn
#exit


restoreDesign DESIGN/place.inn.dat darkram
setDesignMode -topRoutingLayer 5
ccopt_design -cts
saveDesign DESIGN/cts2.inn
set_interactive_constraint_modes [all_constraint_modes ]
set_propagated_clock [all_clocks ]
set_global report_timing_format {instance arc cell net load delay arrival required }
set timing_enable_simultaneous_setup_hold_mode true
checkDesign -all > report/postCTS/checkDesign.rpt

report_timing -from [all_inputs ] -to [all_registers ] -max_paths 999999 > report/postCTS/setup_in2reg.rpt
report_timing -from [all_registers ] -to [all_registers ] -max_paths 999999 > report/postCTS/setup_reg2reg.rpt
report_timing -from [all_registers ] -to [all_outputs ] -max_paths 999999 > report/postCTS/setup_reg2out.rpt

report_timing -check_type hold -from [all_inputs ] -to [all_registers ] -max_paths 999999 > report/postCTS/hold_in2reg.rpt
report_timing -check_type hold -from [all_registers ] -to [all_registers ] -max_paths 999999 > report/postCTS/hold_reg2reg.rpt
report_timing -check_type hold -from [all_registers ] -to [all_outputs ] -max_paths 999999 > report/postCTS/hold_reg2out.rpt
set timing_enable_simultaneous_setup_hold_mode false
setOptMode -opt_setup_target_slack 0.1
setOptMode -opt_hold_target_slack 0.05

optDesign -postCTS -prefix postCTS
saveDesign DESIGN/cts1.inn
checkDesign -all > report/postCTS/optcheckDesign.rpt

report_timing -from [all_inputs ] -to [all_registers ] -max_paths 999999 > report/postCTS/setup_in2regopt.rpt
report_timing -from [all_registers ] -to [all_registers ] -max_paths 999999 > report/postCTS/setup_reg2regopt.rpt
report_timing -from [all_registers ] -to [all_outputs ] -max_paths 999999 > report/postCTS/setup_reg2outopt.rpt

set timing_enable_simultaneous_setup_hold_mode true
report_timing -check_type hold -from [all_inputs ] -to [all_registers ] -max_paths 999999 > report/postCTS/hold_in2regopt.rpt
report_timing -check_type hold -from [all_registers ] -to [all_registers ] -max_paths 999999 > report/postCTS/hold_reg2regopt.rpt
report_timing -check_type hold -from [all_registers ] -to [all_outputs ] -max_paths 999999 > report/postCTS/hold_reg2outopt.rpt
saveDesign DESIGN/cts.inn
exit

