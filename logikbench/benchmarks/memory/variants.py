"""Shared parameter sweeps for the memory benchmark group."""

# Data-bus widths for memories: real widths, powers of two, up to a 512-bit
# cache line.
MEMORY_DW = [8, 16, 32, 64, 128, 256, 512]

# Address widths (DEPTH = 2**AW): 16 to 16K entries.
#
# NOTE: these declare the real memory design space. The open flow has no SRAM
# macro, so memories infer flip-flops and the large/deep corners are not
# synthesizable in practice (they need a hardened SRAM macro); characterization
# there is expected to time out and skip those points, not treat them as errors.
MEMORY_AW = [4, 6, 8, 10, 12, 14]

# Lower ceiling for blocks with a hard ELABORATION limit (not just synthesis
# cost): init-loop ROMs (initial block unrolls 2**AW assignments) and CAMs (a
# comparator per entry). These choke above AW=10.
MEMORY_AW_SMALL = [4, 6, 8, 10]
