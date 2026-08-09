#set_multi_cpu_usage -localCpu 8
#can be run isnide Innovus too
#../tcl/load_design_innovus.tcl
source ../tcl/load_design_voltus.tcl

set_rail_analysis_mode \
	-method 			era_static \
	-accuracy 			xd \
	-extraction_tech_file 		../data/qrc/qrcTechFile \
	-temperature			125 \
	-era_current_region_file 	../tcl/VSS_1.curRegion \
        -era_skip_virtual_via_by_type none \
	-enable_xp true
        
#possibility on top of detection of weak grid, missing vias, followpins .. ERA can
#-era_insert_virtual_via_on_layers { {Metal1 *} } \
#-era_insert_virtual_followpins extended	#default none
#-era_insert_virtual_followpin_for_io true	#default false
#-era_skip_virtual_via_by_type none	#default none
#-era_skip_virtual_via_on_layers {{ layer1 layer2 } { layer3 layer4 } ... }

set_power_pads \
	-format 			xy \
	-file 				../design/super_filter_VSS.pp \
	-net 				VSS

set_pg_nets \
	-net 				VSS \
	-voltage 			0 \
	-threshold 			0.05

analyze_rail \
	-type 				net \
	-results_directory 		./era_run \
					VSS
