source ../scripts/loadDesign_DMMMC.tcl
source ../scripts/spef.tcl

set_delay_cal_mode -SIAware true

set_eco_opt_mode -verbose true
set_eco_opt_mode -load_eco_opt_db ecoTimingDB

restoreRC ../design/ECO_INIT_11_optSetup.enc.dat/dtmf_recvr_core.rcdb.d
set_eco_opt_mode -along_route_buffering true

set_eco_opt_mode -allow_multiple_incremental true
set_eco_opt_mode -eco_file_prefix DRV
eco_opt_design -drv


set_eco_opt_mode -eco_file_prefix SETUP
eco_opt_design -setup


set_eco_opt_mode -eco_file_prefix HOLD
eco_opt_design -hold

selectInst *ESOC*
