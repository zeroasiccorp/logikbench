###############################################################################
# Technology Settings
#
# File: logikbench/targets/asic/freepdk45/tech.tcl
###############################################################################
#
# Per-technology LogikBench timing constants, expressed in this PDK's liberty
# units. FreePDK45 / Nangate45 liberty units: time = 1 ns, capacitance = 1 fF.
# These are consumed by the generic command body (default.sdc) after a
# benchmark SDC defines its signal lists.
#
###############################################################################

# Clock period (ns). Default here; the flow may override it (e.g. lb --clk) by
# setting LB_CLK_PERIOD before this file is sourced.
if {![info exists LB_CLK_PERIOD]} {
    set LB_CLK_PERIOD 2.0
}

# Clock uncertainty (ns): ~5% / ~2% of the default period (jitter + skew)
set LB_SETUP_MARGIN 0.10
set LB_HOLD_MARGIN  0.04

# External output load / max capacitance (fF): FO4 = 4 x INV_X1 input cap (1.70 fF)
set LB_LOAD 6.8

# Input transition / slew (ns): ~25% of default_max_transition (0.199 ns)
set LB_SLEW 0.05
