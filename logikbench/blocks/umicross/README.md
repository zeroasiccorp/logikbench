# Summary

UMI crossbar (`umi_crossbar`) from Zero ASIC's UMI library, configured as an
8x8 crossbar with a narrow (64-bit) UMI link.

# Source

- repo: https://github.com/zeroasiccorp/umi (PyPI package `umi`)
- module: `umi.sumi.Crossbar` (topmodule `umi_crossbar`)

No RTL is vendored: the source is referenced from the installed `umi` pip
package (resolved at import). The Vmux (lambdalib) and umi Arbiter dependency
filesets are pulled from their packages.

# Parameters (overridden in umicross.py)

- `N`  = 8   (UMI ports; 8x8 crossbar)
- `DW` = 64  (data width)
- `AW` = 64  (address width)
- `CW` = 32  (command width)
