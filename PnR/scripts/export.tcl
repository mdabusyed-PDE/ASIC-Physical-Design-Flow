
# Export Design Data
saveNetlist output/darksocv_pnr_fill.v -includePhysicalinst -includePOwerGround
streamOut -merge "/pdk/gpdk045/gsclib045_all_v4.8/gsclib045/gds/gsclib045.gds /pdk/gpdk045/gsclib045_all_v4.8/gsclib045_hvt/gds/gsclib045_hvt.gds /pdk/gpdk045/gsclib045_all_v4.8/gsclib045_lvt/gds/gsclib045_lvt.gds " -mapFile /pdk/gpdk045/gpdk045_v_6_0/soce/streamOut.map output/darksocv_fill.gds

defOut -netlist -floorplan output/darksocv_fill.def
write_lef_abstract -stripePin -PGPinLayers { 4 5 } output/darksocv_fill.lef
set_analysis_view -setup {func_slow_125_1v0 func_fast_125_1v2} -hold {func_slow_125_1v0 func_fast_125_1v2}
do_extract_model -view func_slow_125_1v0 output/darksocv_slow_fill.lib
do_extract_model -view func_fast_125_1v2 output/darksocv_fast_fill.lib

