set init_gnd_net VSS
set init_pwr_net VDD
set init_top_cell darkram
set init_lef_file { /pdk/sky130_scl_9T_0.1.2/sky130_scl_9T_tech/lef/sky130_scl_9T.tlef /pdk/sky130_scl_9T_0.1.2/sky130_scl_9T_tech/lef/sky130_scl_9T_phyCells.lef /pdk/sky130_scl_9T_0.1.2/sky130_scl_9T/lef/sky130_scl_9T.lef /pdk/sky130_scl_9T_0.1.2/sky130_scl_9T_HS/lef/sky130_scl_9T_HS.lef /pdk/sky130_scl_9T_0.1.2/sky130_scl_9T_LP/lef/sky130_scl_9T_LP.lef }
set init_verilog /pnr_training/WORK_BATCH1/nusrat_27/synth_sky/synthrtl/outputs/opt_netlist.v
set init_mmmc_file scripts/viewDefinition.tcl
init_design
source scripts/fp.tcl
saveDesign DESIGN/init.inn
#exit
