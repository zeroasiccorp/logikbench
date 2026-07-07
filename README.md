<p align="center">
  <img src="docs/logikbench-readme-header.png" alt="LogikBench" />
</p>

[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Python Version](https://img.shields.io/badge/python-3.10+-blue.svg)](https://www.python.org/downloads/)
[![PyPI](https://img.shields.io/pypi/v/logikbench.svg)](https://pypi.org/project/logikbench/)
[![Lint](https://github.com/zeroasiccorp/logikbench/actions/workflows/lint.yml/badge.svg)](https://github.com/zeroasiccorp/logikbench/actions/workflows/lint.yml)
[![Downloads](https://static.pepy.tech/badge/logikbench)](https://pepy.tech/project/logikbench)

## Why LogikBench

LogikBench is a high quality curated open source RTL benchmark suite that enables reproducible evaluation of EDA tools, process technologies, architectures, and LLMs.


🏆 [Live results dashboard](https://zeroasiccorp.github.io/logikbench)


> "Sunlight is said to be the best of disinfectants." --Supreme Court Justice Louis Brandeis

| Problem Addressed     | LogikBench Solution                      |
|-----------------------|------------------------------------------|
| No "Spec CPU for RTL" | 209 standardized benchmark circuits      |
| Lack of diversity     | Broad range of circuits and code origins |
| Hard coded values     | Extensive per circuit parametrization    |
| Lack of trust         | Documented source code provenance        |
| Reproducibility       | 100% push button automation              |
| Lack of portability   | Tech agnostic RTL+lambdalib benchmarks   |
| License uncertainty   | 100% clear permissive license            |

LogikBench includes the following benchmark types:

| Benchmark type               | Groups (-g)               |
|------------------------------|---------------------------|
| Micro-benchmarks             | basic, arithmetic         |
| Legacy synthetic bencharmks  | epfl, isca85, isca89      |
| Very large and real circuits | blocks                    |

----

## Quick Start

```bash
# 1. Install LogikBench (pure Python, from PyPI)
pip install logikbench

# 2. Install the EDA tools it drives (Yosys + FPGA synthesis plugins)
sc-install -group fpga

# 3. Synthesize your first benchmark on an FPGA target
lb run -n mux -t xilinx_virtex7

# 4. Run a whole group, then collect its metrics into one JSON
lb run -g basic -t xilinx_virtex7
lb collect -g basic -t xilinx_virtex7
```

`lb -h`, `lb run -h`, and `lb collect -h` list every option. Picking a
benchmark is optional: with neither `-g` nor `-n`, `lb run` sweeps all groups.
For ASIC area/FMAX metrics, install `sc-install -group asic` and use an ASIC
target such as `yosys_freepdk45`. See [Tool Installation](#tool-installation)
for the full tool prerequisites.

----

## Benchmark Architecture

Each LogikBench benchmark circuit consists of:
* **Tech-agnostic RTL Verilog files** for broad tool compatibility
* **SiliconCompiler Design object** with metadata and configuration

The SiliconCompiler Design object captures benchmark data as files, parameters, topmodule name, and other settings grouped as a `fileset`. Every circuit in the LogikBench suite has a Python class that inherits from SiliconCompiler's Design class, as shown in this [`mux`](logikbench/benchmarks/basic/mux/mux.py) example:

```python
from os.path import dirname, abspath
from siliconcompiler import Design

class Mux(Design):
    def __init__(self):
        name = 'mux'
        fileset = 'rtl'
        rootname = f'{name}_root'
        super().__init__(name)
        self.set_dataroot(rootname, dirname(abspath(__file__)))
        self.add_file(f'rtl/{name}.v', fileset, dataroot=rootname)
        self.set_topmodule(name, fileset)
```

To use a benchmark circuit, simply instantiate its class. You then have access to all methods inherited from SiliconCompiler. The example below shows how to instantiate the `Mux` circuit and write out its RTL settings in a standard filelist format that can be read directly by tools like Icarus Verilog, Verilator, and slang.

```python
import logikbench as lb
d = lb.basic.Mux()
d.write_fileset('mux.f', fileset='rtl')
```

### AI Provenance (`ai.json`)

Some LogikBench blocks are AI-generated (RTL authored with the help of a large
language model under human direction). Any such block carries an `ai.json` file
in its directory (e.g. [`ai.json`](logikbench/benchmarks/blocks/lz77/ai.json))
that records its provenance so the origin of the design is transparent and
auditable. Blocks that are hand-written or vendored/imported from an external
source do not carry an `ai.json`.

The file captures who authored the block, which model generated it and when,
that a human reviewed it, and whether the RTL is an original implementation or
derived from an external source:

```json
{
  "schema_version": "1.0",
  "name": "lz77",
  "spec_ref": "README.md",
  "authorship": "Zero ASIC Corporation; author Andreas Olofsson",
  "generated_by": {
    "model": "claude-opus-4-8",
    "provider": "Anthropic",
    "interface": "Claude Code",
    "date": "2026-06-25"
  },
  "human_review": {
    "reviewed": true,
    "reviewer": "Andreas Olofsson",
    "date": "2026-06-25",
    "notes": "Architecture, scope, and verification were directed and reviewed by the author."
  },
  "origin": {
    "type": "original",
    "notes": "Original implementation written for LogikBench; follows the cited algorithm/standard and hardware architectures, not copied from any specific HDL source."
  }
}
```

| Field | Meaning |
|-------|---------|
| `spec_ref` | The block's specification (its `README.md`) |
| `authorship` | The party accountable for the block |
| `generated_by` | The model / provider / interface and date of generation |
| `human_review` | Whether a human reviewed it, by whom, and their notes |
| `origin` | `original` (written for LogikBench) or a derived/vendored source |

----

## Benchmark Metrics

FPGA runs report three metrics, all extracted from the Yosys synthesis run (no place-and-route): **LUTs**, **logic depth**, and **runtime**.

ASIC runs report three metrics, **Cell Area**, **FMAX**, and **runtime**. Cell
Area comes from the Yosys synthesis run; FMAX is computed by an OpenSTA timing
run on the synthesized netlist. Neither involves place-and-route.


### FPGA LUTs

> NOTE that it is impossible to do a truly fair synthesis comparison between different FPGA architectures because it's an apples to oranges comparison. The approach below is our attempt at normalization. File an issue if you disagree with it.

The LUT count is the synthesized logic-fabric usage, read from Yosys' `stat` per-cell-type report (`num_cells_by_type`). Note that ideally, each target should have a custom post processing function blessed by the vendor to fairly extract their metrics. LUTs include three kinds of cell:

1. **Lookup tables** — the basic LUT primitives, whose names vary by vendor: `LUT1..LUT6`, `$lut`, `SB_LUT4` (ice40), `EFX_LUT4` (efinix), `CC_LUT*` (gatemate), `LUTFF` (fabulous), and `CFG1..CFG4` (microchip PolarFire).

2. **Dedicated mux-fabric cells** — the hardwired wide multiplexers that live in the same logic block as the LUTs and implement muxing a LUT-only fabric would otherwise spend LUTs on: `MUXF7/MUXF8` (xilinx), `mux4x0/mux8x0` (quicklogic), `MUX2_LUT5..8` (gowin), `LUTMUX7/8` (adi), `L6MUX21/PFUMX` (lattice ECP5), `CC_MX4/CC_MX8` (gatemate), `MX4` (microchip).

3. **Hard DSP / multiply / MAC blocks** — dedicated multiplier and multiply-accumulate cells: `DSP48E1` (xilinx), `MULT18X18D` (lattice ECP5), `CC_MULT` (gatemate), `MACC_PA` (microchip), `RBBDSP` (adi), `efpga_mult*` (Zero ASIC). A fabric without them builds multipliers out of LUTs, so a target that uses a hard block would otherwise read as artificially LUT-light. (Carry/ALU cells such as `CARRY4`, `ALU`, `CCU2C`, `ARI1` are *not* DSPs and are not counted.)

Including mux cells keeps the comparison fair: ice40 has no dedicated mux, so its read/select logic is built entirely from LUTs and is fully counted; fabrics like QuickLogic or GateMate offload that same logic to mux cells, which would otherwise make their LUT count read artificially low (e.g. `regfile` on QuickLogic is mostly `mux8x0` cells, not LUTs).

Every fabric cell counts as one, regardless of its capacity: a 6-input LUT (Xilinx, ADI) packs more logic than a 4-input LUT, and a hard mux (e.g. QuickLogic `mux8x0`) does an 8:1 select that a LUT-only fabric would spend several LUTs on — but each is one cell. This makes the metric a clean *logic-cell utilization* count, most directly comparable *within* an architecture family (e.g. the Zero ASIC `z10xx` parts, or two synthesis options on one target). Across vendors the cells differ in size, so cross-vendor LUT counts are informative rather than a strict apples-to-apples ranking — each architecture wins where its cell type fits the design (mux fabrics on mux/select/decode logic, LUT/carry fabrics on arithmetic).

### FPGA Logic depth

Logic depth is the **longest combinational path** through the mapped netlist, measured by Yosys' `ltp -noff` (longest topological path, flip-flops excluded). It is the count of cells on that path, reported uniformly across all targets; the per-vendor ABC mapping reports are inconsistent (some flows print nothing), so `ltp` gives one comparable number. `ltp` only spans a single module, but the vendor `synth_*` flows flatten by default, so it covers the whole design.

Because it counts *cells*, the path includes carry-chain and mux cells, not just LUT levels — so depth, like LUTs, reflects each architecture's primitives.

### ASIC Cell Area

Cell Area is the total standard-cell area of the synthesized (mapped) netlist,
read from the same Yosys `stat` report as the FPGA cell counts. It is the sum of
the areas of every instantiated standard cell, in the area units of the target's
liberty (um^2 for the Nangate45 library used by `freepdk45`). Yosys also reports
the raw **cell count** alongside the area.

This is a *pre-layout* synthesis-area figure: it reflects the logic mapped to the
standard-cell library but not place-and-route effects (buffering, sizing, or
filler), so it tracks logic complexity rather than final silicon area. As with
the FPGA LUT count, it is most directly comparable within one PDK/library.

### ASIC FMAX

FMAX is the maximum operating frequency, computed by an OpenSTA timing run on the
synthesized netlist (`logikbench/tools/opensta/scripts/timing.tcl`). For each
clock STA finds the minimum achievable period (`find_clk_min_period`), and FMAX
is `1 / min_period`, reported in MHz.

The benchmarks ship no constraints, so a generic SDC (generated by
`logikbench/sdc.py`) attaches a clock to a port named `clk` when present, or a
virtual clock for purely combinational designs (so input-to-output paths are
still constrained). The period defaults to 1 ns and is set with `lb run --clk
<ns>`; it is given in nanoseconds and scaled into each PDK's SDC time unit
(`create_clock -period` is read in the unit OpenROAD derives from the liberty --
1 ns for most PDKs, 1 ps for ASAP7 -- so the same `--clk` is the same real
frequency on every target). For the `yosys_<pdk>`/`tardigrade_<pdk>` lbflow path
the period is only a starting reference (FMAX is the minimum achievable period);
for the `sc_<pdk>` asicflow path it is the real optimization target that
place-and-route works to.

### Runtime

Runtime is the wall-clock time of the synthesis step, reported to 0.01 s.

----

## Running Benchmarks

LogikBench includes the `lb` command-line tool for batch processing benchmarks. It drives synthesis through [SiliconCompiler](https://github.com/siliconcompiler/siliconcompiler):
each benchmark is a SiliconCompiler `Design`, and `lb` has two subcommands:

- `lb run` synthesizes the selected benchmarks for one or more targets.
- `lb collect` harvests metrics from existing build results (no synthesis).

Both take the required `-t/--target` plus an optional benchmark selector
(`-g/--group` or `-n/--name`; default: all groups). Run `lb run -h` or
`lb collect -h` for the full option list.

### FPGA Targets

`-t/--target` selects what runs and is required; pass several to sweep them in
turn. FPGA targets are named `<vendor>_<partname>` and map to a Yosys synth
command:

| Target | Synth command |
|--------|---------------|
| `xilinx_virtex7` | `synth_xilinx -family xc7` |
| `quicklogic_polarpro` | `synth_quicklogic -family pp3` |
| `microchip_polarfire` | `synth_microchip -family polarfire` |
| `lattice_ice40` | `synth_ice40` |
| `lattice_ecp5` | `synth_lattice -family ecp5` |
| `gowin_gw5a` | `synth_gowin -family gw5a` |
| `achronix_speedster` | `synth_achronix` |
| `adi_flex16ffc` | `synth_analogdevices -tech t16ffc` |
| `efinix_trion` | `synth_efinix` |
| `fabulous_generic` | `synth_fabulous` |
| `gatemate_cologne` | `synth_gatemate` |
| `zeroasic_z1015` | `synth_fpga -config <arch>` (wildebeest) |
| `zeroasic_z1060` | `synth_fpga -config <arch>` (wildebeest) |

The `zeroasic_*` targets load the [Wildebeest](https://github.com/zeroasiccorp/wildebeest)
plugin and run `synth_fpga -config <arch>`, where `<arch>` is the per-part
architecture config vendored under `logikbench/targets/zeroasic/`.

### ASIC Targets

ASIC targets follow the same `<tool>_<part>` scheme as FPGA targets
(`<vendor>_<partname>`): the tool comes first, the PDK second. Three flavors --
`yosys_<pdk>` and `tardigrade_<pdk>` run the lightweight `lbflow` path (synthesis
+ OpenSTA timing, no place-and-route), and `sc_<pdk>` runs the full
SiliconCompiler `asicflow`:

| Target | PDK / library | Flow |
|--------|---------------|------|
| `yosys_freepdk45` | FreePDK45 / Nangate45 (lambdapdk) | `lbflow`: Yosys synthesis + OpenSTA timing (no place-and-route) |
| `tardigrade_freepdk45` | FreePDK45 | `lbflow` with tardigrade as the synthesis mapper |
| `sc_freepdk45` | FreePDK45 | SiliconCompiler `asicflow` (synth -> floorplan -> place -> cts -> route) |
| `sc_asap7` | ASAP7 7nm | SiliconCompiler `asicflow` |
| `sc_skywater130` | SkyWater 130 | SiliconCompiler `asicflow` |
| `sc_gf180` | GlobalFoundries 180 | SiliconCompiler `asicflow` |
| `sc_ihp130` | IHP SG13G2 130 | SiliconCompiler `asicflow` |

The `yosys_<pdk>` / `tardigrade_<pdk>` targets run the lightweight `lbflow` path
used for the QoR metrics above: the mapper maps to the standard-cell library and
OpenSTA reports FMAX, with no place-and-route. The `sc_<pdk>` targets run the
full official SiliconCompiler `asicflow` (through routing) and are trimmed to a
single library and a single setup corner so each benchmark stays fast; use
`--to synthesis` to stop after synthesis. (`yosys_<pdk>`/`tardigrade_<pdk>`
cover the lambdapdk std-cell PDKs; `sc_<pdk>` additionally offers `sc_interposer`.)

### ASIC Timing Constraints (SDC)

Every ASIC run is timing-constrained automatically. You do not need to write an
SDC per benchmark: the flow generates a small wrapper that injects `--clk` and
the per-PDK knobs, then sources the shared default constraints in
`logikbench/targets/default.sdc`. Applied to every benchmark, it:

- creates one clock per port whose name matches `*clk*`/`*clock*` (so
  multi-clock designs such as `ethmac`, with `rx_clk`/`tx_clk`, are fully
  constrained), all at the `--clk` period;
- creates a single virtual clock for purely combinational benchmarks (no clock
  port), so their input-to-output paths are still timed;
- constrains all data inputs and outputs with input/output delays at 50% of the
  clock period, and applies per-PDK input transition (slew), load capacitance,
  and setup/hold clock uncertainty read from `logikbench/targets/<pdk>/tech.tcl`.

The only number you normally set is `--clk` (the clock period in nanoseconds,
the same value for every PDK; it is scaled into each PDK's native time unit):

```bash
lb run -g basic -t yosys_freepdk45 --clk 2   # constrain every basic benchmark at 2 ns
```

**Customizing a single benchmark.** When a benchmark needs constraints the
defaults cannot express (e.g. a specific clock name, a subset of ports, a false
path), ship an SDC in the block directory and register it in the benchmark's
`.py`. Because `default.sdc` guardbands its defaults, a custom SDC only sets
what it wants to override, then sources the shared file:

```tcl
# logikbench/<group>/<name>/sdc/<name>.sdc
set LB_CLK     [get_ports my_clock]     ;# override clock detection
set LB_INPUTS  [all_inputs]             ;# or a hand-picked subset
set LB_OUTPUTS [all_outputs]
source $LB_DEFAULT_SDC                  ;# tech.tcl + generic constraints
```

Register it in the benchmark class (alongside the `rtl` fileset):

```python
self.add_file(f'sdc/{name}.sdc', 'sdc', dataroot=root)
```

The wrapper then sources your SDC instead of `default.sdc` directly. Any of
`LB_CLK`, `LB_INPUTS`, `LB_OUTPUTS` you leave unset fall back to the guardbanded
defaults; `LB_CLK_NS` (from `--clk`) and `LB_TECH_FILE`/`LB_DEFAULT_SDC` (paths)
are always injected for you.

### Options

Shared by both subcommands:

| Flag | Description |
|------|-------------|
| `-g`, `--group` | Benchmark group(s): `basic`, `memory`, `arithmetic`, `epfl`, `blocks`, `iscas85`, `iscas89` (default: all groups; mutually exclusive with `-n`) |
| `-n`, `--name` | Act only on benchmark(s) with these name(s), searched across all groups (names are globally unique; mutually exclusive with `-g`) |
| `-t`, `--target` | Synthesis target(s) to sweep (required); see the Targets table above |
| `-b` | Build directory root; per-benchmark work goes in `<builddir>/<target>/<name>` (default: `build`) |

`lb run` only:

| Flag | Description |
|------|-------------|
| `-j` | Number of benchmarks to synthesize in parallel across the target x benchmark matrix (default: 1) |
| `--options` | Extra args passed verbatim to the FPGA synth command. Use the `=` form so leading dashes are not parsed as flags: `--options=-abc9` (quote multiple: `--options='-abc9 -nocarry'`) |
| `--clk` | ASIC clock period in nanoseconds for the generic SDC, scaled into each PDK's time unit; ignored for FPGA targets (default: 1.0) |
| `--from` | First flow step to run: `synthesis`, `floorplan`, `place`, `cts`, `route` (default: from the start) |
| `--to` | Last flow step to run (same choices; default: to the end) |
| `--resume` | Skip benchmarks whose build already completed successfully; only synthesize the rest |
| `--timeout` | Per-step wall-clock cap in seconds; a step that exceeds it is killed and marked failed (default: none) |
| `-v`, `--verbose` | Show full SiliconCompiler tool/scheduler logs (quieted by default) |

`lb collect` only:

| Flag | Description |
|------|-------------|
| `-o`, `--output` | Output directory; one aggregated `<target><suffix>.json` is written per target (default: the build dir root, `-b`) |
| `--suffix` | Append to each output filename (`<target><suffix>.json`), so collecting the same target under different configs does not overwrite (e.g. `--suffix _abc9`) |

`lb run` wipes each benchmark's build directory before synthesizing, so runs are
always fresh (no SiliconCompiler build reuse); use `--resume` to skip completed
benchmarks. `lb collect` then writes one JSON file per target.

----

## Examples

Synthesize an FPGA target for a whole group, then collect its metrics:

```bash
lb run -g arithmetic -t xilinx_virtex7
lb collect -g arithmetic -t xilinx_virtex7 -o results
```

Synthesize a single benchmark for a Zero ASIC part (needs the wildebeest plugin):

```bash
lb run -g basic -n mux -t zeroasic_z1015
```

Sweep several FPGA targets at once, 8 benchmarks in parallel:

```bash
lb run -g basic -t xilinx_virtex7 lattice_ice40 gowin_gw5a -j 8
```

Run ASIC synthesis + timing (`lbflow`) on the freepdk45 PDK, then collect:

```bash
lb run -g basic -t yosys_freepdk45
lb collect -g basic -t yosys_freepdk45 -o results
```

Run the asap7 SC asicflow target, synthesis only:

```bash
lb run -g basic -t sc_asap7 --to synthesis
```
----

## Benchmark Inventory

### Basic Logic (26 benchmarks)

| Benchmark | Description | Verilog |
|-----------|-------------|---------|
| arbiter | Fixed-priority arbiter | [arbiter.v](logikbench/benchmarks/basic/arbiter/rtl/arbiter.v) |
| band | AND reduction | [band.v](logikbench/benchmarks/basic/band/rtl/band.v) |
| bin2gray | Binary to Gray code converter | [bin2gray.v](logikbench/benchmarks/basic/bin2gray/rtl/bin2gray.v) |
| bin2prio | Binary to priority encoder | [bin2prio.v](logikbench/benchmarks/basic/bin2prio/rtl/bin2prio.v) |
| binv | Bitwise inverter | [binv.v](logikbench/benchmarks/basic/binv/rtl/binv.v) |
| bnand | NAND reduction | [bnand.v](logikbench/benchmarks/basic/bnand/rtl/bnand.v) |
| bnor | NOR reduction | [bnor.v](logikbench/benchmarks/basic/bnor/rtl/bnor.v) |
| bor | OR reduction | [bor.v](logikbench/benchmarks/basic/bor/rtl/bor.v) |
| bxnor | XNOR reduction | [bxnor.v](logikbench/benchmarks/basic/bxnor/rtl/bxnor.v) |
| bxor | XOR reduction (parity) | [bxor.v](logikbench/benchmarks/basic/bxor/rtl/bxor.v) |
| crossbar | Crossbar switch | [crossbar.v](logikbench/benchmarks/basic/crossbar/rtl/crossbar.v) |
| dffasync | Asynchronous reset flip-flop | [dffasync.v](logikbench/benchmarks/basic/dffasync/rtl/dffasync.v) |
| dffsync | Synchronous reset flip-flop | [dffsync.v](logikbench/benchmarks/basic/dffsync/rtl/dffsync.v) |
| fsm | Parametrized FSM with pseudo-random transitions | [fsm.v](logikbench/benchmarks/basic/fsm/rtl/fsm.v) |
| gray2bin | Gray to binary code converter | [gray2bin.v](logikbench/benchmarks/basic/gray2bin/rtl/gray2bin.v) |
| icg | Gated-clock register | [icg.v](logikbench/benchmarks/basic/icg/rtl/icg.v) |
| latch | Transparent D latch | [latch.v](logikbench/benchmarks/basic/latch/rtl/latch.v) |
| mux | Multiplexer | [mux.v](logikbench/benchmarks/basic/mux/rtl/mux.v) |
| muxcase | Case-based multiplexer | [muxcase.v](logikbench/benchmarks/basic/muxcase/rtl/muxcase.v) |
| muxhot | One-hot multiplexer | [muxhot.v](logikbench/benchmarks/basic/muxhot/rtl/muxhot.v) |
| muxpri | Priority multiplexer | [muxpri.v](logikbench/benchmarks/basic/muxpri/rtl/muxpri.v) |
| onehot | One-hot encoder | [onehot.v](logikbench/benchmarks/basic/onehot/rtl/onehot.v) |
| pipeline | Pipeline register | [pipeline.v](logikbench/benchmarks/basic/pipeline/rtl/pipeline.v) |
| shiftreg | Shift register | [shiftreg.v](logikbench/benchmarks/basic/shiftreg/rtl/shiftreg.v) |
| tff | Toggle flip-flop | [tff.v](logikbench/benchmarks/basic/tff/rtl/tff.v) |
| tmr | Triple-modular-redundancy voter | [tmr.v](logikbench/benchmarks/basic/tmr/rtl/tmr.v) |

### Arithmetic (66 benchmarks)

| Benchmark | Description | Verilog |
|-----------|-------------|---------|
| abs | Absolute value | [abs.v](logikbench/benchmarks/arithmetic/abs/rtl/abs.v) |
| absdiff | Absolute difference | [absdiff.v](logikbench/benchmarks/arithmetic/absdiff/rtl/absdiff.v) |
| absdiffs | Signed absolute difference | [absdiffs.v](logikbench/benchmarks/arithmetic/absdiffs/rtl/absdiffs.v) |
| add | Adder | [add.v](logikbench/benchmarks/arithmetic/add/rtl/add.v) |
| addsub | Adder-subtractor | [addsub.v](logikbench/benchmarks/arithmetic/addsub/rtl/addsub.v) |
| argmax | Index of max over N | [argmax.v](logikbench/benchmarks/arithmetic/argmax/rtl/argmax.v) |
| argmin | Index of min over N | [argmin.v](logikbench/benchmarks/arithmetic/argmin/rtl/argmin.v) |
| atan | Arctangent (CORDIC vectoring) | [atan.v](logikbench/benchmarks/arithmetic/atan/rtl/atan.v) |
| avgn | Average over N (avg pool) | [avgn.v](logikbench/benchmarks/arithmetic/avgn/rtl/avgn.v) |
| clamp | Saturate/clip to [lo,hi] | [clamp.v](logikbench/benchmarks/arithmetic/clamp/rtl/clamp.v) |
| clz | Count leading zeros | [clz.v](logikbench/benchmarks/arithmetic/clz/rtl/clz.v) |
| cmp | Comparator | [cmp.v](logikbench/benchmarks/arithmetic/cmp/rtl/cmp.v) |
| cos | Cosine (CORDIC rotation) | [cos.v](logikbench/benchmarks/arithmetic/cos/rtl/cos.v) |
| counter | Counter | [counter.v](logikbench/benchmarks/arithmetic/counter/rtl/counter.v) |
| csa32 | 3:2 carry-save adder | [csa32.v](logikbench/benchmarks/arithmetic/csa32/rtl/csa32.v) |
| csa42 | 4:2 carry-save adder | [csa42.v](logikbench/benchmarks/arithmetic/csa42/rtl/csa42.v) |
| ctz | Count trailing zeros | [ctz.v](logikbench/benchmarks/arithmetic/ctz/rtl/ctz.v) |
| dec | Decrementer | [dec.v](logikbench/benchmarks/arithmetic/dec/rtl/dec.v) |
| div | Unsigned integer divide (sequential) | [div.v](logikbench/benchmarks/arithmetic/div/rtl/div.v) |
| divs | Signed integer divide (sequential) | [divs.v](logikbench/benchmarks/arithmetic/divs/rtl/divs.v) |
| dotprod | Dot product | [dotprod.v](logikbench/benchmarks/arithmetic/dotprod/rtl/dotprod.v) |
| exp | Exponential (range-reduce + poly) | [exp.v](logikbench/benchmarks/arithmetic/exp/rtl/exp.v) |
| gelu | GELU activation (sigmoid approx) | [gelu.v](logikbench/benchmarks/arithmetic/gelu/rtl/gelu.v) |
| hswish | Hard-swish activation | [hswish.v](logikbench/benchmarks/arithmetic/hswish/rtl/hswish.v) |
| inc | Incrementer | [inc.v](logikbench/benchmarks/arithmetic/inc/rtl/inc.v) |
| ln | Natural logarithm (normalize + poly) | [ln.v](logikbench/benchmarks/arithmetic/ln/rtl/ln.v) |
| log2 | Log base 2 | [log2.v](logikbench/benchmarks/arithmetic/log2/rtl/log2.v) |
| lrelu | Leaky ReLU activation | [lrelu.v](logikbench/benchmarks/arithmetic/lrelu/rtl/lrelu.v) |
| mac | Multiply-accumulate | [mac.v](logikbench/benchmarks/arithmetic/mac/rtl/mac.v) |
| macc | Complex multiply-accumulate | [macc.v](logikbench/benchmarks/arithmetic/macc/rtl/macc.v) |
| macs | Signed multiply-accumulate | [macs.v](logikbench/benchmarks/arithmetic/macs/rtl/macs.v) |
| max | Maximum | [max.v](logikbench/benchmarks/arithmetic/max/rtl/max.v) |
| maxn | Max over N (max pool) | [maxn.v](logikbench/benchmarks/arithmetic/maxn/rtl/maxn.v) |
| min | Minimum | [min.v](logikbench/benchmarks/arithmetic/min/rtl/min.v) |
| mod | Unsigned modulo (sequential) | [mod.v](logikbench/benchmarks/arithmetic/mod/rtl/mod.v) |
| msub | Multiply-subtract | [msub.v](logikbench/benchmarks/arithmetic/msub/rtl/msub.v) |
| mul | Multiplier | [mul.v](logikbench/benchmarks/arithmetic/mul/rtl/mul.v) |
| muladd | Multiply-add | [muladd.v](logikbench/benchmarks/arithmetic/muladd/rtl/muladd.v) |
| muladdc | Complex multiply-add | [muladdc.v](logikbench/benchmarks/arithmetic/muladdc/rtl/muladdc.v) |
| muladds | Signed multiply-add | [muladds.v](logikbench/benchmarks/arithmetic/muladds/rtl/muladds.v) |
| mulc | Complex multiply | [mulc.v](logikbench/benchmarks/arithmetic/mulc/rtl/mulc.v) |
| mulreg | Registered multiplier | [mulreg.v](logikbench/benchmarks/arithmetic/mulreg/rtl/mulreg.v) |
| muls | Signed multiplier | [muls.v](logikbench/benchmarks/arithmetic/muls/rtl/muls.v) |
| mulsu | Signed x unsigned multiplier | [mulsu.v](logikbench/benchmarks/arithmetic/mulsu/rtl/mulsu.v) |
| multconst | Constant-coefficient multiplier | [multconst.v](logikbench/benchmarks/arithmetic/multconst/rtl/multconst.v) |
| popcount | Population count (set bits) | [popcount.v](logikbench/benchmarks/arithmetic/popcount/rtl/popcount.v) |
| premul | Pre-adder multiply (a+d)*b | [premul.v](logikbench/benchmarks/arithmetic/premul/rtl/premul.v) |
| recip | Fixed-point reciprocal 1/x (sequential) | [recip.v](logikbench/benchmarks/arithmetic/recip/rtl/recip.v) |
| relu | ReLU activation function | [relu.v](logikbench/benchmarks/arithmetic/relu/rtl/relu.v) |
| requant | Requantize (mul-shift-round-saturate) | [requant.v](logikbench/benchmarks/arithmetic/requant/rtl/requant.v) |
| rotl | Rotate left (barrel) | [rotl.v](logikbench/benchmarks/arithmetic/rotl/rtl/rotl.v) |
| rotr | Rotate right (barrel) | [rotr.v](logikbench/benchmarks/arithmetic/rotr/rtl/rotr.v) |
| round | Rounder | [round.v](logikbench/benchmarks/arithmetic/round/rtl/round.v) |
| rsqrt | Fixed-point inverse sqrt (sequential) | [rsqrt.v](logikbench/benchmarks/arithmetic/rsqrt/rtl/rsqrt.v) |
| shiftar | Arithmetic right shift | [shiftar.v](logikbench/benchmarks/arithmetic/shiftar/rtl/shiftar.v) |
| shiftb | Barrel shifter | [shiftb.v](logikbench/benchmarks/arithmetic/shiftb/rtl/shiftb.v) |
| shiftl | Left shift | [shiftl.v](logikbench/benchmarks/arithmetic/shiftl/rtl/shiftl.v) |
| shiftr | Right shift | [shiftr.v](logikbench/benchmarks/arithmetic/shiftr/rtl/shiftr.v) |
| sigmoid | Sigmoid activation (PLAN PWL) | [sigmoid.v](logikbench/benchmarks/arithmetic/sigmoid/rtl/sigmoid.v) |
| simdmul | Packed SIMD multiply | [simdmul.v](logikbench/benchmarks/arithmetic/simdmul/rtl/simdmul.v) |
| sine | Sine function | [sine.v](logikbench/benchmarks/arithmetic/sine/rtl/sine.v) |
| sqdiff | Squared difference | [sqdiff.v](logikbench/benchmarks/arithmetic/sqdiff/rtl/sqdiff.v) |
| sqrt | Square root | [sqrt.v](logikbench/benchmarks/arithmetic/sqrt/rtl/sqrt.v) |
| sub | Subtractor | [sub.v](logikbench/benchmarks/arithmetic/sub/rtl/sub.v) |
| sum | Summation tree | [sum.v](logikbench/benchmarks/arithmetic/sum/rtl/sum.v) |
| tanh | Tanh activation (PLAN PWL) | [tanh.v](logikbench/benchmarks/arithmetic/tanh/rtl/tanh.v) |

### Memory (17 benchmarks)

| Benchmark | Description | Verilog |
|-----------|-------------|---------|
| cache | Cache memory | [cache.v](logikbench/benchmarks/memory/cache/rtl/cache.v) |
| cam | Content-addressable memory | [cam.v](logikbench/benchmarks/memory/cam/rtl/cam.v) |
| fifoasync | Asynchronous FIFO | [fifoasync.v](logikbench/benchmarks/memory/fifoasync/rtl/fifoasync.v) |
| fifosync | Synchronous FIFO | [fifosync.v](logikbench/benchmarks/memory/fifosync/rtl/fifosync.v) |
| ramasync | Asynchronous RAM | [ramasync.v](logikbench/benchmarks/memory/ramasync/rtl/ramasync.v) |
| rambit | Bit-wide RAM | [rambit.v](logikbench/benchmarks/memory/rambit/rtl/rambit.v) |
| rambyte | Byte-wide RAM | [rambyte.v](logikbench/benchmarks/memory/rambyte/rtl/rambyte.v) |
| raminit | Initialized RAM | [raminit.v](logikbench/benchmarks/memory/raminit/rtl/raminit.v) |
| ramtdp | True dual-port RAM (single clock) | [ramtdp.v](logikbench/benchmarks/memory/ramtdp/rtl/ramtdp.v) |
| ramtdpdc | True dual-port RAM (dual clock) | [ramtdpdc.v](logikbench/benchmarks/memory/ramtdpdc/rtl/ramtdpdc.v) |
| ramsdp | Simple dual-port RAM | [ramsdp.v](logikbench/benchmarks/memory/ramsdp/rtl/ramsdp.v) |
| ramsp | Single-port RAM | [ramsp.v](logikbench/benchmarks/memory/ramsp/rtl/ramsp.v) |
| ramspnc | Single-port RAM (no change) | [ramspnc.v](logikbench/benchmarks/memory/ramspnc/rtl/ramspnc.v) |
| ramsprf | Single-port RAM (read-first) | [ramsprf.v](logikbench/benchmarks/memory/ramsprf/rtl/ramsprf.v) |
| ramspwf | Single-port RAM (write-first) | [ramspwf.v](logikbench/benchmarks/memory/ramspwf/rtl/ramspwf.v) |
| regfile | Register file | [regfile.v](logikbench/benchmarks/memory/regfile/rtl/regfile.v) |
| rom | Read-only memory | [rom.v](logikbench/benchmarks/memory/rom/rtl/rom.v) |

### Complex Blocks (42 benchmarks)

| Benchmark | Description | Verilog |
|-----------|-------------|---------|
| aes | AES encryption core | [aes.sv](logikbench/benchmarks/blocks/aes/rtl/aes.sv) |
| apbregs | APB register file | [apbregs.v](logikbench/benchmarks/blocks/apbregs/rtl/apbregs.v) |
| axicrossbar | AXI crossbar | [axi_crossbar.v](logikbench/benchmarks/blocks/axicrossbar/rtl/axi_crossbar.v) |
| axiram | AXI RAM interface | [axiram.v](logikbench/benchmarks/blocks/axiram/rtl/axiram.v) |
| blackparrot | BlackParrot RISC-V core | [blackparrot/](logikbench/benchmarks/blocks/blackparrot/) |
| conv2d | Streaming 3x3 2D convolution | [conv2d.v](logikbench/benchmarks/blocks/conv2d/rtl/conv2d.v) |
| coralnpu | CoralNPU neural accelerator | [coralnpu.sv](logikbench/benchmarks/blocks/coralnpu/rtl/coralnpu.sv) |
| crc32 | CRC-32 generator | [crc32.v](logikbench/benchmarks/blocks/crc32/rtl/crc32.v) |
| cva6 | CVA6 (Ariane) RISC-V core | [cva6.sv](logikbench/benchmarks/blocks/cva6/rtl/cva6.sv) |
| ddc | Digital down-converter (NCO/mixer/CIC/FIR) | [ddc.v](logikbench/benchmarks/blocks/ddc/rtl/ddc.v) |
| ethmac | Ethernet MAC | [ethmac.v](logikbench/benchmarks/blocks/ethmac/rtl/ethmac.v) |
| fft | Fast Fourier Transform | [fft.v](logikbench/benchmarks/blocks/fft/rtl/fft.v) |
| firfix | Fixed-coefficient FIR filter | [firfix.v](logikbench/benchmarks/blocks/firfix/rtl/firfix.v) |
| firprog | Programmable FIR filter | [firprog.v](logikbench/benchmarks/blocks/firprog/rtl/firprog.v) |
| fpu64 | 64-bit floating-point unit | [fpu64/](logikbench/benchmarks/blocks/fpu64/) |
| hamming | Hamming ECC encoder/decoder | [hamming.v](logikbench/benchmarks/blocks/hamming/rtl/hamming.v) |
| hmac | HMAC-SHA hashing | [hmac.sv](logikbench/benchmarks/blocks/hmac/rtl/hmac.sv) |
| huffman | Canonical Huffman encoder/decoder | [huffman.v](logikbench/benchmarks/blocks/huffman/rtl/huffman.v) |
| i2c | I2C controller | [i2c.sv](logikbench/benchmarks/blocks/i2c/rtl/i2c.sv) |
| ialu | Integer ALU | [ialu.v](logikbench/benchmarks/blocks/ialu/rtl/ialu.v) |
| lfsr | Linear feedback shift register | [lfsr.v](logikbench/benchmarks/blocks/lfsr/rtl/lfsr.v) |
| lpddr5 | LPDDR5 memory controller (UMI + DFI, ECC) | [lpddr5_umi.v](logikbench/benchmarks/blocks/lpddr5/rtl/lpddr5_umi.v) |
| lz77 | LZ77 (LZSS) compressor/decompressor | [lz77.v](logikbench/benchmarks/blocks/lz77/rtl/lz77.v) |
| median3x3 | Streaming 3x3 median filter | [median3x3.v](logikbench/benchmarks/blocks/median3x3/rtl/median3x3.v) |
| nvdla | NVDLA deep-learning accelerator | [nvdla/](logikbench/benchmarks/blocks/nvdla/) |
| ofdm | OFDM modem (QAM + IFFT/FFT) | [ofdm.v](logikbench/benchmarks/blocks/ofdm/rtl/ofdm.v) |
| openpiton | OpenPiton manycore tile | [openpiton.v](logikbench/benchmarks/blocks/openpiton/rtl/openpiton.v) |
| picorv32 | PicoRV32 RISC-V core | [picorv32.v](logikbench/benchmarks/blocks/picorv32/rtl/picorv32.v) |
| reedsolomon | Reed-Solomon RS(544,514) codec | [reedsolomon.v](logikbench/benchmarks/blocks/reedsolomon/rtl/reedsolomon.v) |
| rocket | Rocket RISC-V core | [rocket.v](logikbench/benchmarks/blocks/rocket/rtl/rocket.v) |
| sad8x8 | 8x8 sum of absolute differences | [sad8x8.v](logikbench/benchmarks/blocks/sad8x8/rtl/sad8x8.v) |
| serv | SERV bit-serial RISC-V core | [serv/](logikbench/benchmarks/blocks/serv/) |
| sobel3x3 | Streaming 3x3 Sobel edge detector | [sobel3x3.v](logikbench/benchmarks/blocks/sobel3x3/rtl/sobel3x3.v) |
| spi | SPI controller | [spi.sv](logikbench/benchmarks/blocks/spi/rtl/spi.sv) |
| tpu | Weight-stationary systolic matrix multiply (TPU MXU) | [tpu.v](logikbench/benchmarks/blocks/tpu/rtl/tpu.v) |
| uart | UART | [uart.sv](logikbench/benchmarks/blocks/uart/rtl/uart.sv) |
| umicross | UMI crossbar | [umicross/](logikbench/benchmarks/blocks/umicross/) |
| umidev | UMI device endpoint | [umidev/](logikbench/benchmarks/blocks/umidev/) |
| umiregs | UMI register file | [umiregs.v](logikbench/benchmarks/blocks/umiregs/rtl/umiregs.v) |
| viterbi | Viterbi decoder | [viterbi.v](logikbench/benchmarks/blocks/viterbi/rtl/viterbi.v) |
| vortex | Vortex GPU core | [vortex/](logikbench/benchmarks/blocks/vortex/) |
| wally | CVW-Wally RISC-V core | [wally/](logikbench/benchmarks/blocks/wally/) |

### EPFL Benchmarks (19 benchmarks)

| Benchmark | Description | Verilog |
|-----------|-------------|---------|
| epfl_adder | EPFL adder benchmark | [epfl_adder.v](logikbench/benchmarks/epfl/epfl_adder/rtl/epfl_adder.v) |
| epfl_arbiter | EPFL arbiter benchmark | [epfl_arbiter.v](logikbench/benchmarks/epfl/epfl_arbiter/rtl/epfl_arbiter.v) |
| epfl_bar | Barrel shifter | [epfl_bar.v](logikbench/benchmarks/epfl/epfl_bar/rtl/epfl_bar.v) |
| epfl_cavlc | CAVLC encoder | [epfl_cavlc.v](logikbench/benchmarks/epfl/epfl_cavlc/rtl/epfl_cavlc.v) |
| epfl_dec | Decoder | [epfl_dec.v](logikbench/benchmarks/epfl/epfl_dec/rtl/epfl_dec.v) |
| epfl_div | Divider | [epfl_div.v](logikbench/benchmarks/epfl/epfl_div/rtl/epfl_div.v) |
| epfl_hyp | Hypotenuse calculator | [epfl_hyp.v](logikbench/benchmarks/epfl/epfl_hyp/rtl/epfl_hyp.v) |
| epfl_i2c | I2C controller | [epfl_i2c.v](logikbench/benchmarks/epfl/epfl_i2c/rtl/epfl_i2c.v) |
| epfl_int2float | Integer to float converter | [epfl_int2float.v](logikbench/benchmarks/epfl/epfl_int2float/rtl/epfl_int2float.v) |
| epfl_log2 | Log base 2 | [epfl_log2.v](logikbench/benchmarks/epfl/epfl_log2/rtl/epfl_log2.v) |
| epfl_max | Maximum | [epfl_max.v](logikbench/benchmarks/epfl/epfl_max/rtl/epfl_max.v) |
| epfl_memctrl | Memory controller | [epfl_memctrl.v](logikbench/benchmarks/epfl/epfl_memctrl/rtl/epfl_memctrl.v) |
| epfl_multiplier | Multiplier | [epfl_multiplier.v](logikbench/benchmarks/epfl/epfl_multiplier/rtl/epfl_multiplier.v) |
| epfl_priority | Priority encoder | [epfl_priority.v](logikbench/benchmarks/epfl/epfl_priority/rtl/epfl_priority.v) |
| epfl_router | Router | [epfl_router.v](logikbench/benchmarks/epfl/epfl_router/rtl/epfl_router.v) |
| epfl_sin | Sine function | [epfl_sin.v](logikbench/benchmarks/epfl/epfl_sin/rtl/epfl_sin.v) |
| epfl_sqrt | Square root | [epfl_sqrt.v](logikbench/benchmarks/epfl/epfl_sqrt/rtl/epfl_sqrt.v) |
| epfl_square | Square function | [epfl_square.v](logikbench/benchmarks/epfl/epfl_square/rtl/epfl_square.v) |
| epfl_voter | Voter circuit | [epfl_voter.v](logikbench/benchmarks/epfl/epfl_voter/rtl/epfl_voter.v) |

### ISCAS85 Benchmarks (11 benchmarks)

Combinational gate-level circuits. See [iscas85/README.md](logikbench/benchmarks/iscas85/README.md).

| Benchmark | Description | Verilog |
|-----------|-------------|---------|
| c17 | Trivial 6-gate circuit | [c17.v](logikbench/benchmarks/iscas85/c17/rtl/c17.v) |
| c432 | 27-channel interrupt controller | [c432.v](logikbench/benchmarks/iscas85/c432/rtl/c432.v) |
| c499 | 32-bit single-error-correcting circuit | [c499.v](logikbench/benchmarks/iscas85/c499/rtl/c499.v) |
| c880 | 8-bit ALU | [c880.v](logikbench/benchmarks/iscas85/c880/rtl/c880.v) |
| c1355 | 32-bit single-error-correcting circuit | [c1355.v](logikbench/benchmarks/iscas85/c1355/rtl/c1355.v) |
| c1908 | 16-bit SEC/DED circuit | [c1908.v](logikbench/benchmarks/iscas85/c1908/rtl/c1908.v) |
| c2670 | 12-bit ALU and controller | [c2670.v](logikbench/benchmarks/iscas85/c2670/rtl/c2670.v) |
| c3540 | 8-bit ALU | [c3540.v](logikbench/benchmarks/iscas85/c3540/rtl/c3540.v) |
| c5315 | ALU with parity | [c5315.v](logikbench/benchmarks/iscas85/c5315/rtl/c5315.v) |
| c6288 | 16x16 combinational multiplier | [c6288.v](logikbench/benchmarks/iscas85/c6288/rtl/c6288.v) |
| c7552 | 32-bit adder/comparator | [c7552.v](logikbench/benchmarks/iscas85/c7552/rtl/c7552.v) |

### ISCAS89 Benchmarks (28 benchmarks)

Sequential gate-level circuits (clock port `CK`). See [iscas89/README.md](logikbench/benchmarks/iscas89/README.md).

| Benchmark | Description | Verilog |
|-----------|-------------|---------|
| s27 | Sequential benchmark circuit | [s27.v](logikbench/benchmarks/iscas89/s27/rtl/s27.v) |
| s298 | Sequential benchmark circuit | [s298.v](logikbench/benchmarks/iscas89/s298/rtl/s298.v) |
| s344 | Sequential benchmark circuit | [s344.v](logikbench/benchmarks/iscas89/s344/rtl/s344.v) |
| s349 | Sequential benchmark circuit | [s349.v](logikbench/benchmarks/iscas89/s349/rtl/s349.v) |
| s382 | Sequential benchmark circuit | [s382.v](logikbench/benchmarks/iscas89/s382/rtl/s382.v) |
| s386 | Sequential benchmark circuit | [s386.v](logikbench/benchmarks/iscas89/s386/rtl/s386.v) |
| s400 | Sequential benchmark circuit | [s400.v](logikbench/benchmarks/iscas89/s400/rtl/s400.v) |
| s420 | Sequential benchmark circuit | [s420.v](logikbench/benchmarks/iscas89/s420/rtl/s420.v) |
| s444 | Sequential benchmark circuit | [s444.v](logikbench/benchmarks/iscas89/s444/rtl/s444.v) |
| s510 | Sequential benchmark circuit | [s510.v](logikbench/benchmarks/iscas89/s510/rtl/s510.v) |
| s526 | Sequential benchmark circuit | [s526.v](logikbench/benchmarks/iscas89/s526/rtl/s526.v) |
| s641 | Sequential benchmark circuit | [s641.v](logikbench/benchmarks/iscas89/s641/rtl/s641.v) |
| s713 | Sequential benchmark circuit | [s713.v](logikbench/benchmarks/iscas89/s713/rtl/s713.v) |
| s820 | Sequential benchmark circuit | [s820.v](logikbench/benchmarks/iscas89/s820/rtl/s820.v) |
| s832 | Sequential benchmark circuit | [s832.v](logikbench/benchmarks/iscas89/s832/rtl/s832.v) |
| s838 | Sequential benchmark circuit | [s838.v](logikbench/benchmarks/iscas89/s838/rtl/s838.v) |
| s953 | Sequential benchmark circuit | [s953.v](logikbench/benchmarks/iscas89/s953/rtl/s953.v) |
| s1196 | Sequential benchmark circuit | [s1196.v](logikbench/benchmarks/iscas89/s1196/rtl/s1196.v) |
| s1238 | Sequential benchmark circuit | [s1238.v](logikbench/benchmarks/iscas89/s1238/rtl/s1238.v) |
| s1423 | Sequential benchmark circuit | [s1423.v](logikbench/benchmarks/iscas89/s1423/rtl/s1423.v) |
| s1488 | Sequential benchmark circuit | [s1488.v](logikbench/benchmarks/iscas89/s1488/rtl/s1488.v) |
| s5378 | Sequential benchmark circuit | [s5378.v](logikbench/benchmarks/iscas89/s5378/rtl/s5378.v) |
| s9234 | Sequential benchmark circuit | [s9234.v](logikbench/benchmarks/iscas89/s9234/rtl/s9234.v) |
| s13207 | Sequential benchmark circuit | [s13207.v](logikbench/benchmarks/iscas89/s13207/rtl/s13207.v) |
| s15850 | Sequential benchmark circuit | [s15850.v](logikbench/benchmarks/iscas89/s15850/rtl/s15850.v) |
| s35932 | Sequential benchmark circuit | [s35932.v](logikbench/benchmarks/iscas89/s35932/rtl/s35932.v) |
| s38417 | Sequential benchmark circuit | [s38417.v](logikbench/benchmarks/iscas89/s38417/rtl/s38417.v) |
| s38584 | Sequential benchmark circuit | [s38584.v](logikbench/benchmarks/iscas89/s38584/rtl/s38584.v) |

----



## Leaderboard (WIP)



Targets ranked by total LUTs over all benchmarks (config: `small`), lowest first. A benchmark with no result for a target is charged the highest LUT count any target reached on it.
Comparing different FPGA architectures is by definition an apples to oranges exercise. Ranking by no means implies quality or goodness, it's just a neat way to compress and order data.

<!-- RANKING:START -->
| Rank | Target | Arch | Total LUTs | Missing |
|-----:|--------|------|-----------:|--------:|
| 1 | zeroasic_z1060 | LUT6 | 622,544 | 5 |
| 2 | gatemate_cologne | LUT8 | 657,965 | 6 |
| 3 | adi_flex16ffc | LUT6 | 712,670 | 4 |
| 4 | xilinx_virtex7 | LUT6 | 727,599 | 11 |
| 5 | zeroasic_z1015 | LUT4 | 783,697 | 5 |
| 6 | microchip_polarfire | LUT4 | 806,090 | 14 |
| 7 | lattice_ice40 | LUT4 | 955,767 | 8 |
| 8 | efinix_trion | LUT4 | 972,448 | 9 |
| 9 | lattice_ecp5 | LUT4 | 1,099,864 | 11 |
| 10 | quicklogic_polarpro | LUT4/MUX | 1,152,443 | 14 |
| 11 | fabulous_generic | LUT4 | 1,276,650 | 17 |
| 12 | gowin_gw5a | LUT4 | 1,543,462 | 11 |
| 13 | achronix_speedster | LUT6 | 1,552,803 | 25 |
| 14 | zeroasic_z1015opt | LUT4 | 1,628,976 | 57 |
<!-- RANKING:END -->

### ASIC Synthesis

ASIC leaderboard tables (cell area and FMAX, starting with `freepdk45`) are
work in progress and will be published here once results are collected.

## Tool Installation

LogikBench itself is pure Python and installs from PyPI:

```bash
pip install logikbench
```
Running benchmarks additionally needs the EDA tools that SiliconCompiler drives.
The `sc-install` helper (shipped with SiliconCompiler) builds and installs them.
Install by group, or name individual tools:

```bash
sc-install -group fpga          # FPGA synthesis (Yosys + vendor plugins)
sc-install -group asic          # ASIC synthesis + timing (Yosys, OpenROAD, OpenSTA)
```

Useful flags: `-prefix <path>` to install somewhere other than the default,
`-build_dir <path>` to build elsewhere, and `-jobs <N>` to limit parallel build
jobs on memory-constrained machines.

| Use case | Tools | Group |
|----------|-------|-------|
| FPGA LUT / depth metrics | Yosys (+ vendor synth plugins) | `fpga` |
| ASIC area / FMAX metrics | Yosys, OpenROAD, OpenSTA | `asic` |
| RTL simulation (testbenches) | Icarus Verilog, Verilator | `digital-simulation` |

## License

The LogikBench project is licensed under the [MIT](LICENSE) license unless specified otherwise inside the individual benchmark folders.