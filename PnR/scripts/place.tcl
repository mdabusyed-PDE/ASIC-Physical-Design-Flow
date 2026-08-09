restoreDesign DESIGN/init.inn.dat darkram
setDesignMode -topRoutingLayer 5
setPlaceMode -place_global_cong_effort high 
setPlaceMode -place_global_uniform_density true
#setPlaceMode -place_global_enable_distributed_place true
place_design
saveDesign DESIGN/place1.inn
mkdir -p report
mkdir -p report/place
checkDesign -all > report/place/checkdesign.rpt
checkPlace

report_timing -from [all_inputs ] -to [all_registers ] -max_slack 0 -max_paths 9999 > report/place/setup_in2reg.rpt
report_timing -from [all_registers ] -to [all_registers ] -max_slack 0 -max_paths 9999 > report/place/setup_reg2reg.rpt
report_timing -from [all_registers ] -to [all_outputs ] -max_slack 0 -max_paths 9999 > report/place/setup_reg2out.rpt

saveDesign DESIGN/place.inn
optDesign -preCTS
mkdir -p report/prects
checkDesign -all > report/prects/checkdesignopt.rpt
report_timing -from [all_registers ] -to [all_outputs ] -max_slack 0 -max_paths 9999 > report/prects/setup_reg2outopt.rpt
report_timing -from [all_registers ] -to [all_registers ] -max_slack 0 -max_paths 9999 > report/prects/setup_reg2regopt.rpt
report_timing -from [all_inputs ] -to [all_registers ] -max_slack 0 -max_paths 9999 > report/prects/setup_in2regopt.rpt

saveDesign DESIGN/place.inn

exit
