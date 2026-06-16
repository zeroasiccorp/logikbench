###############################
# Reading SC Schema
###############################

source ./sc_manifest.tcl

yosys echo on

###############################
# Synthesis Logic
###############################


########################################################
# Record Stats
########################################################

# turn off echo to prevent the stat command from showing up in the json file
yosys echo off
yosys tee -o ./reports/stat.json stat -json -top $sc_topmodule {*}$stat_libs
yosys echo on

########################################################
# Write Outputs
########################################################
yosys write_verilog -noexpr -nohex -nodec "outputs/${sc_topmodule}.vg"
yosys write_json "outputs/${sc_topmodule}.netlist.json"
