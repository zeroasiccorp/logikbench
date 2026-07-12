Nvidia Deep Learning Accelerator (NVDLA) -- Full Precision
==========================================================

## Description

**Source:** [rtl/](rtl/)

The NVIDIA Deep Learning Accelerator (NVDLA) is a free and open architecture
for deep learning inference accelerators. This benchmark is the **full
precision** NVDLA v1.0 release (top module `NV_nvdla`) -- the large
counterpart to the [nvdlasmall](../nvdlasmall/README.md) (nv_small) benchmark.

http://nvdla.org/

## Parameters

This is the fixed **nv_full** configuration (NVDLA v1.0):

- 2048 INT8 MACs (1024 INT16 / FP16); C atomic = 64, K atomic = 32
- Datapath: INT8 / INT16 / FP16
- CBUF: 16 banks x 512 x 64 bytes
- All features enabled: SDP (BS/BN/EW + LUT), PDP, CDP, RUBIK, BDMA, and the
  secondary memory interface (SRAMIF)
- No Synopsys DesignWare cells (NVDLA behavioral cells used instead)

## RTL Sources

- author: Nvidia
- repo: https://github.com/nvdla/hw
- branch: nvdlav1
- commit: 8e06b1b9d85aab65b40d43d08eec5ea4681ff715

## License

- NVIDIA Open NVDLA License and Agreement v1.0 (see `LICENSE`)

## Verilog Generation

Unlike `nvdlasmall` -- whose spec-templated `nv_small` branch must be run
through NVDLA's cpp/perl/java `tmake` code generation -- the `nvdlav1` branch
is the **static, pre-resolved full-precision release**: the configuration is
already baked into checked-in RTL. The synthesizable tree is therefore vendored
directly, with no code-generation toolchain:

```
git clone -b nvdlav1 https://github.com/nvdla/hw.git
# copy the synthesizable collateral (drop plugins/, sim-only):
cp -r hw/vmod/nvdla/.  <block>/rtl/
cp    hw/vmod/include/*.vh  <block>/include/
cp    hw/vmod/vlibs/*.v     <block>/vlibs/
cp -r hw/vmod/rams/synth/.  <block>/rams/synth/   # nv_ram_* wrappers
cp -r hw/vmod/rams/model/.  <block>/rams/model/   # RAMDP_*/RAMPDP_* primitives
cp    hw/LICENSE            <block>/LICENSE
```

`rams/synth` holds the `nv_ram_*` wrappers; `rams/model` holds the behavioral
RAM primitives (`RAMDP_*`/`RAMPDP_*`) those wrappers instantiate. Both layers
are kept so the design is self-contained with no foundry RAM macros.

## Lint and Synthesis Configuration

`nvdlafull.py` sets the NVDLA code-generation guard defines so the design both
lints and synthesizes cleanly (same as `nvdlasmall`, plus one more):

- `SYNTHESIS` -- drop simulation-only code
- `VERILINT` -- exclude assertion instances (guarded by `` `ifdef VERILINT ``)
- `NO_PLI_OR_EMU` -- exclude PLI/emulation hierarchical `defparam`s
- `DESIGNWARE_NOEXIST` -- select the behavioral `vlibs` cells (`NV_DW02_tree`,
  the `HLS_fp*` floating-point units, ...) instead of the Synopsys DesignWare
  cells we do not have. This is the key difference from `nvdlasmall`, whose
  DesignWare choice was baked in at `tmake` time.

Plus `` `include `` search via `+incdir+ include`. All plain `+define+` /
`+incdir+`, so the exported `nvdlafull.f` works directly with slang, yosys and
verilator.

## Modifications

The `nvdlav1` vmod is almost directly consumable; three minimal adjustments
were needed to lint/synthesize the standalone tree (none change behavior):

- **Timescale removed** from the 59 files that declared `` `timescale `` (57
  RAM models + 2 vlibs). Mixing timescaled and non-timescaled files makes slang
  reject the design ("does not have a time scale defined but others do");
  stripping the directive leaves the design consistently timescale-free, as in
  `nvdlasmall`.
- **`rtl/top/NV_NVDLA_partition_o.v`**: this lone file still carried C-preprocessor
  feature guards (`#ifdef NVDLA_{BDMA,RUBIK,PDP,CDP}_ENABLE` / `#else` / `#endif`)
  that NVDLA's build resolves with `cpp`. They were resolved to the
  **enabled** branch (all four are present in full precision) and the `#else`
  stubs dropped.
- **Sync cells** `vlibs/p_SSYNC3DO{,_C_PPP,_S_PPP}.v`: each of these three
  clock-domain-crossing synchronizers is a chain of three flip-flops
  (`d -> d0 -> d1 -> q`). The raw `nvdlav1` versions additionally instantiate a
  zero-port, no-logic module `first_stage_of_sync` -- a hierarchy "marker" that
  only exists so sim/CDC tools can annotate the first synchronizer stage (the
  target of the `defparam sync_0.first_stage_of_sync.mode` lines in the RTL).
  That marker module is defined identically in all three files, so compiling
  them together is a duplicate-definition error. They were replaced with the
  plain versions from `nvdlasmall` -- the same three-flop synchronizers with
  identical ports, minus the empty marker module -- which is exactly what
  NVDLA's `tmake` build emits for the small tree. The marker carries no
  hardware, so nothing in lint or synthesis changes.

## How to Cite

NVDLA is an open hardware project from NVIDIA; there is no single reference
paper. Cite the project:

```
NVIDIA Deep Learning Accelerator (NVDLA), NVIDIA Corporation.
http://nvdla.org/  --  https://github.com/nvdla/hw
```
