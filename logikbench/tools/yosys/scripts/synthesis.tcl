###############################
# Reading SC Schema
###############################

source ./sc_manifest.tcl
yosys echo on

set sc_refdir [sc_cfg_tool_task_get refdir]
set fileset [lindex [sc_cfg_get option fileset] 0]

set sc_rtl [concat \
    [sc_cfg_get_fileset $sc_designlib $fileset systemverilog] \
    [sc_cfg_get_fileset $sc_designlib $fileset verilog]]


set sc_mode [sc_cfg_tool_task_get var mode]
set sc_command [sc_cfg_tool_task_get var command]
set sc_options [sc_cfg_tool_task_get var options]
set sc_liberty [sc_cfg_tool_task_get var liberty]

set sc_slang_args {}
if { [sc_cfg_exists library $sc_designlib fileset $fileset idir] } {
    foreach dir [sc_cfg_get library $sc_designlib fileset $fileset idir] {
        lappend sc_slang_args -I $dir
    }
}
if { [sc_cfg_exists library $sc_designlib fileset $fileset define] } {
    foreach def [sc_cfg_get library $sc_designlib fileset $fileset define] {
        lappend sc_slang_args -D $def
    }
}

###############################
# Read in Design using Slang
################################

yosys plugin -i slang
yosys read_slang --top $sc_topmodule --ignore-assertions {*}$sc_slang_args {*}$sc_rtl
yosys hierarchy -check -top $sc_topmodule

###############################
# Synthesis Logic
###############################

# select the per-mode synthesis core: <refdir>/<mode>/synthesis_<mode>.tcl
set script "$sc_refdir/$sc_mode/synthesis_$sc_mode.tcl"
source $script

########################################################
# Record Stats
########################################################

# liberty (ASIC only) lets 'stat' report cell area
set stat_libs {}
if {$sc_liberty ne ""} {
    set stat_libs [list -liberty $sc_liberty]
}

# turn off echo to prevent the stat command from showing up in the json file
yosys echo off
yosys tee -o ./reports/stat.json stat -json -top $sc_topmodule {*}$stat_libs
yosys echo on

########################################################
# Write Outputs
########################################################
yosys write_verilog -noexpr -nohex -nodec "outputs/${sc_topmodule}.vg"
yosys write_json "outputs/${sc_topmodule}.netlist.json"
