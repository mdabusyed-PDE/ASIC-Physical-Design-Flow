#-----------------------------------------------------------------------
# Scripts to generate techonly library
# Created for EPS by Bill Wareham
# updated to Voltus 13.2 by Rose Li Nov 2013
# updated to Voltus 14.1 by Rose Li April 2014
# updated to Voltus 15.1 by Rose Li July 2015
#-----------------------------------------------------------------------
read_lib \
    -lef \
        /pdk/sky130_scl_9T_0.1.2/sky130_scl_9T_tech/lef/sky130_scl_9T.tlef \
	/pdk/sky130_scl_9T_0.1.2/sky130_scl_9T/lef/sky130_scl_9T.lef \
	/pdk/sky130_scl_9T_0.1.2/sky130_scl_9T_LP/lef/sky130_scl_9T_LP.lef \
	/pdk/sky130_scl_9T_0.1.2/sky130_scl_9T_HS/lef/sky130_scl_9T_HS.lef \
	/pdk/sky130_scl_9T_0.1.2/sky130_scl_9T_tech/lef/sky130_scl_9T_phyCells.lef


set_pg_library_mode \
    -celltype                   techonly \
    -ground_pins                VSS \
    -power_pins                 {VDD 0.9 VDDG 0.9 TVDD 0.9} \
    -decap_cells                {DECAP8 DECAP64 DECAP4 DECAP32 DECAP2 DECAP16 DECAP1} \
    -filler_cells               { FILL8  FILL64  FILL4  FILL32  FILL2  FILL16  FILL1} \
    -default_area_cap           0.01 \
    -cell_decap_file            ../data/voltus/decap.cmd \
    -extraction_tech_file       /pdk/sky130_release_0.1.0/quantus/extraction/typical/qrcTechFile \
    -lef_layermap               ../data/voltus/lefdef.layermap \
    -powergate_parameters { \
        {RING_SWITCH   TVDD VDD 750 0.5 4.0e-8} \
        {HEADER_SWITCH TVDD VDD 750 0.5 4.0e-8} \
    }

generate_pg_library \
    -output                     tech_pgv
exit
