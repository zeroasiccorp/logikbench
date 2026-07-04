###############################################################################
# Technology Settings
#
# File: logikbench/targets/asap7/tech.tcl
###############################################################################
#
# Per-technology LogikBench timing constants, expressed in this PDK's liberty
# units. ASAP7 liberty units: time = 1 ps, capacitance = 1 fF. These are
# consumed by the generic command body (default.sdc) after a benchmark SDC
# defines its signal lists.
#
###############################################################################

# Liberty time unit for this PDK, in nanoseconds (ASAP7 time = 1 ps = 0.001 ns).
# Used to convert lb --clk (always nanoseconds) into the SDC command time unit.
set LB_TIME_UNIT_NS 0.001

# Clock period. lb --clk supplies the target period in nanoseconds via
# LB_CLK_NS (the only external timing number); it is converted to this PDK's
# SDC time unit here. Default 0.5 ns when the flow does not set LB_CLK_NS.
if {![info exists LB_CLK_NS]} {
    set LB_CLK_NS 0.5
}
set LB_CLK_PERIOD [expr {$LB_CLK_NS / $LB_TIME_UNIT_NS}]

# Clock uncertainty (ps): ~5% / ~2% of the default period (jitter + skew)
set LB_SETUP_MARGIN 25.0
set LB_HOLD_MARGIN  10.0

# External output load / max capacitance (fF): FO4 = 4 x INVx1 input cap (0.68 fF)
set LB_LOAD 2.7

# Input transition / slew (ps): ~25% of default_max_transition (320 ps)
set LB_SLEW 80.0
