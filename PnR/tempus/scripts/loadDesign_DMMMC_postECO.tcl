read_view_definition viewDefinition.tcl

#read_verilog "innovus_postECO.enc.dat/vbin/darksocv.v.bin"
read_verilog "innovus_postECO.v"

set_top_module darksocv -ignore_undefined_cell

#read_def "postroute_postECO.def"

