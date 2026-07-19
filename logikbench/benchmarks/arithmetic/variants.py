"""Shared parameter sweeps for the arithmetic benchmark group."""

# Default data-width sweep for arithmetic blocks: representative real hardware
# widths rather than every integer. INT4/INT8 (ML), 10/12/14 (ADC/DAC), 16/32/64
# (int and fp totals), 18 (DSP48), 24 (audio/DSP), 40/48 (accumulators, Ethernet
# MAC, physical address), 53 (fp64 mantissa, 52+1). Capped at 64: a 128-bit
# divider is a synthesis bomb, and 64 is the realistic scalar-datapath ceiling.
ARITH_DW = [4, 6, 8, 10, 11, 12, 14, 16, 18, 20, 22, 24, 32, 40, 48, 53, 56, 64]

# Element/lane count for reduction blocks (N inputs), powers of two.
ARITH_N = [2, 4, 8, 16, 32, 64]

# Coarse width for 2-D (N x DW) sweeps, to keep the cross product tractable.
ARITH_DW_2D = [8, 16, 32, 64]

# Widths for fixed-point blocks whose default fractional width QW = 8 requires
# DW > QW (and for CONST-bearing blocks that need >= ~16 bits).
ARITH_DW_FIXEDPT = [w for w in ARITH_DW if w >= 16]
