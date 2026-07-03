###############################################################################
# LogikBench default ASIC timing constraints
#
# File: logikbench/targets/default.sdc
###############################################################################
#
# Generic constraints shared by every benchmark. A per-benchmark SDC defines
# its signal lists and then sources this file:
#
#   set LB_CLK     [get_ports clk]          ;# empty for combinational designs
#   set LB_INPUTS  [get_ports {...}]
#   set LB_OUTPUTS [get_ports {...}]
#   source default.sdc
#
# The technology file (tech.tcl) injects the timing knobs before this file is
# sourced (LB_CLK_PERIOD is in the target's SDC time unit):
#
#   LB_CLK_PERIOD  LB_SETUP_MARGIN  LB_HOLD_MARGIN  LB_LOAD  LB_SLEW
#
###############################################################################

########################################
# Derived parameters
########################################
# External I/O delays. Input/output delays scale with the clock period;
# hold is a fixed floor (not frequency dependent).

set LB_IO_IDELAY [expr {0.50 * $LB_CLK_PERIOD}]
set LB_IO_ODELAY [expr {0.50 * $LB_CLK_PERIOD}]
set LB_IO_HOLD  0

########################################
# Clock
########################################
# A real clock is created on LB_CLK when present; combinational designs have
# no clock port, so a virtual clock (same name) is created instead.

if {[llength $LB_CLK] > 0} {
    create_clock -name clk -period $LB_CLK_PERIOD $LB_CLK
} else {
    create_clock -name clk -period $LB_CLK_PERIOD
}

set_clock_uncertainty -setup $LB_SETUP_MARGIN [get_clocks clk]
set_clock_uncertainty -hold  $LB_HOLD_MARGIN  [get_clocks clk]

########################################
# Input constraints
########################################

if {[llength $LB_INPUTS] > 0} {
    # how long after clock edge data arrives at input
    set_input_delay -clock clk -max $LB_IO_IDELAY $LB_INPUTS
    set_input_delay -clock clk -min $LB_IO_HOLD  $LB_INPUTS
    set_input_transition $LB_SLEW $LB_INPUTS
    set_max_capacitance  $LB_LOAD $LB_INPUTS
}

########################################
# Output constraints
########################################

if {[llength $LB_OUTPUTS] > 0} {
    # external delay after our output; data must be ready this long before the edge
    set_output_delay -clock clk -max $LB_IO_ODELAY $LB_OUTPUTS
    set_output_delay -clock clk -min $LB_IO_HOLD  $LB_OUTPUTS
    set_load $LB_LOAD $LB_OUTPUTS
}
