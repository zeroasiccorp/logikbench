# Summary

UMI endpoint (`umi_endpoint`) from Zero ASIC's UMI library, configured as a
FULL, registered endpoint with a narrow (64-bit) UMI link.

# Source

- repo: https://github.com/zeroasiccorp/umi (PyPI package `umi`)
- module: `umi.sumi.Endpoint` (topmodule `umi_endpoint`)

No RTL is vendored: the source is referenced from the installed `umi` pip
package (resolved at import). The Decode/Pack/Unpack dependency filesets are
pulled from the umi package.

# Parameters (overridden in umidev.py)

- `TYPE` = "FULL"  (full endpoint)
- `REG`  = 1       (register on read data)
- `DW`   = 64      (data width)
- `AW`   = 64      (address width)
- `CW`   = 32      (command width)
