
####Generate ECO Timing DB
set_distribute_host -local
set_multi_cpu_usage -localCpu 2 -remoteHost 2 ;#-cpuPerRemoteHost 4

distribute_read_design -design_script scripts/loadDesign_dmmmc.tcl -outdir sta

set views [list \
func_slow_125_1v62   \
func_typical_25_1v8 \
func_fast_0_1v98 \
]
distribute_views -views $views -script scripts/sta.tcl

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

