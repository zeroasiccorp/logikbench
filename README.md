# LogikBench

[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Python Version](https://img.shields.io/badge/python-3.10+-blue.svg)](https://www.python.org/downloads/)
[![PyPI](https://img.shields.io/pypi/v/logikbench.svg)](https://pypi.org/project/logikbench/)
[![Lint](https://github.com/zeroasiccorp/logikbench/actions/workflows/lint.yml/badge.svg)](https://github.com/zeroasiccorp/logikbench/actions/workflows/lint.yml)
[![Downloads](https://static.pepy.tech/badge/logikbench)](https://pepy.tech/project/logikbench)

LogikBench is a curated suite of tech agnostic RTL benchmarks.

## Problems

The semiconductor industry lacks a comprehensive, standardized benchmark suite for evaluating EDA tools, design flows, foundry processes, and FPGA devices. Existing RTL benchmark suites suffer from critical gaps. These gaps make it difficult to objectively compare tools, validate improvements, and track progress across the industry.

* **No standardization** --> no "ImageNet/SpecInt/Dhrystone for EDA"
* **No diversity** --> too many CPUs, not represntative of real designs
* **No parameters** --> not representative of full range of performance targets
* **No provanance** --> benchmark origin and intent often unknown
* **No infrastructure** -->  no clear path to reproducibility
* **No open source license** --> license often ambiguous/unknown

## Logikbench Solution

"Sunlight is said to be the best of disinfectants." --Supreme Court Justice Louis Brandeis

* **100+ unique benchmark circuits** spanning basic logic to complex subsystems
* **Synthesis ready** ...not just raw text string blobs
* **10,000+ configurations** through parameter sweeping
* **Standardized metrics** and execution infrastructure
* **100% open source** no license or membership fees!
* **Full provenance** documented source code provenance

## TLDR

Install logikbench via PyPI, use the `sc-install` script to install all EDA tools, and then use `lb` to run the benchmarks.

```bash
pip install logikbench
sc-install -group fpga
lb --target lattice_ice40 -j 4
```
----

## FPGA Synthesis Ranking

!!!Work-In-Progress!!!

Targets ranked by total LUTs over all benchmarks (config: `small`), lowest first. A benchmark with no result for a target is charged the highest LUT count any target reached on it.
Comparing different FPGA architectures is by definition an apples to oranges exercise. Ranking by no means implies quality or goodness, it's just a neat way to compress and order data.

<!-- RANKING:START -->
| Rank | Target | Arch | Total LUTs | Missing |
|-----:|--------|------|-----------:|--------:|
| 1 | zeroasic_z1060 | LUT6 | 161,693 | 5 |
| 2 | gatemate_cologne | LUT8 | 190,534 | 5 |
| 3 | microchip_polarfire | LUT4 | 224,143 | 7 |
| 4 | zeroasic_z1015 | LUT4 | 225,818 | 5 |
| 5 | adi_flex16ffc | LUT6 | 227,133 | 4 |
| 6 | xilinx_virtex7 | LUT6 | 247,199 | 9 |
| 7 | quicklogic_polarpro | LUT4/MUX | 253,639 | 2 |
| 8 | lattice_ice40 | LUT4 | 256,531 | 4 |
| 9 | efinix_trion | LUT4 | 263,076 | 8 |
| 10 | fabulous_generic | LUT4 | 278,615 | 8 |
| 11 | achronix_speedster | LUT6 | 439,740 | 10 |
| 12 | lattice_ecp5 | LUT4 | 442,540 | 8 |
| 13 | zeroasic_z1015opt | LUT4 | 497,161 | 29 |
| 14 | gowin_gw5a | LUT4 | 617,752 | 7 |
<!-- RANKING:END -->

----

## Benchmark Architecture

Each LogikBench benchmark circuit consists of:
* **Tech-agnostic RTL Verilog files** for broad tool compatibility
* **SiliconCompiler Design object** with metadata and configuration

The SiliconCompiler Design object captures benchmark data as files, parameters, topmodule name, and other settings grouped as a `fileset`. Every circuit in the LogikBench suite has a Python class that inherits from SiliconCompiler's Design class, as shown in this [`mux`](logikbench/basic/mux/rtl/mux.v) example:

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
----

## Benchmark Metrics

FPGA runs report three metrics, all extracted from the Yosys synthesis run (no
place-and-route): **LUTs**, **logic depth**, and **runtime**.

### LUTs

The LUT count is the synthesized logic-fabric usage, read from Yosys'
`stat` per-cell-type report (`num_cells_by_type`). It sums three kinds of cell:

1. **Lookup tables** — the basic LUT primitives, whose names vary by vendor:
   `LUT1..LUT6`, `$lut`, `SB_LUT4` (ice40), `EFX_LUT4` (efinix), `CC_LUT*`
   (gatemate), `LUTFF` (fabulous), and `CFG1..CFG4` (microchip PolarFire).
2. **Dedicated mux-fabric cells** — the hardwired wide multiplexers that live in
   the same logic block as the LUTs and implement muxing a LUT-only fabric would
   otherwise spend LUTs on: `MUXF7/MUXF8` (xilinx), `mux4x0/mux8x0` (quicklogic),
   `MUX2_LUT5..8` (gowin), `LUTMUX7/8` (adi), `L6MUX21/PFUMX` (lattice ECP5),
   `CC_MX4/CC_MX8` (gatemate), `MX4` (microchip).
3. **Hard DSP / multiply / MAC blocks** — dedicated multiplier and
   multiply-accumulate cells: `DSP48E1` (xilinx), `MULT18X18D` (lattice ECP5),
   `CC_MULT` (gatemate), `MACC_PA` (microchip), `RBBDSP` (adi), `efpga_mult*`
   (Zero ASIC). A fabric without them builds multipliers out of LUTs, so a
   target that uses a hard block would otherwise read as artificially LUT-light.
   (Carry/ALU cells such as `CARRY4`, `ALU`, `CCU2C`, `ARI1` are *not* DSPs and
   are not counted.)

Including the mux cells keeps the comparison fair: ice40 has no dedicated mux, so
its read/select logic is built entirely from LUTs and is fully counted; fabrics
like QuickLogic or GateMate offload that same logic to mux cells, which would
otherwise make their LUT count read artificially low (e.g. `regfile` on
QuickLogic is mostly `mux8x0` cells, not LUTs).

Every fabric cell counts as one, regardless of its capacity: a 6-input LUT
(Xilinx, ADI) packs more logic than a 4-input LUT, and a hard mux (e.g.
QuickLogic `mux8x0`) does an 8:1 select that a LUT-only fabric would spend
several LUTs on — but each is one cell. This makes the metric a clean
*logic-cell utilization* count, most directly comparable *within* an
architecture family (e.g. the Zero ASIC `z10xx` parts, or two synthesis options
on one target). Across vendors the cells differ in size, so cross-vendor LUT
counts are informative rather than a strict apples-to-apples ranking — each
architecture wins where its cell type fits the design (mux fabrics on
mux/select/decode logic, LUT/carry fabrics on arithmetic).

### Logic depth

Logic depth is the **longest combinational path** through the mapped netlist,
measured by Yosys' `ltp -noff` (longest topological path, flip-flops excluded).
It is the count of cells on that path, reported uniformly across all targets;
the per-vendor ABC mapping reports are inconsistent (some flows print nothing),
so `ltp` gives one comparable number. `ltp` only spans a single module, but the
vendor `synth_*` flows flatten by default, so it covers the whole design.

Because it counts *cells*, the path includes carry-chain and mux cells, not just
LUT levels — so depth, like LUTs, reflects each architecture's primitives.

### Runtime

Runtime is the wall-clock time of the synthesis step, reported to 0.01 s.

----

## Running Benchmarks

LogikBench includes the `lb` command-line tool for batch processing benchmarks.
It drives synthesis through [SiliconCompiler](https://github.com/siliconcompiler/siliconcompiler):
each benchmark is a SiliconCompiler `Design`, and `lb` has two subcommands:

- `lb run` synthesizes the selected benchmarks for one or more targets.
- `lb collect` harvests metrics from existing build results (no synthesis).

Both take `-g/--group` and the required `-t/--target`. Run `lb run -h` or
`lb collect -h` for the full option list.

### Targets

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
architecture config vendored under `logikbench/targets/fpga/zeroasic/`.

ASIC targets:

- `freepdk45` -- ASIC synthesis + OpenSTA timing via LogikBench's `lbflow`
  (pre-layout STA, so it reports `fmax` without place & route).
- `<pdk>_demo` (`freepdk45_demo`, `asap7_demo`, `skywater130_demo`, `gf180_demo`,
  `ihp130_demo`) -- the official SiliconCompiler demo target for that PDK, run
  through SC's `asicflow` (full RTL-to-GDS). Use `--to` to limit how far it runs.

Metrics are fixed by the run mode: `luts`, `logicdepth`, `tasktime` for FPGA;
`cells`, `cellarea`, `fmax` for ASIC.

### Options

Shared by both subcommands:

| Flag | Description |
|------|-------------|
| `-g`, `--group` | Benchmark group(s): `basic`, `memory`, `arithmetic`, `epfl`, `blocks` (required) |
| `-n`, `--name` | Only act on benchmark(s) with these name(s), matched against the selected group(s) (default: all of them) |
| `-t`, `--target` | Synthesis target(s) to sweep (required); see the Targets table above |
| `-b` | Build directory root; per-benchmark work goes in `<builddir>/<target>/<name>` (default: `build`) |

`lb run` only:

| Flag | Description |
|------|-------------|
| `-j` | Number of benchmarks to synthesize in parallel across the target x benchmark matrix (default: 1) |
| `--options` | Extra args passed verbatim to the FPGA synth command. Use the `=` form so leading dashes are not parsed as flags: `--options=-abc9` (quote multiple: `--options='-abc9 -nocarry'`) |
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
lb run -g basic -t freepdk45
lb collect -g basic -t freepdk45 -o results
```

Run the asap7 demo target (SC asicflow), synthesis only:

```bash
lb run -g basic -t asap7_demo --to synthesis
```
----

## Benchmark Inventory

### Basic Logic (22 benchmarks)

| Benchmark | Description | Verilog |
|-----------|-------------|---------|
| arbiter | Fixed-priority arbiter | [arbiter.v](logikbench/basic/arbiter/rtl/arbiter.v) |
| band | Bitwise AND | [band.v](logikbench/basic/band/rtl/band.v) |
| bbuf | Buffer | [bbuf.v](logikbench/basic/bbuf/rtl/bbuf.v) |
| bin2gray | Binary to Gray code converter | [bin2gray.v](logikbench/basic/bin2gray/rtl/bin2gray.v) |
| bin2prio | Binary to priority encoder | [bin2prio.v](logikbench/basic/bin2prio/rtl/bin2prio.v) |
| binv | Bitwise inverter | [binv.v](logikbench/basic/binv/rtl/binv.v) |
| bnand | Bitwise NAND | [bnand.v](logikbench/basic/bnand/rtl/bnand.v) |
| bnor | Bitwise NOR | [bnor.v](logikbench/basic/bnor/rtl/bnor.v) |
| bor | Bitwise OR | [bor.v](logikbench/basic/bor/rtl/bor.v) |
| bxnor | Bitwise XNOR | [bxnor.v](logikbench/basic/bxnor/rtl/bxnor.v) |
| bxor | Bitwise XOR | [bxor.v](logikbench/basic/bxor/rtl/bxor.v) |
| crossbar | Crossbar switch | [crossbar.v](logikbench/basic/crossbar/rtl/crossbar.v) |
| dffasync | Asynchronous reset flip-flop | [dffasync.v](logikbench/basic/dffasync/rtl/dffasync.v) |
| dffsync | Synchronous reset flip-flop | [dffsync.v](logikbench/basic/dffsync/rtl/dffsync.v) |
| gray2bin | Gray to binary code converter | [gray2bin.v](logikbench/basic/gray2bin/rtl/gray2bin.v) |
| mux | Multiplexer | [mux.v](logikbench/basic/mux/rtl/mux.v) |
| muxcase | Case-based multiplexer | [muxcase.v](logikbench/basic/muxcase/rtl/muxcase.v) |
| muxhot | One-hot multiplexer | [muxhot.v](logikbench/basic/muxhot/rtl/muxhot.v) |
| muxpri | Priority multiplexer | [muxpri.v](logikbench/basic/muxpri/rtl/muxpri.v) |
| onehot | One-hot encoder | [onehot.v](logikbench/basic/onehot/rtl/onehot.v) |
| pipeline | Pipeline register | [pipeline.v](logikbench/basic/pipeline/rtl/pipeline.v) |
| shiftreg | Shift register | [shiftreg.v](logikbench/basic/shiftreg/rtl/shiftreg.v) |

### Arithmetic (33 benchmarks)

| Benchmark | Description | Verilog |
|-----------|-------------|---------|
| abs | Absolute value | [abs.v](logikbench/arithmetic/abs/rtl/abs.v) |
| absdiff | Absolute difference | [absdiff.v](logikbench/arithmetic/absdiff/rtl/absdiff.v) |
| absdiffs | Signed absolute difference | [absdiffs.v](logikbench/arithmetic/absdiffs/rtl/absdiffs.v) |
| add | Adder | [add.v](logikbench/arithmetic/add/rtl/add.v) |
| addsub | Adder-subtractor | [addsub.v](logikbench/arithmetic/addsub/rtl/addsub.v) |
| cmp | Comparator | [cmp.v](logikbench/arithmetic/cmp/rtl/cmp.v) |
| counter | Counter | [counter.v](logikbench/arithmetic/counter/rtl/counter.v) |
| csa32 | 3:2 carry-save adder | [csa32.v](logikbench/arithmetic/csa32/rtl/csa32.v) |
| csa42 | 4:2 carry-save adder | [csa42.v](logikbench/arithmetic/csa42/rtl/csa42.v) |
| dec | Decrementer | [dec.v](logikbench/arithmetic/dec/rtl/dec.v) |
| dotprod | Dot product | [dotprod.v](logikbench/arithmetic/dotprod/rtl/dotprod.v) |
| inc | Incrementer | [inc.v](logikbench/arithmetic/inc/rtl/inc.v) |
| log2 | Log base 2 | [log2.v](logikbench/arithmetic/log2/rtl/log2.v) |
| mac | Multiply-accumulate | [mac.v](logikbench/arithmetic/mac/rtl/mac.v) |
| max | Maximum | [max.v](logikbench/arithmetic/max/rtl/max.v) |
| min | Minimum | [min.v](logikbench/arithmetic/min/rtl/min.v) |
| mul | Multiplier | [mul.v](logikbench/arithmetic/mul/rtl/mul.v) |
| muladd | Multiply-add | [muladd.v](logikbench/arithmetic/muladd/rtl/muladd.v) |
| muladdc | Multiply-add with carry | [muladdc.v](logikbench/arithmetic/muladdc/rtl/muladdc.v) |
| mulc | Constant multiplier | [mulc.v](logikbench/arithmetic/mulc/rtl/mulc.v) |
| mulreg | Registered multiplier | [mulreg.v](logikbench/arithmetic/mulreg/rtl/mulreg.v) |
| muls | Signed multiplier | [muls.v](logikbench/arithmetic/muls/rtl/muls.v) |
| relu | ReLU activation function | [relu.v](logikbench/arithmetic/relu/rtl/relu.v) |
| round | Rounder | [round.v](logikbench/arithmetic/round/rtl/round.v) |
| shiftar | Arithmetic right shift | [shiftar.v](logikbench/arithmetic/shiftar/rtl/shiftar.v) |
| shiftb | Barrel shifter | [shiftb.v](logikbench/arithmetic/shiftb/rtl/shiftb.v) |
| shiftl | Left shift | [shiftl.v](logikbench/arithmetic/shiftl/rtl/shiftl.v) |
| shiftr | Right shift | [shiftr.v](logikbench/arithmetic/shiftr/rtl/shiftr.v) |
| sine | Sine function | [sine.v](logikbench/arithmetic/sine/rtl/sine.v) |
| sqdiff | Squared difference | [sqdiff.v](logikbench/arithmetic/sqdiff/rtl/sqdiff.v) |
| sqrt | Square root | [sqrt.v](logikbench/arithmetic/sqrt/rtl/sqrt.v) |
| sub | Subtractor | [sub.v](logikbench/arithmetic/sub/rtl/sub.v) |
| sum | Summation tree | [sum.v](logikbench/arithmetic/sum/rtl/sum.v) |

### Memory (13 benchmarks)

| Benchmark | Description | Verilog |
|-----------|-------------|---------|
| axiram | AXI RAM interface | [axil_ram.v](logikbench/memory/axiram/rtl/axil_ram.v) |
| cache | Cache memory | [cache.v](logikbench/memory/cache/rtl/cache.v) |
| fifoasync | Asynchronous FIFO | [fifoasync.v](logikbench/memory/fifoasync/rtl/fifoasync.v) |
| fifosync | Synchronous FIFO | [fifosync.v](logikbench/memory/fifosync/rtl/fifosync.v) |
| ramasync | Asynchronous RAM | [ramasync.v](logikbench/memory/ramasync/rtl/ramasync.v) |
| rambit | Bit-wide RAM | [rambit.v](logikbench/memory/rambit/rtl/rambit.v) |
| rambyte | Byte-wide RAM | [rambyte.v](logikbench/memory/rambyte/rtl/rambyte.v) |
| ramtdp | True dual-port RAM | [ramtdp.v](logikbench/memory/ramtdp/rtl/ramtdp.v) |
| ramsdp | Simple dual-port RAM | [ramsdp.v](logikbench/memory/ramsdp/rtl/ramsdp.v) |
| ramsp | Single-port RAM | [ramsp.v](logikbench/memory/ramsp/rtl/ramsp.v) |
| ramspnc | Single-port RAM (no change) | [ramspnc.v](logikbench/memory/ramspnc/rtl/ramspnc.v) |
| regfile | Register file | [regfile.v](logikbench/memory/regfile/rtl/regfile.v) |
| rom | Read-only memory | [rom.v](logikbench/memory/rom/rtl/rom.v) |

### Complex Blocks (40 benchmarks)

| Benchmark | Description | Verilog |
|-----------|-------------|---------|
| aes | AES encryption core | [aes.sv](logikbench/blocks/aes/rtl/aes.sv) |
| apbregs | APB register file | [apbregs.v](logikbench/blocks/apbregs/rtl/apbregs.v) |
| axicrossbar | AXI crossbar | [arbiter.v](logikbench/blocks/axicrossbar/rtl/arbiter.v) |
| blackparrot | BlackParrot RISC-V core | [blackparrot/](logikbench/blocks/blackparrot/) |
| conv2d | Streaming 3x3 2D convolution | [conv2d.v](logikbench/blocks/conv2d/rtl/conv2d.v) |
| coralnpu | CoralNPU neural accelerator | [coralnpu.sv](logikbench/blocks/coralnpu/rtl/coralnpu.sv) |
| crc32 | CRC-32 generator | [crc32.v](logikbench/blocks/crc32/rtl/crc32.v) |
| cva6 | CVA6 (Ariane) RISC-V core | [cva6.sv](logikbench/blocks/cva6/rtl/cva6.sv) |
| ddc | Digital down-converter (NCO/mixer/CIC/FIR) | [ddc.v](logikbench/blocks/ddc/rtl/ddc.v) |
| ethmac | Ethernet MAC | [ethmac.v](logikbench/blocks/ethmac/rtl/ethmac.v) |
| fft | Fast Fourier Transform | [fft.v](logikbench/blocks/fft/rtl/fft.v) |
| firfix | Fixed-coefficient FIR filter | [firfix.v](logikbench/blocks/firfix/rtl/firfix.v) |
| firprog | Programmable FIR filter | [firprog.v](logikbench/blocks/firprog/rtl/firprog.v) |
| fpu64 | 64-bit floating-point unit | [fpu64/](logikbench/blocks/fpu64/) |
| hamming | Hamming ECC encoder/decoder | [hamming.v](logikbench/blocks/hamming/rtl/hamming.v) |
| hmac | HMAC-SHA hashing | [hmac.sv](logikbench/blocks/hmac/rtl/hmac.sv) |
| huffman | Canonical Huffman encoder/decoder | [huffman.v](logikbench/blocks/huffman/rtl/huffman.v) |
| i2c | I2C controller | [i2c.sv](logikbench/blocks/i2c/rtl/i2c.sv) |
| ialu | Integer ALU | [ialu.v](logikbench/blocks/ialu/rtl/ialu.v) |
| lfsr | Linear feedback shift register | [lfsr.v](logikbench/blocks/lfsr/rtl/lfsr.v) |
| lz77 | LZ77 (LZSS) compressor/decompressor | [lz77.v](logikbench/blocks/lz77/rtl/lz77.v) |
| median3x3 | Streaming 3x3 median filter | [median3x3.v](logikbench/blocks/median3x3/rtl/median3x3.v) |
| nvdla | NVDLA deep-learning accelerator | [nvdla/](logikbench/blocks/nvdla/) |
| ofdm | OFDM modem (QAM + IFFT/FFT) | [ofdm.v](logikbench/blocks/ofdm/rtl/ofdm.v) |
| openpiton | OpenPiton manycore tile | [openpiton.v](logikbench/blocks/openpiton/rtl/openpiton.v) |
| picorv32 | PicoRV32 RISC-V core | [picorv32.v](logikbench/blocks/picorv32/rtl/picorv32.v) |
| reedsolomon | Reed-Solomon RS(544,514) codec | [reedsolomon.v](logikbench/blocks/reedsolomon/rtl/reedsolomon.v) |
| rocket | Rocket RISC-V core | [rocket.v](logikbench/blocks/rocket/rtl/rocket.v) |
| sad8x8 | 8x8 sum of absolute differences | [sad8x8.v](logikbench/blocks/sad8x8/rtl/sad8x8.v) |
| serv | SERV bit-serial RISC-V core | [serv/](logikbench/blocks/serv/) |
| sobel3x3 | Streaming 3x3 Sobel edge detector | [sobel3x3.v](logikbench/blocks/sobel3x3/rtl/sobel3x3.v) |
| spi | SPI controller | [spi.sv](logikbench/blocks/spi/rtl/spi.sv) |
| tpu | Weight-stationary systolic matrix multiply (TPU MXU) | [tpu.v](logikbench/blocks/tpu/rtl/tpu.v) |
| uart | UART | [uart.sv](logikbench/blocks/uart/rtl/uart.sv) |
| umicross | UMI crossbar | [umicross/](logikbench/blocks/umicross/) |
| umidev | UMI device endpoint | [umidev/](logikbench/blocks/umidev/) |
| umiregs | UMI register file | [umiregs.v](logikbench/blocks/umiregs/rtl/umiregs.v) |
| viterbi | Viterbi decoder | [viterbi.v](logikbench/blocks/viterbi/rtl/viterbi.v) |
| vortex | Vortex GPU core | [vortex/](logikbench/blocks/vortex/) |
| wally | CVW-Wally RISC-V core | [wally/](logikbench/blocks/wally/) |

### EPFL Benchmarks (19 benchmarks)

| Benchmark | Description | Verilog |
|-----------|-------------|---------|
| epfl_adder | EPFL adder benchmark | [epfl_adder.v](logikbench/epfl/epfl_adder/rtl/epfl_adder.v) |
| epfl_arbiter | EPFL arbiter benchmark | [epfl_arbiter.v](logikbench/epfl/epfl_arbiter/rtl/epfl_arbiter.v) |
| epfl_bar | Barrel shifter | [epfl_bar.v](logikbench/epfl/epfl_bar/rtl/epfl_bar.v) |
| epfl_cavlc | CAVLC encoder | [epfl_cavlc.v](logikbench/epfl/epfl_cavlc/rtl/epfl_cavlc.v) |
| epfl_dec | Decoder | [epfl_dec.v](logikbench/epfl/epfl_dec/rtl/epfl_dec.v) |
| epfl_div | Divider | [epfl_div.v](logikbench/epfl/epfl_div/rtl/epfl_div.v) |
| epfl_hyp | Hypotenuse calculator | [epfl_hyp.v](logikbench/epfl/epfl_hyp/rtl/epfl_hyp.v) |
| epfl_i2c | I2C controller | [epfl_i2c.v](logikbench/epfl/epfl_i2c/rtl/epfl_i2c.v) |
| epfl_int2float | Integer to float converter | [epfl_int2float.v](logikbench/epfl/epfl_int2float/rtl/epfl_int2float.v) |
| epfl_log2 | Log base 2 | [epfl_log2.v](logikbench/epfl/epfl_log2/rtl/epfl_log2.v) |
| epfl_max | Maximum | [epfl_max.v](logikbench/epfl/epfl_max/rtl/epfl_max.v) |
| epfl_memctrl | Memory controller | [epfl_memctrl.v](logikbench/epfl/epfl_memctrl/rtl/epfl_memctrl.v) |
| epfl_multiplier | Multiplier | [epfl_multiplier.v](logikbench/epfl/epfl_multiplier/rtl/epfl_multiplier.v) |
| epfl_priority | Priority encoder | [epfl_priority.v](logikbench/epfl/epfl_priority/rtl/epfl_priority.v) |
| epfl_router | Router | [epfl_router.v](logikbench/epfl/epfl_router/rtl/epfl_router.v) |
| epfl_sin | Sine function | [epfl_sin.v](logikbench/epfl/epfl_sin/rtl/epfl_sin.v) |
| epfl_sqrt | Square root | [epfl_sqrt.v](logikbench/epfl/epfl_sqrt/rtl/epfl_sqrt.v) |
| epfl_square | Square function | [epfl_square.v](logikbench/epfl/epfl_square/rtl/epfl_square.v) |
| epfl_voter | Voter circuit | [epfl_voter.v](logikbench/epfl/epfl_voter/rtl/epfl_voter.v) |

----

## License

The LogikBench project is licensed under the [MIT](LICENSE) license unless specified otherwise inside the individual benchmark folders.