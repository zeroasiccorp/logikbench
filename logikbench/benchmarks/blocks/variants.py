"""Shared parameter sweeps for the blocks (application/IP) benchmark group."""

# Data-bus widths for application blocks (DSP, image, interconnect): powers of
# two, capped at 64 (several of these contain multipliers).
BLOCKS_DW = [8, 16, 32, 64]

# Datapath widths for byte-oriented blocks (multiple of 8).
BLOCKS_W = [8, 16, 32, 64]

# Element / lane / port counts.
BLOCKS_N = [2, 4, 8, 16, 32]

# Native data widths for UMI / interconnect blocks (natively wide; DW below ~32
# is not a legal configuration).
BLOCKS_DW_UMI = [32, 64, 128, 256]
