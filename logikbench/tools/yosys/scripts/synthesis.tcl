###############################
# Reading SC Schema
###############################

source ./sc_manifest.tcl
yosys echo on

# interface
set sc_refdir [sc_cfg_tool_task_get refdir]
set fileset [lindex [sc_cfg_get option fileset] 0]
set sc_mode [sc_cfg_tool_task_get var mode]
set sc_command [sc_cfg_tool_task_get var command]
set sc_options [sc_cfg_tool_task_get var options]
set sc_liberty [sc_cfg_tool_task_get var liberty]
set sc_macrolib [sc_cfg_tool_task_get var macrolib]
set sc_ignore_initial [sc_cfg_tool_task_get var ignore_initial]
set sc_lintonly [sc_cfg_tool_task_get var lintonly]

# The task's pre_process() dumps a resolved slang command file (sc_rtl.f) that
# flattens the full dependency-fileset graph (+incdir+/+define+/sources). The
# slang options below keep simulation-only constructs out of synthesis:
#   --ignore-assertions  assert/assume/cover property
#   --relax-enum-conversions  implicit int<->enum (e.g. Ara struct literals)
set sc_slang_args [list \
    --ignore-assertions \
    --relax-enum-conversions]

# initial blocks are honored by default, so ROM/table content and memory init
# synthesize (and ROMs infer BRAM on FPGA). Benchmarks whose initial blocks are
# simulation-only (e.g. $finish parameter checks, $readmemh of files not
# shipped) opt out by setting the 'ignore_initial' task var.
if { $sc_ignore_initial } {
    lappend sc_slang_args --ignore-initial
}

# Forward the design fileset's top-level parameter overrides (set via
# Design.set_param) to slang as '-G <name>=<value>'. The resolved slang command
# file (sc_rtl.f) carries +incdir+/+define+/sources but NOT params, so without
# this a set_param has no effect on synthesis. Mirrors SC's own
# sc_synth_asic.tcl.
set sc_designlib [sc_cfg_get option design]
if { [sc_cfg_exists library $sc_designlib fileset $fileset param] } {
    dict for {key value} [sc_cfg_get library $sc_designlib fileset $fileset param] {
        lappend sc_slang_args -G "${key}=${value}"
    }
}

###############################
# Read in Design using Slang
################################

# Read hard-macro liberties as blackboxes FIRST so slang links an instantiated
# macro (e.g. the SRAM the lambdalib memory alias binds) to a blackbox module
# instead of erroring on an unknown module or synthesizing it to flops. Empty
# for FPGA and macro-free ASIC designs.
foreach macro_lib $sc_macrolib {
    yosys read_liberty -lib $macro_lib
}

yosys plugin -i slang
yosys read_slang --top $sc_topmodule {*}$sc_slang_args -F sc_rtl.f
yosys hierarchy -check -top $sc_topmodule

###############################
# Synthesis Logic
###############################

# select the per-mode synthesis core: <refdir>/<mode>/synthesis_<mode>.tcl.
# lint-only stops here (after elaborate + hierarchy check): the stats/outputs
# below still emit the elaborated netlist so the run succeeds quickly.
if { !$sc_lintonly } {
    set script "$sc_refdir/$sc_mode/synthesis_$sc_mode.tcl"
    source $script
}

########################################################
# Record Stats
########################################################

# 'stat' runs without a liberty: on the ASIC path cell area comes from the
# OpenSTA timing node (SC TimingTask), and passing a gzipped liberty here would
# tee yosys' "decompressing" message into the JSON report and break parsing.
yosys echo off
yosys tee -o ./reports/stat.json stat -json -top $sc_topmodule
yosys echo on

########################################################
# Write Outputs
########################################################
yosys write_verilog -noexpr -nohex -nodec "outputs/${sc_topmodule}.vg"
yosys write_json "outputs/${sc_topmodule}.netlist.json"
