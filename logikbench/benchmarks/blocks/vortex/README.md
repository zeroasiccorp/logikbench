# Summary

A single core of the Vortex RISC-V GPGPU (`VX_core`), configured as RV32IMF
with 4 warps and 4 threads (Vortex's default config; no graphics, tensor, or
vector extensions, FPU_TYPE=STD). The top module `vortex_core_wrap` is a thin
plain-port wrapper around `VX_core`.

# Source

- author: Vortex team (Georgia Tech)
- repo: https://github.com/vortexgpgpu/vortex
- tag: v3.0
- commit: e6fcb7d2cf45c8eea6076ff382d210c88b0eddf6

# License

Apache-2.0 (see `LICENSE`).

# Verilog Generation

Vortex's RTL is SystemVerilog (packages, parameterized interfaces, hierarchical
`$bits`) written for an `sv2v` -> yosys flow; it does not elaborate directly
through slang. The single flattened `rtl/vortex.v` was generated as follows.

1. Clone and configure (default config, RV32):

```
git clone -b v3.0 https://github.com/vortexgpgpu/vortex.git
cd vortex
./configure --xlen=32          # generates hw/VX_config.vh etc.
```

2. `VX_core` exposes SystemVerilog interface ports, which cannot be a synthesis
   top (sv2v/slang cannot resolve the interface parameters without an
   instantiating parent). A thin wrapper, `vortex_core_wrap`, declares the
   interfaces active in the default config and connects them to `VX_core`:

```systemverilog
`include "VX_define.vh"
module vortex_core_wrap import VX_gpu_pkg::*; (
    input wire clk, input wire reset, output wire busy
);
    VX_dcr_bus_if  dcr_bus_if();
    VX_mem_bus_if #(.DATA_SIZE(DCACHE_WORD_SIZE), .TAG_WIDTH(DCACHE_TAG_WIDTH))
                   dcache_bus_if[DCACHE_NUM_REQS]();
    VX_mem_bus_if #(.DATA_SIZE(ICACHE_WORD_SIZE), .TAG_WIDTH(ICACHE_TAG_WIDTH))
                   icache_bus_if();
    VX_kmu_bus_if  kmu_bus_if();
    VX_gbar_bus_if gbar_bus_if();
    VX_core core (.clk, .reset, .dcr_bus_if, .dcache_bus_if, .icache_bus_if,
                  .kmu_bus_if, .gbar_bus_if, .busy);
endmodule
```

3. Flatten the `VX_core` hierarchy (RTL reachable from `VX_core`: the `core`,
   `cache`, `mem`, `libs`, `interfaces`, `fpu` directories plus `VX_gpu_pkg` /
   `VX_trace_pkg`) together with the wrapper using `sv2v`, which resolves the
   interfaces and packages into plain Verilog:

```
sv2v -I include -D SYNTHESIS --top=vortex_core_wrap \
     <VX_gpu_pkg.sv VX_trace_pkg.sv vortex_core_wrap.sv core/*.sv cache/*.sv \
      mem/*.sv libs/*.sv interfaces/*.sv fpu/*.sv> \
     -w rtl/vortex.v
```

The XLEN seed (`VX_CFG_XLEN=32`, `VX_CFG_XLEN_32`) is normally a configure-time
`-D`; for reproducibility it is also baked into the bundled `VX_config.vh`
before flattening.

# Modifications

After `sv2v` flattening, three call sites in `rtl/vortex.v` were inlined to
satisfy slang. `sv2v` emits Vortex's package helper functions
(`wid_to_isw`, `wid_to_wis`, `wis_to_wid`) inside generate blocks; slang
forbids calling a generate-block-local function in a constant expression. Each
of the three constant-context calls was replaced by the function body that
`sv2v` had already specialized for this config (no behavior change):

- `wid_to_isw(i)` -> `0`
- `wid_to_wis(i)` -> `i >> VX_CFG... ISSUE_ISW_BITS`
- `wis_to_wid(w, issue_id)` used as an index -> `w` (the function returns its
  first argument as the unsigned warp id)
