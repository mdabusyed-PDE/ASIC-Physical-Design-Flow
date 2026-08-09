set module "picosoc"

mkdir -p report output
source scripts/newhdl
source scripts/set_lib
source scripts/read_lef

set_db / .library $libs
set_db hdl_max_memory_address_range 20000000
read_hdl sv $hdl
set_db / .lef_library $lefs

set_db boundary_optimize_constant_hpins false
set_db / .auto_ungroup none

elaborate

set_top_module picosoc

write_do_lec -revised_design design_elaborated -logfile logs/lec_elab.log >output/elaborate.lec.do
write_hdl > output/elaborate.v

source scripts/sdc
read_sdc scripts/sdc
report_clocks

set_db syn_global_effort high
set_db syn_generic_effort express
set_db syn_map_effort high 
set_db tns_opto true

syn_generic
write_hdl > output/generic.v

syn_map
write_hdl > output/map.v
write_do_lec -revised_design fv_map -logfile logs/rtl2interme
syn_opt
write_hdl > output/syn_opt.v
write_hdl -mapped > output/picosoc_netlist.v
#write_scandef >output/picosoc.scandef

report_qor > reports/qor.rpt
report_timing > reports/timing.rpt
report_area > reports/area.rpt
report_power > reports/power.rpt

write_sdc > output/picosoc.sdc
write_sdf > output/picosoc.sdf
echo "Synthesis Completed Successfully!"
#write_db -all_root_attributes -to_file my.db -scriptsynth_sky
#write_do_lec -golden_design fv_map -revised_design output/pic
#write_do_lec -revised_design output/gate_netlist.v -logfile l
