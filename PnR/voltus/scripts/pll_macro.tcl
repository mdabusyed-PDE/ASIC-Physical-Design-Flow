#-----------------------------------------------------------------------
# Script used for generating macro power-grid library
# Created for EPS by Bill Wareham
# updated to Voltus 13.2 by Rose Li Nov 2013
# updated to Voltus 14.1 by Rose Li April 2014
# updated to Voltus 15.1 by Rose Li July 2015
#-----------------------------------------------------------------------

read_lib \
    -lef \
        ../data/lef/gsclib090_tech.lef \
        ../data/lef/pll.lef

set_pg_library_mode \
    -gds_files                  ../data/gds/pll.gds \
    -cell_list_file             ../data/voltus/macro.list \
    -power_pins                 {VDD 0.9} \
    -ground_pins                VSS \
    -celltype                   macros \
    -spice_subckts              ../data/netlists/pll.sp \
    -gds_layermap               ../data/voltus/gds.layermap \
    -lef_layermap               ../data/voltus/lefdef.layermap \
    -stop@via                   CONT \
    -spice_models               ../data/netlists/spectre_load.sp \
    -current_distribution       propagation \
    -extraction_tech_file       ../data/qrc/qrcTechFile

set_advanced_pg_library_mode 	\
    -verbosity			true

##set_advanced_pg_library_mode 	\
    -verbosity			true \
    -followpins_tap_layer lowest_lef_pin_layer

generate_pg_library \
    -output                     macro_pgv/


exit
