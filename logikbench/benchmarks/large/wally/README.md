CORE-V Wally RISC-V core
============================================

## Description

**Source:** [rtl/](rtl/)

Core-V Wally (CVW) is the OpenHW Group configurable RISC-V processor from Harris
& Harris, "RISC-V System-on-Chip Design." The vendored top is
`wallypipelinedcorewrapper`, a thin wrapper around `wallypipelinedcore` that
pins the configuration and exposes a plain `clk`/`reset` plus an AHB bus
interface and CLINT/PLIC interrupt inputs.

The configuration (selected by `include/config.vh`) is a full-featured RV64
core: M/A/F/D/C plus bitmanip (B) and crypto (K), an MMU with TLBs, L1
instruction/data caches, and a branch predictor.

## Parameters

- n/a (fixed configuration; set by `include/config.vh`)

## Original Sources

- author: OpenHW Group / D. Harris, S. Harris
- repo: https://github.com/openhwgroup/cvw
- commit: e0af0e68a32edd8eb98abc31c8b2b7b04fbd29b9 (submodules off)

## License

- Apache-2.0 (see LICENSE file for details)

## Modifications

The circuit logic is the upstream CVW RTL, unchanged. The changes are packaging
only, to make the benchmark self-contained:

1. **RTL vendored in-repo.** Previously the ~225 `src/**` SystemVerilog files
   and the `config/shared` include headers were fetched at build time from
   `github.com/openhwgroup/cvw` via a SiliconCompiler git dataroot. They are now
   copied into the repo and **flattened into `rtl/`** (basenames are unique, so
   no `src/` subtree is needed); `wally.f` lists the exact file set and order.
2. **Top wrapper.** `rtl/wallypipelinedcorewrapper.sv` (local) instantiates
   `wallypipelinedcore` at the pinned config, providing a self-contained
   synthesis top.
3. **SRAM shim.** `rtl/lambda.v` maps CVW's generic memory modules to lambdalib
   `la_spram` (attached via the `Spram` depfileset), so RAMs infer as BRAM on
   FPGA and map to real SRAM macros on ASIC -- the same pattern used by the
   koios / coralnpu benchmarks.
