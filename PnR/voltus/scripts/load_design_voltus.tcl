#------------------------------------------------------
# load design
#------------------------------------------------------

#------------------------------------------------------
# set multi CPU
# ------------------------------------------------------
set_multi_cpu_usage \
        -localCpu                       8
# -------------------------------
# script for loading design 
# -------------------------------
set lefs [list]
lappend lefs ../data/lef/gsclib090_tech.lef
lappend lefs ../data/lef/gsclib090_macro.lef
lappend lefs ../data/lef/pll.lef
lappend lefs ../data/lef/decap.lef
lappend lefs ../data/lef/pso_header.lef
lappend lefs ../data/lef/pso_ring.lef
lappend lefs ../data/lef/buf_ao.lef
read_lib -lef $lefs

read_view_definition ../design/viewDefinition.tcl

read_verilog ../design/postRouteOpt.enc.dat/super_filter.v.gz
set_top_module super_filter -ignore_undefined_cell

read_def ../design/super_filter.def.gz

#-----------------------------------------------------------------------
# Read cpf file for power domain information
#-----------------------------------------------------------------------
read_power_domain -cpf ../design/super_filter.cpf

#-----------------------------------------------------------------------
# Read spef file
#-----------------------------------------------------------------------
read_spef \
    -rc_corner                  RC_wc_125 \
    -decoupled				\
                                    ../design/postRouteOpt_RC_wc_125.spef.gz

