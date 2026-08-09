#-----------------------------------------------------
# Native power up analysis
# create for Voltus 14.1 on April 30th 2014
# update for Voltus 15.1 on July 30th 2015
# By Rose Li
#----------------------------------------------------------------------

#-----------------------------------------------------------------------
# set multi CPU
# -----------------------------------------------------------------------
set_multi_cpu_usage \
	-localCpu 			8

# -----------------------------------------------------------------------
# load design
# -----------------------------------------------------------------------
set lefs [list]
lappend lefs ../data/lef/gsclib090_tech.lef
lappend lefs ../data/lef/gsclib090_macro.lef
lappend lefs ../data/lef/pll.lef
lappend lefs ../data/lef/decap.lef
lappend lefs ../data/lef/pso_header.lef
lappend lefs ../data/lef/pso_ring.lef
lappend lefs ../data/lef/buf_ao.lef
read_lib -lef $lefs

read_view_definition ../design/viewDefinition.tcl

read_verilog ../design/postRouteOpt.enc.dat/super_filter.v.gz
set_top_module super_filter -ignore_undefined_cell

read_def ../design/super_filter.def.gz

#-----------------------------------------------------------------------
# Read cpf file for power domain information
#-----------------------------------------------------------------------
read_power_domain \
	-cpf 				../design/super_filter.cpf

#-----------------------------------------------------------------------
# Read spef file
#-----------------------------------------------------------------------
read_spef \
	-decoupled \
	-rc_corner 			RC_wc_125 \
					../design/postRouteOpt_RC_wc_125.spef.gz

# -----------------------------------------------------------------------
# run native power up power analysis
# -----------------------------------------------------------------------
set_power_analysis_mode \
	-reset

set_power_analysis_mode \
	-method 			dynamic_vectorless \
	-disable_static 		true \
	-analysis_view 			AV_wc_on \
	-create_binary_db 		false \
	-write_static_currents 		false \
	-honor_negative_energy 		true \
	-ignore_control_signals 	true \
        -enable_xp true \
        -extraction_tech_file ../data/qrc/qrcTechFile \
	-power_grid_library { \
					../data/pgv_dir/tech_pgv/techonly.cl \
	        			../data/pgv_dir/stdcell_pgv/stdcells.cl \
	        			../data/pgv_dir/macro_pgv/macros_pll.cl \
					}	
set_power_output_dir \
	-reset

set_power_output_dir \
	./dynamic_pwr

set_default_switching_activity \
	-reset

set_default_switching_activity \
	-input_activity 		0.2 \
	-period 			10.0

set_powerup_analysis \
	-reset

set_power_analysis_mode -unified_power_switch_flow true

set_dynamic_power_simulation -reset
set_dynamic_power_simulation -resolution 50ps

## power is run in parallel of rail
##report_power

# -----------------------------------------------------------------------
# run power up rail analysis for net VDD_ring
# -----------------------------------------------------------------------

set_rail_analysis_mode \
	-method 			dynamic \
	-accuracy 			hd \
	-power_grid_library {\
					../data/pgv_dir/tech_pgv/techonly.cl \
	        			../data/pgv_dir/stdcell_pgv/stdcells.cl \
		        		../data/pgv_dir/macro_pgv/macros_pll.cl } \
	-analysis_view 			AV_wc_on \
	-powering_up_rails 		{ VDD_ring } \
	-powerup_fast_mode 		true \
	-vsrc_search_distance 		50 \
	-generate_movies 		false \
	-save_voltage_waveforms 	true \
	-verbosity 			true \
	-enable_xp true \
        -report_power_in_parallel true \
	-extraction_tech_file ../data/qrc/qrcTechFile


set_power_data \
	-reset

## power is run in parallel of rail
##set_power_data \
	-format 			current \
	-scale 				1 \
					{dynamic_pwr/dynamic_VDD_AO.ptiavg \
					dynamic_pwr/dynamic_VDD_ring.ptiavg \
					dynamic_pwr/dynamic_VDD_column.ptiavg \
					dynamic_pwr/dynamic_VDD_external.ptiavg \
					dynamic_pwr/dynamic_VSS.ptiavg}

set_power_pads \
	-reset

set_power_pads \
	-net 				VSS \
	-format 			xy \
	-file 				../design/super_filter_VSS.pp

set_power_pads \
	-net 				VDD_external \
	-format 			xy \
	-file 				../design/super_filter_VDD_external.pp

set_power_pads \
	-net 				VDD_AO \
	-format 			xy \
	-file 				../design/super_filter_VDD_AO.pp

set_advanced_rail_options -vstorm2_include_file_begin ../tcl/rail.inc


analyze_rail \
	-type 				domain \
	-results_directory 		dynamic_rail_pu_nets \
					ALL
generate_power_up_report -net VDD_ring -state_directory dynamic_rail_pu_nets/ALL_25C_dynamic_1 -output_directory PowerUpReports




# -----------------------------------------------------------------------
# end 
# -----------------------------------------------------------------------
