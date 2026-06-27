###############################################################################
# LogikBench default ASIC timing constraints
###############################################################################
#
# Generic constraints shared by every benchmark. A per-benchmark SDC defines
# its signal lists and then sources this file:
#
#   set clk_port     [get_ports clk]        ;# empty for combinational designs
#   set data_inputs  [get_ports {...}]
#   set data_outputs [get_ports {...}]
#   source $LB_DEFAULT_SDC
#
# The flow injects the timing knobs before the SDC is sourced (LB_CLK_PERIOD is
# in the target's SDC time unit):
#
#   LB_CLK_PERIOD  LB_SETUP_MARGIN  LB_HOLD_MARGIN  LB_LOAD  LB_SLEW
#
###############################################################################

########################################
# Derived parameters
########################################
# External I/O is modeled as a fraction of the clock period so the constraints
# scale with LB_CLK_PERIOD. Setup (-max) uses the larger fraction; hold (-min)
# a small one.

set lb_io_setup [expr {0.20 * $LB_CLK_PERIOD}]
set lb_io_hold  [expr {0.05 * $LB_CLK_PERIOD}]

########################################
# Clock
########################################
# A real clock is created on clk_port when present; combinational designs have
# no clock port, so a virtual clock (same name) is created instead.

if {[llength $clk_port] > 0} {
    create_clock -name clk -period $LB_CLK_PERIOD $clk_port
} else {
    create_clock -name clk -period $LB_CLK_PERIOD
}

set_clock_uncertainty -setup $LB_SETUP_MARGIN [get_clocks clk]
set_clock_uncertainty -hold  $LB_HOLD_MARGIN  [get_clocks clk]

########################################
# Input constraints
########################################

if {[llength $data_inputs] > 0} {
    set_input_delay -clock clk -max $lb_io_setup $data_inputs
    set_input_delay -clock clk -min $lb_io_hold  $data_inputs
    set_input_transition $LB_SLEW $data_inputs
    set_max_capacitance  $LB_LOAD $data_inputs
}

########################################
# Output constraints
########################################

if {[llength $data_outputs] > 0} {
    set_output_delay -clock clk -max $lb_io_setup $data_outputs
    set_output_delay -clock clk -min $lb_io_hold  $data_outputs
    set_load $LB_LOAD $data_outputs
}
