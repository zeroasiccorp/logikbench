# OpenSTA timing recipe for LogikBench ASIC runs (PDK-agnostic).
#
# Driven by SiliconCompiler as: sta -no_init -exit timing.tcl
# Reads the synthesized netlist staged from the synthesis node. Task variables
# from the flow: the liberty, the benchmark SDC, lb --clk (ns), and the
# tech.tcl / default.sdc paths the benchmark SDC sources. All PDK-specific
# timing constants live in each PDK's tech.tcl, so this recipe is shared.

source ./sc_manifest.tcl

set top $sc_topmodule
set liberty [lindex [sc_cfg_tool_task_get var liberty] 0]
set sdc [lindex [sc_cfg_tool_task_get var sdc] 0]

read_liberty $liberty
read_verilog "inputs/$top.vg"
link_design $top

# Constraints. The benchmark SDC (when present) declares its signal lists and
# sources $LB_TECH_FILE (ns->unit scaling + knobs) then $LB_DEFAULT_SDC (the
# shared body). lb --clk arrives in nanoseconds via LB_CLK_NS. A benchmark that
# ships no SDC runs unconstrained. Sourced (not read_sdc) so the injected LB_*
# variables are visible to the benchmark SDC.
set LB_CLK_NS      [lindex [sc_cfg_tool_task_get var clk] 0]
set LB_TECH_FILE   [lindex [sc_cfg_tool_task_get var techfile] 0]
set LB_DEFAULT_SDC [lindex [sc_cfg_tool_task_get var defaultsdc] 0]
if { $sdc ne "" && [file exists $sdc] } {
    source $sdc
}

# fmax = 1 / (minimum achievable clock period), reported in MHz so the task
# can parse it. Only meaningful for clocked (sequential) designs.
set fmax_metric 0.0
foreach clk [all_clocks] {
    set min_period [sta::find_clk_min_period $clk 1]
    if { $min_period > 0.0 } {
        set fmax_metric [expr { max($fmax_metric, 1.0 / $min_period) }]
    }
}
if { $fmax_metric > 0.0 } {
    puts "fmax = [format %.2f [expr { $fmax_metric / 1e6 }]] MHz"
}

# worst setup slack is only meaningful for clocked designs
if { [llength [all_clocks]] > 0 } {
    puts "worst slack [format %.4f [sta::worst_slack -max]]"
}
