###############################################################################
# LogikBench default ASIC timing constraints
#
# File: logikbench/targets/default.sdc
###############################################################################
#
# Generic ASIC constraints applied to every benchmark. This file is
# self-sufficient: a benchmark that ships no custom SDC is constrained entirely
# by the guardbanded defaults below (every *clk*/*clock* port is clocked, all
# data inputs/outputs are constrained, per-PDK knobs come from tech.tcl). A
# benchmark that needs custom constraints ships its own SDC that sets any of
# LB_CLK / LB_INPUTS / LB_OUTPUTS before sourcing this file; the guards below
# then keep those values instead of deriving them.
#
# Injected by the flow wrapper: LB_CLK_NS (lb --clk, in ns), LB_TECH_FILE (the
# per-PDK tech.tcl providing LB_CLK_PERIOD + LB_SETUP_MARGIN / LB_HOLD_MARGIN /
# LB_LOAD / LB_SLEW), and LB_DEFAULT_SDC (this file).
#
###############################################################################

########################################
# Guardbanded defaults
########################################
# Source the per-PDK knobs (tech.tcl) and derive the signal lists, unless a
# benchmark SDC already set them before sourcing this file.

if {![info exists LB_CLK_PERIOD]} { source $LB_TECH_FILE }
if {![info exists LB_CLK]} { set LB_CLK [get_ports -quiet {*clk* *clock*}] }
if {![info exists LB_INPUTS]} { set LB_INPUTS [all_inputs] }
if {![info exists LB_OUTPUTS]} { set LB_OUTPUTS [all_outputs] }

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

########################################
# Re-entrancy (Temporary workaround)
########################################
# read_sdc may run several times in one persistent STA session that re-reads
# the netlist and re-links between reads. The guarded
# scalar knobs from tech.tcl are plain numbers and safely persist. A benchmark
# SDC re-sets its own LB_CLK / LB_INPUTS / LB_OUTPUTS before sourcing this file.
unset -nocomplain LB_CLK LB_INPUTS LB_OUTPUTS LB_IOCLK
