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

# Liberty time unit for this PDK in ns
set LB_TIME_UNIT_NS 1.0

# Default clock period.
if {![info exists LB_CLK_NS]} {
    set LB_CLK_NS 0.5
}

set LB_CLK_PERIOD [expr {$LB_CLK_NS / $LB_TIME_UNIT_NS}]

# Clock uncertainty (ns): ~5% / ~2% of the default period (jitter + skew)
set LB_SETUP_MARGIN 0.50
set LB_HOLD_MARGIN  0.20

# External output load / max capacitance (pf): FO4 = 4 x inv_1 Cin (0.002302)
set LB_LOAD 0.009208

# Input driver cell + its output pin for set_driving_cell (models input drive
# with a real library buffer; the same driver_cell abc maps against).
set LB_DRIVER sky130_fd_sc_hd__buf_4
set LB_DRIVER_PIN X
