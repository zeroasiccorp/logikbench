"""Shared parameter sweeps for the basic (logic primitive) benchmark group."""

# Bus widths for logic primitives: powers of two. Starts at 2 because a 1-bit
# reduction/encoder degenerates to a bare wire (zero cells, which the STA flow
# rejects). These blocks are linear-cost, so wide buses are cheap.
BASIC_DW = [2, 4, 8, 16, 32, 64, 128, 256]

# Port / input / requester counts (mux ways, crossbar ports, arbiter requesters).
BASIC_N = [2, 4, 8, 16, 32, 64]

# Coarse width for 2-D (N x DW) sweeps. Keeps DW=1 (a 1-bit N-way mux/crossbar
# is real logic, not a wire) and stays coarse to bound the cross product.
BASIC_DW_2D = [1, 8, 32, 128]
