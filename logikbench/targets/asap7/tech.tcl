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

# Liberty time unit for this PDK, in nanoseconds (ASAP7 time = 1 ps).
set LB_TIME_UNIT_NS 0.001

# Default clock period (ns). 0.2 ns = 200 ps = 5 GHz: tighter than any block's
# critical path here, so STA slack is negative and the mapper actively optimizes
# toward max fmax instead of stopping early.
if {![info exists LB_CLK_NS]} {
    set LB_CLK_NS 0.2
}
set LB_CLK_PERIOD [expr {$LB_CLK_NS / $LB_TIME_UNIT_NS}]

# Clock uncertainty (ps): ~5% / ~2% of the default period (jitter + skew)
set LB_SETUP_MARGIN 25.0
set LB_HOLD_MARGIN  10.0

# External output load/max capacitance (fF): FO4 = 4 x INVx1 input cap (0.68 fF)
set LB_LOAD 2.7

# Input driver cell + its output pin for set_driving_cell (models input drive
# with a real library buffer; the same driver_cell abc maps against).
set LB_DRIVER BUFx2_ASAP7_75t_R
set LB_DRIVER_PIN Y
