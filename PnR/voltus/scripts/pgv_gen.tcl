#-----------------------------------------------------------------------
# scripts to generating power-grid library 
# Created for EPS by Bill Wareham
# updated to Voltus 13.2 by Rose Li Nov 2013
# updated to Voltus 14.1 by Rose Li April 2014
# updated to Voltus 15.1 by Rose Li July 2015
#-----------------------------------------------------------------------
set_distribute_host -local

set_multi_cpu_usage -local 16

#set_pg_library_mode -enable_distributed_processing true
#-----------------------------------------------------------------------
# Load LEF files
#-----------------------------------------------------------------------
read_lib \
    -lef \
        ../data/lef/gsclib090_tech.lef \
	../data/lef/buf_ao.lef \
	../data/lef/decap.lef \
        ../data/lef/gsclib090_macro.lef \
        ../data/lef/pso_header.lef  \
        ../data/lef/pso_ring.lef \
        ../data/lef/pll.lef

#-----------------------------------------------------------------------
# Technology library generation
#-----------------------------------------------------------------------
set_pg_library_mode \
    -ground_pins                VSS \
    -power_pins                 {VDD 0.9 VDDG 0.9 TVDD 0.9} \
    -decap_cells                {DECAP8 DECAP64 DECAP4 DECAP32 DECAP2 DECAP16 DECAP1} \
    -filler_cells               { FILL8  FILL64  FILL4  FILL32  FILL2  FILL16  FILL1} \
    -default_area_cap           0.01 \
    -celltype                   techonly \
    -cell_decap_file            ../data/voltus/decap.cmd \
    -lef_layermap               ../data/voltus/lefdef.layermap \
    -extraction_tech_file       ../data/qrc/qrcTechFile \
    -powergate_parameters { \
            {RING_SWITCH   TVDD VDD 750 0.5 4.0e-8} \
	    {HEADER_SWITCH TVDD VDD 750 0.5 4.0e-8} \
	}


generate_pg_library \
    -output                     tech_pgv

#-----------------------------------------------------------------------
# Standard cells pgv generation
#-----------------------------------------------------------------------
set_pg_library_mode \
    -ground_pins                VSS \
    -power_pins                 {VDD 0.9 TVDD 0.9} \
    -decap_cells                {DECAP8 DECAP64 DECAP4 DECAP32 DECAP2 DECAP16 DECAP1} \
    -filler_cells               { FILL8  FILL64  FILL4  FILL32  FILL2  FILL16  FILL1} \
    -celltype                   stdcells \
    -cell_decap_file            ../data/voltus/decap.cmd \
    -cell_list_file 		../data/voltus/cell.list \
    -spice_subckts { \
        ../data/netlists/gsclib090.sp \
        ../data/netlists/pso_header.spi \
        ../data/netlists/pso_ring.spi \
    } \
    -lef_layermap               ../data/voltus/lefdef.layermap \
    -current_distribution       propagation \
    -spice_models               ../data/netlists/spectre_load.sp \
    -extraction_tech_file       ../data/qrc/qrcTechFile \
    -powergate_parameters { \
        {RING_SWITCH   TVDD VDD} \
        {HEADER_SWITCH TVDD VDD} \
    }

generate_pg_library \
    -output                     stdcell_pgv

#-----------------------------------------------------------------------
# Macro pll pgv generation
#-----------------------------------------------------------------------
set_pg_library_mode \
    -gds_files                  ../data/gds/pll.gds \
    -ground_pins                VSS \
    -cell_list_file             ../data/voltus/macro.list \
    -power_pins                 {VDD 0.9} \
    -celltype                   macros \
    -spice_subckts              ../data/netlists/pll.sp \
    -gds_layermap               ../data/voltus/gds.layermap \
    -lef_layermap               ../data/voltus/lefdef.layermap \
    -stop@via                   CONT \
    -spice_models               ../data/netlists/spectre_load.sp \
    -current_distribution       propagation \
    -extraction_tech_file       ../data/qrc/qrcTechFile

generate_pg_library \
    -output                     macro_pgv/
