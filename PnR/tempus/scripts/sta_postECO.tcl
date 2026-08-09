source spef_after.tcl
set_delay_cal_mode -SIAware true

#set_interactive_constraint_modes [ all_constraint_modes]
#set_propagated_clock [all_clocks]
#set_global report_timing_format {instance arc cell net load delay arrival required}

report_constraint -all_violators  > rep.vio.gz
report_analysis_coverage > rep.coverage

update_timing -full
report_annotated_parasitics -list_annotated > reports/list_annotated.rpt
report_annotated_parasitics -list_float_net > reports/annotated_floating_list.rpt
report_annotated_parasitics -list_not_annotated > reports/list_not_annotated.rpt
report_annotated_parasitics -list_broken_net > reports/annotated_broken_list.rpt


#report for setup
report_timing -from [all_inputs] -to [all_registers] -max_slack 9999 -max_paths 10000 > setup.in2reg.rpt
report_timing -from [all_registers] -to [all_registers] -max_slack 9999 -max_paths 10000 > setup.reg2reg.rpt
report_timing -from [all_registers] -to [all_outputs] -max_slack 9999 -max_paths 10000 > setup.reg2out.rpt

####report for hold
report_timing -check_type hold -from [all_inputs] -to [all_registers] -max_slack 9999 -max_paths 10000 > hold.in2reg.rpt
report_timing -check_type hold -from [all_registers] -to [all_registers] -max_slack 9999 -max_paths 10000 > hold.reg2reg.rpt
report_timing -check_type hold -from [all_registers] -to [all_outputs] -max_slack 9999 -max_paths 10000 > hold.reg2out.rpt


report_timing -output_format binary -late -max_paths 9999 -max_slack 999 > design_after_late.mtarpt.gz
report_timing -output_format binary -early -max_paths 9999 -max_slack 999 > design_after_early.mtarpt.gz

