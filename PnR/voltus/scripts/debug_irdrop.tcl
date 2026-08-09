
debug_irdrop -state_directory dynVecLessRailResults/ALL_125C_dynamic_1 -domain ALL 


# debug_irdrop on specific net
debug_irdrop -state_directory dynVecLessRailResults/ALL_125C_dynamic_1/VDD_AO -net VDD_A0 -output_directory IR_DBG/net

# debug_irdrop on all domain, generating eco file
debug_irdrop -state_directory dynVecLessRailResults/ALL_125C_dynamic_1 -domain ALL -eco_report -output_directory IR_DBG/noregion

# debug_irdrop on all domain, zoomed to a region, generating eco file
debug_irdrop -state_directory dynVecLessRailResults/ALL_125C_dynamic_1 -domain ALL -region {20 8 177 138} -eco_report -output_directory IR_DBG/region
