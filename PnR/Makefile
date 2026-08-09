#BLOCK:=darksocv

init:
	innovus -init scripts/$@.tcl -log logs/$@.log 
place: init
	innovus -init scripts/$@.tcl -log logs/$@.log
cts: place
	innovus -init scripts/$@.tcl -log logs/$@.log
route: cts
	innovus -init scripts/$@.tcl -log logs/$@.log
lvs: route
	mkdir -p phy_ver ; \
	mkdir -p phy_ver/lvs ; \
	cd phy_ver/lvs ; \
	v2cdl -v ../../output/$(BLOCK)_pnr.v -o $(BLOCK).cdl -s0 VSS -s1 VDD -s "/pdk/gpdk045/gsclib045_all_v4.8/gsclib045/cdl/gsclib045.cdl /pdk/gpdk045/gsclib045_all_v4.8/gsclib045_lvt/cdl/gsclib045_lvt.cdl /pdk/gpdk045/gsclib045_all_v4.8/gsclib045_hvt/cdl/gsclib045_hvt.cdl " -lsr "/pdk/gpdk045/gsclib045_all_v4.8/gsclib045/cdl/gsclib045.cdl /pdk/gpdk045/gsclib045_all_v4.8/gsclib045_lvt/cdl/gsclib045_lvt.cdl /pdk/gpdk045/gsclib045_all_v4.8/gsclib045_hvt/cdl/gsclib045_hvt.cdl" -exclude_empty_module ; \
	pegasus -lvs -gds ../../output/$(BLOCK).gds -top_cell $(BLOCK) -source_cdl $(BLOCK).cdl -source_top_cell $(BLOCK) -automatch -run_dir runDir_LVS -log_dir LOGS -ui_data /pdk/gpdk045/gpdk045_v_6_0/pvs/pvlLVS.rul 2>&1 | tee pegasus.log.1 
drc: route
	mkdir -p phy_ver ; \
	mkdir -p phy_ver/drc ; \
	cd phy_ver/drc ; \
	pegasus -lvs -gds ../../output/$(BLOCK).gds -top_cell $(BLOCK) -run_dir runDir_DRC -log_dir LOGS /pdk/gpdk045/gpdk045_v_6_0/pvs/pvlDRC.rul 2>&1 | tee pegasus.log.1
	
