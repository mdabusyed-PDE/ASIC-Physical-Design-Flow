# ------------------------------------------------------
# set multi CPU
# ------------------------------------------------------
# large designs use XP flow, enable multi hosts, multi cpus
# set_multi_cpu_usage -localCpu 8 -remoteHost 1 -cpuPerRemoteHost 8
# set_distribute_host -custom -custom_script {bsub -q interactive -n 8 -R "(OSNAME == Linux ) && (OSREL==EE80) rusage[mem=50000]" -W 9000 }
#
# for this RAK, we keep 1 host and multiple cpus
set_multi_cpu_usage \
        -localCpu                       8
set_distribute_host -local

#-----------------------------------------------------------------------
# scripts to load design
#-----------------------------------------------------------------------
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
# load cpf file
#-----------------------------------------------------------------------
read_power_domain -cpf ../design/super_filter.cpf

#-----------------------------------------------------------------------
# load  spef file
#-----------------------------------------------------------------------
read_spef \
    -decoupled \
    -rc_corner                  RC_wc_125 \
                                ../design/postRouteOpt_RC_wc_125.spef.gz

#-----------------------------------------------------------------------
# Alternatively, you can read the design piece-meal.
# source ../tcl/load_design_voltus.tcl
#-----------------------------------------------------------------------

#-----------------------------------------------------------------------
# Prepare for vectorless dynamic power analysis
#-----------------------------------------------------------------------
set_power_output_dir            dynVecLessPowerResults

set_power_analysis_mode \
    -reset

set_power_analysis_mode \
    -analysis_view              AV_wc_on \
    -disable_static             false \
    -write_static_currents      true \
    -binary_db_name             power.db \
    -create_binary_db           true \
    -method                     dynamic_vectorless \
    -enable_xp true \
    -extraction_tech_file ../data/qrc/qrcTechFile \
    -power_grid_library 	{ \
	../data/pgv_dir/tech_pgv/techonly.cl \
	../data/pgv_dir/stdcell_pgv/stdcells.cl \
	../data/pgv_dir/macro_pgv/macros_pll.cl \
	} 

set_power \
    -reset

set_power \
    -pg_net                     VDD_AO \
    -pwl \
    -instance                   ref_clk__L1_I0 { \
        0ns      0mA \
        0.075ns  0mA \
        0.175ns 45mA \
        0.225ns 15mA \
        0.425ns  0mA \
    } \
    -sticky

set_dynamic_power_simulation \
    -reset

set_dynamic_power_simulation \
    -resolution                 50ps

report_power \
    -outfile                    dyn.rpt

#-----------------------------------------------------------------------
# At this point, review the current waveforms:
# for the instance ref_clk__L1_I0 and for the entire design (show current spikes align with clocks)
#-----------------------------------------------------------------------
view_dynamic_waveform \
   -type                        current \
   -instance_name               ref_clk__L1_I0 \
   -waveform_files              {dynVecLessPowerResults/dynamic_VDD_AO.ptiavg}

#-----------------------------------------------------------------------
# View the total current waveform
#-----------------------------------------------------------------------
view_dynamic_waveform \
   -type current \
   -composite_waveform_type total_current \
   -waveform_files { dynVecLessPowerResults/dynamic_VDD_AO.ptiavg }

#suspend
#-----------------------------------------------------------------------
## section2: scripts to run dynamic vectorbased power analysis
## load design
## source ../tcl/load_design_voltus.tcl
#-----------------------------------------------------------------------
#resume
#-----------------------------------------------------------------------
# Prepare for event based dynamic power analysis
#-----------------------------------------------------------------------
set_power_output_dir            dynPowerResults

set_power_analysis_mode -reset 

set_power_analysis_mode \
    -analysis_view          AV_wc_on \
    -method                 event_based \
    -disable_static         false \
    -write_static_currents  true \
    -write_dynamic_currents  true \
    -write_profiling_db true \
    -binary_db_name         power.db \
    -create_binary_db       true \
    -enable_xp true \
    -extraction_tech_file ../data/qrc/qrcTechFile \
    -power_grid_library 	{ \
	../data/pgv_dir/tech_pgv/techonly.cl \
	../data/pgv_dir/stdcell_pgv/stdcells.cl \
	../data/pgv_dir/macro_pgv/macros_pll.cl \
	}

set_dynamic_power_simulation \
    -reset
set_dynamic_power_simulation \
    -resolution                50ps

#-----------------------------------------------------------------------
# First, read the entire activity file.
#-----------------------------------------------------------------------
set_power_analysis_mode \
    -report_missing_nets        true

read_activity_file \
    -reset
read_activity_file \
    -format                     VCD \
    -scope                      FIR_TB.Unit \
    -start                      {} \
    -end                        {} \
    -block                      {} \
                                ../design/ncsim.vcd

report_power
#-----------------------------------------------------------------------
# it will analyze the VCD to find optimal simulation points (vector profiling)
#-----------------------------------------------------------------------

view_dynamic_waveform -type profile -waveform_files ./dynPowerResults/power.rpt.trn

