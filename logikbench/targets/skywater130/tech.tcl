###############################################################################
# Technology Settings
#
# File: logikbench/targets/skywater130/tech.tcl
###############################################################################
#
# Per-technology LogikBench timing constants, expressed in this PDK's liberty
# units. Skywater130 (sky130hd) liberty units: time = 1 ns, capacitance = 1 pf.
# These are consumed by the generic command body (default.sdc) after a
# benchmark SDC defines its signal lists.
#
###############################################################################

# Liberty time unit for this PDK, in nanoseconds (sky130hd time = 1 ns).
# Used to convert lb --clk (always nanoseconds) into the SDC command time unit.
set LB_TIME_UNIT_NS 1.0

# Clock period. lb --clk supplies the target period in nanoseconds via
# LB_CLK_NS (the only external timing number); it is converted to this PDK's
# SDC time unit here. Default 10.0 ns when the flow does not set LB_CLK_NS.
if {![info exists LB_CLK_NS]} {
    set LB_CLK_NS 10.0
}
set LB_CLK_PERIOD [expr {$LB_CLK_NS / $LB_TIME_UNIT_NS}]

# Clock uncertainty (ns): ~5% / ~2% of the default period (jitter + skew)
set LB_SETUP_MARGIN 0.50
set LB_HOLD_MARGIN  0.20

# External output load / max capacitance (pf): FO4 = 4 x inv_1 Cin (0.002302)
set LB_LOAD 0.009208

# Input transition / slew (ns): ~25% of default_max_transition (1.5 ns)
set LB_SLEW 0.375
