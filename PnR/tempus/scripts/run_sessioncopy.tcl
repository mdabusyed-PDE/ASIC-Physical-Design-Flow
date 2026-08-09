set_distribute_host -local
set_multi_cpu_usage -localCpu 16 -remoteHost 4 -cpuPerRemoteHost 4
distribute_read_design -design_script ../scripts/loadDesign_DMMMC.tcl -outdir sta
distribute_views -views [list func_slow_CMAX func_fast_CMAX func_slow_RCMAX func_fast_RCMAX func_slow_RMAX func_fast_RMAX func_slow_CMIN func_fast_CMIN func_slow_RCMIN func_fast_RCMIN func_slow_RMIN func_fast_RMIN scan_slow_CMAX scan_fast_CMAX scan_slow_RCMAX scan_fast_RCMAX scan_slow_RMAX scan_fast_RMAX scan_slow_CMIN scan_fast_CMIN scan_slow_RCMIN scan_fast_RCMIN scan_slow_RMIN scan_fast_RMIN test_slow_CMAX test_fast_CMAX test_slow_RCMAX test_fast_RCMAX test_slow_RMAX test_fast_RMAX test_slow_CMIN test_fast_CMIN test_slow_RCMIN test_fast_RCMIN test_slow_RMIN test_fast_RMIN] -script ../scripts/sta.tcl
return 
retur
### To load the .mtarpt per view in GTD environment
foreach mtarpt_file [glob -nocomplain sta/*/design_before_early.mtarpt.gz] {
            load_timing_debug_report -NAME before_early $mtarpt_file}
analyze_paths_by_view
write_category_summary -report category_before_early.rpt


start_gui
suspend

foreach mtarpt_file [glob -nocomplain sta/*/design_before_late.mtarpt.gz] {
            load_timing_debug_report -NAME before_late $mtarpt_file}
analyze_paths_by_view
write_category_summary -report category_before_late.rpt

