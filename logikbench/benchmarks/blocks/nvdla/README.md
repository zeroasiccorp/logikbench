Nvidia Deep Learning Accelerator (NVDLA)
============================================

## Description

**Source:** [rtl/](rtl/)

The NVIDIA Deep Learning Accelerator (NVDLA) is a free and open architecture
that promotes a standard way to design deep learning inference accelerators.
With its modular architecture, NVDLA is scalable, highly configurable, and
designed to simplify integration and portability.

http://nvdla.org/

## Parameters

This benchmark is the **nv_small** configuration (top module `NV_nvdla`):

- INT8 datapath (`NVDLA_FEATURE_DATA_TYPE_INT8`)
- 8x8 MAC atomic (`NVDLA_MAC_ATOMIC_C_SIZE = NVDLA_MAC_ATOMIC_K_SIZE = 8`)
- CBUF: 32 banks x 512 x 8 bytes
- SDP BS/BN enabled, PDP and CDP enabled
- No DesignWare cells (behavioral implementations used)

## RTL Sources

- author: Nvidia
- repo: https://github.com/nvdla/hw
- branch: nv_small
- commit: 771f20cc9e69759d7277978eb41e8d47f1547374

## License

- NVIDIA Open NVDLA License and Agreement v1.0 (see `LICENSE`)

## Verilog Generation

NVDLA RTL is not checked in directly upstream; the synthesizable Verilog is
produced by NVDLA's own tree build (cpp + perl + java code generation). The
tree under `rtl/`, `vlibs/`, `rams/`, and `include/` was generated as follows.

Prerequisites: `perl` (with the `YAML` and `XML::Simple` modules), `java`,
`cpp`, `gcc`. On a stock perl the two modules can be installed locally with:

```
cpan -T -f YAML
cpan -T -f XML::Simple
```

Generation steps (run in a clone of the repo):

```
git clone -b nv_small https://github.com/nvdla/hw.git
cd hw

# Create tree.make non-interactively, pointing at the local toolchain
make USE_VM_ENV=1 \
     VM_CPP=$(command -v cpp)  VM_GCC=$(command -v gcc) \
     VM_CXX=$(command -v g++)  VM_PERL=$(command -v perl) \
     VM_JAVA=$(command -v java) VM_PYTHON=$(command -v python3) \
     VM_PROJ=nv_small

# We do not have DesignWare; use NVDLA's behavioral cells instead
sed -i 's/USE_DESIGNWARE      := 1/USE_DESIGNWARE      := 0/' tree.make

# Generate the flat RTL into outdir/nv_small/vmod
./tools/bin/tmake -build vmod
```

The generated tree was then copied into this block:

```
GEN=outdir/nv_small/vmod
cp -r $GEN/nvdla/.                  <block>/rtl/
cp    $GEN/include/*.vh             <block>/include/
cp    outdir/nv_small/spec/defs/project.vh \
                                   <block>/include/nvdla_config.vh
cp    $GEN/vlibs/*.v               <block>/vlibs/
cp    $GEN/rams/fpga/small_rams/*.v <block>/rams/fpga/small_rams/
```

Finally, files for modules not reachable from `NV_nvdla` in the nv_small
configuration were pruned (unused DesignWare/FP cells, unused RAM sizes, and
disabled-feature stubs such as the SDP "Y" activation path and rubik). This
removed 124 of the 373 generated files, leaving the set in this directory.

## Lint and Synthesis Configuration

`nvdla.py` sets the NVDLA code-generation guard defines so the design both
lints and synthesizes cleanly:

- Defines `SYNTHESIS`, `VERILINT`, `NO_PLI_OR_EMU` exclude simulation-only
  code: assertion instances (guarded by `` `ifdef VERILINT ``) and PLI/emulation
  hierarchical `defparam`s (guarded by `` `ifndef NO_PLI_OR_EMU ``).

These are plain `+define+` / `+incdir+` settings, so the exported fileset
(`nvdla.f`) works directly with slang, yosys, and verilator without any
tool-specific command file.

NVDLA is the first benchmark that relies on a separate include directory
(`include/`) AND on `` `define `` macros at synthesis time. The shared yosys flow
(`logikbench/tools/yosys/scripts/synthesis.tcl`) was updated to forward each
fileset's include directories (`-I`) and defines (`-D`) to `read_slang`; the
lint flow already passed these automatically, but the raw `read_slang` call in
the synthesis flow did not. The change is additive (benchmarks with no idirs or
defines are unaffected) and also benefits other include-using designs such as
`wally`.

## Modifications

- `rtl/cdp/NV_NVDLA_CDP_DP_bufferin.v`: widened the `buffer_data` register
  declaration. NVDLA's nv_small generation packs `buffer_pd` by reading
  `buffer_data[81-1+4*9:4*9]`, an offset/width carried over from a wider
  configuration that overruns the 28-bit data this register actually holds.
  The register is widened so the select is in bounds; the unassigned upper
  bits are 0, identical to what synthesis produces for the original
  out-of-bounds read. This keeps the design synthesizable and lint-clean
  without suppressing the diagnostic.
- `vlibs/oneHotClk_async_read_clock.v`, `vlibs/oneHotClk_async_write_clock.v`:
  removed the lone `` `timescale 1ps/1ps `` directive from each. These were the
  only two files in the design that declared a timescale, which made slang
  reject the mix ("design element does not have a time scale defined but others
  in the design do"). Removing them leaves the design timescale-free and
  consistent, with no command-line workaround needed.
- No other changes to the generated RTL; see the generation/pruning steps above.
