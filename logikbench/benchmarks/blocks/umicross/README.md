# Summary

UMI crossbar (`umi_crossbar`) from Zero ASIC's UMI library, configured as an
8x8 crossbar with a narrow (64-bit) UMI link.

# Source

- repo: https://github.com/zeroasiccorp/umi (PyPI package `umi`)
- module: `umi.sumi.Crossbar` (topmodule `umi_crossbar`)

The umi RTL is vendored in `rtl/` (`umi_crossbar`, `umi_arbiter`, plus the
`umi_messages.vh` header), copied from the `umi` pip package (version 0.4.15).
`Vmux` (lambdalib) remains a dependency -- it is a mux-shim library, not
benchmark RTL. Logic is unchanged; configured via the parameters below.

# Parameters (overridden in umicross.py)

- `N`  = 8   (UMI ports; 8x8 crossbar)
- `DW` = 64  (data width)
- `AW` = 64  (address width)
- `CW` = 32  (command width)
