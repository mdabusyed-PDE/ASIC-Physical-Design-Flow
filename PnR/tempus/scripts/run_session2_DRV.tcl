source ../scripts/loadDesign_DMMMC.tcl
source ../scripts/spef.tcl

set_delay_cal_mode -SIAware true

set_eco_opt_mode -verbose true
set_eco_opt_mode -load_eco_opt_db ecoTimingDB
restoreRC ../design/ECO_INIT_11_optSetup.enc.dat/dtmf_recvr_core.rcdb.d
set_eco_opt_mode -along_route_buffering true
eco_opt_design -drv

selectInst *ESOC*
