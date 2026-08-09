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

catch {setEcoMode -legalizeDuringCommit false}
catch {setEcoMode -allowParasiticLoop true}
catch {set_eco_opt_mode -allowParasiticLoop true}
catch {setEcoMode -skipNoLoadRCNodes true}
report_resource
setEcoMode -updateTiming false
setEcoMode -refinePlace false -prefixName ESO -batchMode true -honorDontUse false -honorDontTouch false -honorFixedStatus false
catch { setEcoMode -honorFixedNetWire false }
#ECO_FILE_HEADER_END
#ECO_FILE_FOOTER_START
report_resource
setEcoMode -batchMode false
 
report_resource
setEcoMode -reset 
 
refinePlace -eco true -hardFence false
#ECO_FILE_FOOTER_END