#-----------------------------------------------------------------------
# Finally run dynamic vector based power based on worst power window.
#-----------------------------------------------------------------------

set_dynamic_power_simulation \
    -reset

set_power_analysis_mode -reset 
set_power_analysis_mode -method event_based \
    -write_static_currents   false \
    -write_dynamic_currents   false \
    -write_profiling_db false \
    -enable_xp true \
    -extraction_tech_file ../data/qrc/qrcTechFile \
    -power_grid_library 	{ \
	../data/pgv_dir/tech_pgv/techonly.cl \
	../data/pgv_dir/stdcell_pgv/stdcells.cl \
	../data/pgv_dir/macro_pgv/macros_pll.cl \
	} 

read_activity_file \
    -reset

read_activity_file \
    -format                     VCD \
    -scope                      FIR_TB.Unit \
    -start                      560ns \
    -end                        600ns \
    -block                      {} \
                                ../design/ncsim.vcd

report_power \
    -outfile                    window_power_vcd.rpt

view_dynamic_waveform -free_data

view_dynamic_waveform \
   -type                        current \
   -composite_waveform_type     total_current \
   -waveform_files              {./dynPowerResults/dynamic_VDD_AO.ptiavg}

suspend

#-----------------------------------------------------------------------
## section3: scripts to run dynamic rail analysis
#-----------------------------------------------------------------------

resume

set_rail_analysis_mode \
    -method                     dynamic \
    -analysis_view              AV_wc_on \
    -power_switch_eco           true \
    -save_voltage_waveforms     true \
    -accuracy                   hd \
    -temperature			125 \
    -gif_resolution             0 \
    -unified_power_switch_flow true \
    -power_grid_library { \
        ../data/pgv_dir/tech_pgv/techonly.cl \
        ../data/pgv_dir/stdcell_pgv/stdcells.cl \
        ../data/pgv_dir/macro_pgv/macros_pll.cl \
    } \
    -enable_xp true \
    -extraction_tech_file ../data/qrc/qrcTechFile

#in XP flow, power and rail can run in one command with the option:set_rail_analysis_mode -report_power_in_parallel true
#in this case, to add options to report_power use "-report_power_options {...}" switch in set_rail_analysis_mode 


#-----------------------------------------------------------------------
# power nets, voltage, power domain are defined by cpf file, you have the following option to redefine them
#-----------------------------------------------------------------------
#set_pg_nets -net VDD_AO     	-voltage 0.9 -threshold 0.85  -force
#set_pg_nets -net VDD_column 	-voltage 0.9 -threshold 0.85  -force
#set_pg_nets -net VDD_ring   	-voltage 0.9 -threshold 0.85  -force
#set_pg_nets -net VDD_external  -voltage 0.9 -threshold 0.85  -force
#set_pg_nets -net VSS        	-voltage 0.0 -threshold 0.05  -force
#set_rail_analysis_domain -name PD1 -pwrnets VDD_AO -gndnets VSS
#set_rail_analysis_domain -name ALL -pwrnets { VDD_AO VDD_external } -gndnets VSS

#-----------------------------------------------------------------------
# define voltage source location
#-----------------------------------------------------------------------
set_power_pads \
    -reset

set_power_pads \
    -net                        VDD_AO \
    -format                     xy \
    -file                       ../design/super_filter_VDD_AO.pp

set_power_pads \
    -net                        VDD_external \
    -format                     xy \
    -file                       ../design/super_filter_VDD_external.pp

set_power_pads \
    -net                        VSS \
    -format                     xy \
    -file                       ../design/super_filter_VSS.pp

#-----------------------------------------------------------------------
#define power consumption
#-----------------------------------------------------------------------
set_power_data \
    -reset

set_dynamic_rail_simulation -reset
set_dynamic_rail_simulation -resolution 50ps

set_power_data \
    -format                     current \
    { \
        dynVecLessPowerResults/dynamic_VDD_AO.ptiavg \
        dynVecLessPowerResults/dynamic_VDD_external.ptiavg \
        dynVecLessPowerResults/dynamic_VSS.ptiavg \
    }

analyze_rail \
    -output          ./dynVecLessRailResults \
    -type                       domain \
				ALL

#-----------------------------------------------------------------------
# Watch the voltage of a particular instance thru the waveform viewer
#-----------------------------------------------------------------------
view_dynamic_waveform \
-type voltage \
-instance_name ref_clk__L1_I0:ir \
-waveform_files { dynVecLessRailResults/ALL_125C_dynamic_1/reports/rail/waveforms/tran_VDD_AO.ptiavg }

#-------------------------------------------------------------------------------------------------------
# Watch VC_SUM = Sum of Voltage sources Current. Waveform shows total current flowing through power pads 
#-------------------------------------------------------------------------------------------------------

view_dynamic_waveform  \
-type {rail_current current}   \
-instance_name VC_SUM  \
-waveform_files { dynVecLessRailResults/ALL_125C_dynamic_1/reports/rail/waveforms/tran_VDD_AO_pad.ptiavg }



