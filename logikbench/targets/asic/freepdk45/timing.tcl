# OpenSTA timing recipe for the LogikBench 'nangate45' target.
#
# Driven by SiliconCompiler as: sta -no_init -exit timing.tcl
# Reads the synthesized netlist staged from the synthesis node; the liberty
# and SDC paths are passed as task variables by the flow.

source ./sc_manifest.tcl

set top $sc_topmodule
set liberty [lindex [sc_cfg_tool_task_get var liberty] 0]
set sdc [lindex [sc_cfg_tool_task_get var sdc] 0]

read_liberty $liberty
read_verilog "inputs/$top.vg"
link_design $top

if { $sdc ne "" && [file exists $sdc] } {
    read_sdc $sdc
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
