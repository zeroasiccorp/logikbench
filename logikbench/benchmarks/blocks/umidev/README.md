# Summary

UMI endpoint (`umi_endpoint`) from Zero ASIC's UMI library, configured as a
FULL, registered endpoint with a narrow (64-bit) UMI link.

# Source

- repo: https://github.com/zeroasiccorp/umi (PyPI package `umi`)
- module: `umi.sumi.Endpoint` (topmodule `umi_endpoint`)

The RTL is vendored in `rtl/` (`umi_endpoint`, `umi_decode`, `umi_pack`,
`umi_unpack`, plus the `umi_messages.vh` header), copied from the `umi` pip
package (version 0.4.15). Logic is unchanged; the endpoint is configured via
the parameters below.

# Parameters (overridden in umidev.py)

- `TYPE` = "FULL"  (full endpoint)
- `REG`  = 1       (register on read data)
- `DW`   = 64      (data width)
- `AW`   = 64      (address width)
- `CW`   = 32      (command width)
