set_distribute_host -local
set_multi_cpu_usage -localCpu 2 -remoteHost 2 ; #-cpuPerRemoteHost 4

distribute_read_design -design_script scripts/loadDesign_DMMMC_postECO.tcl -outdir sta_postECO
distribute_views -views [list func_slow_125_1v62 func_typical_25_1v8 func_fast_0_1v98] -script scripts/sta_postECO.tcl


foreach mtarpt_file [glob -nocomplain sta_postECO/*/design_after_early.mtarpt.gz] {
            load_timing_debug_report -NAME before_early $mtarpt_file}
analyze_paths_by_view
write_category_summary -report category_after_early.rpt


start_gui


#suspend

foreach mtarpt_file [glob -nocomplain sta_postECO/*/design_after_late.mtarpt.gz] {
            load_timing_debug_report -NAME after_late $mtarpt_file}
analyze_paths_by_view
write_category_summary -report category_after_late.rpt

