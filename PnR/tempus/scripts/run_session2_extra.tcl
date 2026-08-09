source ../scripts/loadDesign_DMMMC.tcl
source ../scripts/spef.tcl

set_delay_cal_mode -SIAware true

set_eco_opt_mode -verbose true
set_eco_opt_mode -load_eco_opt_db ecoTimingDB
set_eco_opt_mode -hold_target_slack 0.5
eco_opt_design -hold


selectInst *ESOC*
