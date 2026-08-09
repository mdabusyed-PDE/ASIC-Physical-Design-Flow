#-----------------------------------------------------------------------
# scripts to run resistance analysis
# created for Voltus 15.1 by Rose Li July 2015
#-----------------------------------------------------------------------
## load design
#-----------------------------------------------------------------------
source ../tcl/load_design_voltus.tcl

#-----------------------------------------------------------------------
# Static Rail Analysis
#-----------------------------------------------------------------------
set_rail_analysis_mode \
    -method				static \
    -accuracy                  		xd \
    -analysis_view			AV_wc_on \
    -enable_xp true \
    -extraction_tech_file ../data/qrc/qrcTechFile \
    -power_grid_library\
    		{ \
        	../data/pgv_dir/tech_pgv/techonly.cl \
        	../data/pgv_dir/stdcell_pgv/stdcells.cl \
        	../data/pgv_dir/macro_pgv/macros_pll.cl \
    		} \
    -verbosity 				true \
    -temperature 			125


#set up domain
#set_pg_nets \
	-net 				VDD_external \
	-voltage 			0.9 \
	-threshold 			0.895

#set_pg_nets \
	-net 				VDD_AO \
	-voltage 		  	0.9 \
	-threshold 		  	0.895

#set_pg_nets \
	-net 			  	VSS \
	-voltage   			0 \
	-threshold   			0.05

#set_rail_analysis_domain \
	-name 	  			ALL \
	-pwrnets   			{VDD_external VDD_AO} \
	-gndnets   			VSS

#set up power pad location
set_power_pads \
	-reset

set_power_pads \
	-net 	  			VSS \
	-format   			xy \
	-file 	  			../design/super_filter_VSS.pp

set_power_pads \
	-net 	  			VDD_external \
	-format   			xy \
	-file 	  			../design/super_filter_VDD_external.pp

set_power_pads \
	-net 	  			VDD_AO \
	-format   			xy \
	-file 	  			../design/super_filter_VDD_AO.pp

analyze_resistance \
	-domain   			ALL \
	-output_dir     		Reff_domain

## Load state dir and effective resistance plot
#read_power_rail_results -rail_directory Reff_domain/ALL_125C_reff_1
#report_power_rail_results \
	-plot				effr

#VSS analysis only (net based)
set_power_pads \
	-reset

set_power_pads \
	-net 	  			VSS \
	-format   			xy \
	-file 	  			../design/super_filter_VSS.pp


set_pg_nets \
	-net 				VSS \
	-voltage 			0 \
	-threshold 			0.01

#Node based effective resistance analysis
analyze_resistance \
	-net 				VSS \
	-output_dir 			Reff_VSS_node \
	-node_list 			{{ 283.524 1.3695 Metal4 n1 } { 328.715 51.040 Metal1 n2 }} 

#Node pair based effective resistance analysis
analyze_resistance \
	-net 				VSS \
	-output_dir 			Reff_VSS_n_to_n \
	-node_pair_list 		{{328.715 51.040 Metal1 113.552 1.9165 Metal4 }}

#instance pair based effective resistance analysis
#analyze_resistance \
        -net VSS \
        -output_dir Reff_VSS_inst \
	-instance_list {{AO2/REG1_reg_1_0 VSS} {AO2/MULT8_reg_1_7 VSS}}

