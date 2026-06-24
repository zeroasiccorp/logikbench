###############################
# Reading SC Schema
###############################

source ./sc_manifest.tcl
yosys echo on

set sc_refdir [sc_cfg_tool_task_get refdir]
set fileset [lindex [sc_cfg_get option fileset] 0]

set sc_mode [sc_cfg_tool_task_get var mode]
set sc_command [sc_cfg_tool_task_get var command]
set sc_options [sc_cfg_tool_task_get var options]
set sc_liberty [sc_cfg_tool_task_get var liberty]

# The task's pre_process() dumps a resolved slang command file (sc_rtl.f) that
# flattens the full dependency-fileset graph (+incdir+/+define+/sources). The
# slang options below mirror the lenient handling used elsewhere and keep
# simulation-only constructs out of synthesis:
#   --ignore-assertions  assert/assume/cover property
#   --ignore-initial     initial blocks (e.g. non-blocking sim init)
#   --relax-enum-conversions  implicit int<->enum (e.g. Ara struct literals)
#   --unroll-limit       large compile-time function loops (e.g. hammenc hcol)
set sc_slang_args [list \
    --ignore-assertions \
    --ignore-initial \
    --relax-enum-conversions \
    --unroll-limit 2000000]

###############################
# Read in Design using Slang
################################

yosys plugin -i slang
yosys read_slang --top $sc_topmodule {*}$sc_slang_args -F sc_rtl.f
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
