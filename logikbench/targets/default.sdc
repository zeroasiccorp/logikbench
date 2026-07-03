###############################################################################
# LogikBench default ASIC timing constraints
#
# File: logikbench/targets/default.sdc
###############################################################################
#
# Generic constraints shared by every benchmark. A per-benchmark SDC defines
# its signal lists and then sources this file:
#
#   set LB_CLK     [get_ports -quiet {*clk* *clock*}]  ;# clock port(s)
#   set LB_INPUTS  [all_inputs]             ;# clock ports removed below
#   set LB_OUTPUTS [all_outputs]
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
# One real clock per detected clock port (named after the port), so multi-clock
# designs (e.g. rx_clk/tx_clk) are constrained; all share LB_CLK_PERIOD.
# Combinational designs have no clock port, so a virtual clock is created.
# LB_IOCLK is the clock the I/O delays reference (the first real clock, else
# the virtual clock).

if {[llength $LB_CLK] > 0} {
    foreach _clkport $LB_CLK {
        set _clkname [get_name $_clkport]
        create_clock -name $_clkname -period $LB_CLK_PERIOD $_clkport
        set_clock_uncertainty -setup $LB_SETUP_MARGIN [get_clocks $_clkname]
        set_clock_uncertainty -hold  $LB_HOLD_MARGIN  [get_clocks $_clkname]
    }
    set LB_IOCLK [get_name [lindex $LB_CLK 0]]
} else {
    create_clock -name clk -period $LB_CLK_PERIOD
    set_clock_uncertainty -setup $LB_SETUP_MARGIN [get_clocks clk]
    set_clock_uncertainty -hold  $LB_HOLD_MARGIN  [get_clocks clk]
    set LB_IOCLK clk
}

########################################
# Input constraints
########################################
# Remove the clock port(s) from LB_INPUTS so I/O constraints never land on the
# clock (LB_INPUTS may be [all_inputs]). Filtered by name: this OpenSTA has no
# remove_from_collection.

set _clknames {}
foreach _c $LB_CLK { lappend _clknames [get_name $_c] }
set _datains {}
foreach _p $LB_INPUTS {
    if { [get_name $_p] ni $_clknames } { lappend _datains $_p }
}
set LB_INPUTS $_datains

if {[llength $LB_INPUTS] > 0} {
    # how long after clock edge data arrives at input
    set_input_delay -clock $LB_IOCLK -max $LB_IO_IDELAY $LB_INPUTS
    set_input_delay -clock $LB_IOCLK -min $LB_IO_HOLD  $LB_INPUTS
    set_input_transition $LB_SLEW $LB_INPUTS
    set_max_capacitance  $LB_LOAD $LB_INPUTS
}

########################################
# Output constraints
########################################

if {[llength $LB_OUTPUTS] > 0} {
    # external delay after our output; data must be ready this long before the edge
    set_output_delay -clock $LB_IOCLK -max $LB_IO_ODELAY $LB_OUTPUTS
    set_output_delay -clock $LB_IOCLK -min $LB_IO_HOLD  $LB_OUTPUTS
    set_load $LB_LOAD $LB_OUTPUTS
}
