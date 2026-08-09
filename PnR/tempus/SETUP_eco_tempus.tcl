#ECO_FILE_HEADER_START
# eco_opt_design -setup
# set_eco_opt_mode settings :
# 	 -setup_target_slack 0.050
# 	 -eco_file_prefix "SETUP"
# 	 -verbose true
# 	 -load_eco_opt_db "ecoTimingDB"
# 	 -allow_multiple_incremental true
# 	 -along_route_buffering false
# =====================

catch {set_eco_mode -legalize_during_commit false}
catch {set_eco_mode -allow_parasitic_loop true}
catch {set_eco_opt_mode -allowParasiticLoop true}
catch {set_eco_mode -skip_no_load_rc_nodes true}
report_resource
set_eco_mode -esomode true -prefixname ESO
#ECO_FILE_HEADER_END
#ECO_FILE_FOOTER_START
report_resource
set_eco_mode -esomode false
 
report_resource
set_eco_mode -reset 
 
#ECO_FILE_FOOTER_END
