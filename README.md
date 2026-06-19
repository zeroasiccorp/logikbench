# LogikBench

[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Python Version](https://img.shields.io/badge/python-3.10+-blue.svg)](https://www.python.org/downloads/)
[![PyPI](https://img.shields.io/pypi/v/logikbench.svg)](https://pypi.org/project/logikbench/)
[![CI](https://github.com/zeroasiccorp/logikbench/actions/workflows/ci.yml/badge.svg)](https://github.com/zeroasiccorp/logikbench/actions)
[![Downloads](https://static.pepy.tech/badge/logikbench)](https://pepy.tech/project/logikbench)

**103 parametrized RTL benchmarks for unbiased EDA evaluation**

## Problem

The semiconductor industry lacks a comprehensive, standardized benchmark suite for evaluating EDA tools, design flows, foundry processes, and FPGA devices. Existing RTL benchmark suites suffer from critical gaps:

* **Small datasets** with limited coverage
* **Hard-coded circuit sizes** preventing parametric studies
* **Limited circuit diversity** that doesn't reflect real designs
* **Ambiguous licenses** blocking commercial use
* **No execution infrastructure** for reproducible results
* **No standard metrics** for comparing tools and flows
* **No standard datasets** (no "ImageNet for EDA")
* **No standard scores** (no "SpecInt/Dhrystone for EDA")
* **Limited provenance** on benchmark origins and design intent

These gaps make it difficult to objectively compare tools, validate improvements, and track progress across the industry.

## Solution

LogikBench provides a comprehensive, parametrized RTL benchmark suite with:

* **119 unique benchmark circuits** spanning basic logic to complex subsystems
* **10,000+ configurations** through parameter sweeping
* **MIT License** enabling commercial and academic use
* **Python API** built on SiliconCompiler for easy integration
* **Standardized metrics** and execution infrastructure
* **Full provenance** with clear documentation and design intent
* **Active development** with continuous additions to the suite

The suite covers five major categories targeting different evaluation needs:

| Group                                         | Benchmarks | Description                              |
|-----------------------------------------------|------------|------------------------------------------|
| [basic](logikbench/basic/README.md)           | 22         | Logic primitives and combinational blocks|
| [arithmetic](logikbench/arithmetic/README.md) | 33         | Arithmetic operators and datapaths       |
| [memory](logikbench/memory/README.md)         | 13         | Memory structures and storage elements   |
| [blocks](logikbench/blocks/README.md)         | 16         | Complex subsystems and IP blocks         |
| [epfl](logikbench/epfl/README.md)             | 19         | EPFL arithmetic and control benchmarks   |

## Benchmark Inventory

### Basic Logic (22 benchmarks)

| Benchmark | Description | Verilog |
|-----------|-------------|---------|
| arbfix | Fixed-priority arbiter | [arbfix.v](logikbench/basic/arbfix/rtl/arbfix.v) |
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
| ramdp | Dual-port RAM | [ramdp.v](logikbench/memory/ramdp/rtl/ramdp.v) |
| ramsdp | Simple dual-port RAM | [ramsdp.v](logikbench/memory/ramsdp/rtl/ramsdp.v) |
| ramsp | Single-port RAM | [ramsp.v](logikbench/memory/ramsp/rtl/ramsp.v) |
| ramspnc | Single-port RAM (no change) | [ramspnc.v](logikbench/memory/ramspnc/rtl/ramspnc.v) |
| regfile | Register file | [regfile.v](logikbench/memory/regfile/rtl/regfile.v) |
| rom | Read-only memory | [rom.v](logikbench/memory/rom/rtl/rom.v) |

### Complex Blocks (16 benchmarks)

| Benchmark | Description | Verilog |
|-----------|-------------|---------|
| aes | AES encryption | [aes.v](logikbench/blocks/aes/rtl/aes.v) |
| apbregs | APB register block | [apbregs.v](logikbench/blocks/apbregs/rtl/apbregs.v) |
| axicrossbar | AXI crossbar | [axi_crossbar.v](logikbench/blocks/axicrossbar/rtl/axi_crossbar.v) |
| ethmac | Ethernet MAC | [ethmac.v](logikbench/blocks/ethmac/rtl/ethmac.v) |
| fft | Fast Fourier Transform | [fft.v](logikbench/blocks/fft/rtl/fft.v) |
| firfix | Fixed-point FIR filter | [firfix.v](logikbench/blocks/firfix/rtl/firfix.v) |
| firprog | Programmable FIR filter | [firprog.v](logikbench/blocks/firprog/rtl/firprog.v) |
| fpu32 | 32-bit floating-point unit | [fpu.v](logikbench/blocks/fpu32/rtl/fpu.v) |
| fpu64 | 64-bit floating-point unit | [ct_vfdsu_double.v](logikbench/blocks/fpu64/rtl/ct_vfdsu_double.v) |
| i2c | I2C controller | [i2c.v](logikbench/blocks/i2c/rtl/i2c.v) |
| ialu | Integer ALU | [ialu.v](logikbench/blocks/ialu/rtl/ialu.v) |
| lfsr | Linear feedback shift register | [lfsr.v](logikbench/blocks/lfsr/rtl/lfsr.v) |
| picorv32 | PicoRV32 RISC-V core | [picorv32.v](logikbench/blocks/picorv32/rtl/picorv32.v) |
| serv | SERV bit-serial RISC-V core | [serv_top.v](logikbench/blocks/serv/rtl/serv_top.v) |
| uart | UART | [uart.v](logikbench/blocks/uart/rtl/uart.v) |
| umiregs | UMI register block | [umiregs.v](logikbench/blocks/umiregs/rtl/umiregs.v) |

### EPFL Benchmarks (19 benchmarks)

| Benchmark | Description | Verilog |
|-----------|-------------|---------|
| adder | EPFL adder benchmark | [adder.v](logikbench/epfl/adder/rtl/adder.v) |
| arbiter | EPFL arbiter benchmark | [arbiter.v](logikbench/epfl/arbiter/rtl/arbiter.v) |
| bar | Barrel shifter | [bar.v](logikbench/epfl/bar/rtl/bar.v) |
| cavlc | CAVLC encoder | [cavlc.v](logikbench/epfl/cavlc/rtl/cavlc.v) |
| dec | Decoder | [dec.v](logikbench/epfl/dec/rtl/dec.v) |
| div | Divider | [div.v](logikbench/epfl/div/rtl/div.v) |
| hyp | Hypotenuse calculator | [hyp.v](logikbench/epfl/hyp/rtl/hyp.v) |
| i2c | I2C controller | [i2c.v](logikbench/epfl/i2c/rtl/i2c.v) |
| int2float | Integer to float converter | [int2float.v](logikbench/epfl/int2float/rtl/int2float.v) |
| log2 | Log base 2 | [log2.v](logikbench/epfl/log2/rtl/log2.v) |
| max | Maximum | [max.v](logikbench/epfl/max/rtl/max.v) |
| mem_ctrl | Memory controller | [mem_ctrl.v](logikbench/epfl/mem_ctrl/rtl/mem_ctrl.v) |
| multiplier | Multiplier | [multiplier.v](logikbench/epfl/multiplier/rtl/multiplier.v) |
| priority | Priority encoder | [priority.v](logikbench/epfl/priority/rtl/priority.v) |
| router | Router | [router.v](logikbench/epfl/router/rtl/router.v) |
| sin | Sine function | [sin.v](logikbench/epfl/sin/rtl/sin.v) |
| sqrt | Square root | [sqrt.v](logikbench/epfl/sqrt/rtl/sqrt.v) |
| square | Square function | [square.v](logikbench/epfl/square/rtl/square.v) |
| voter | Voter circuit | [voter.v](logikbench/epfl/voter/rtl/voter.v) |

## Usage

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
### Prerequisites

You will need properly installed synthesis tools installed to run benchmarks. Follow the install instructions for indidivual repos to properly install plugins.
There is no dependency linkage between yosys and plugins. The recommendation is to isntall everything cleanly and to use versions from main.
In Ubuntu, shared yosys libraries are placed at /usr/local/share/yosys/plugins/*.so

* [Yosys](https://github.com/YosysHQ/yosys) - Open-source synthesis tool
* [Yosys-slang](https://github.com/povik/yosys-slang) - SystemVerilog frontend plugin
* [Wildebeest](https://github.com/zeroasiccorp/wildebeest)

## Installation

Install logikbench via PyPI:

```bash
pip install logikbench
```

Developers should clone the repo and install package locally as shown below.

```bash
git clone https://github.com/zeroasiccorp/logikbench
cd logikbench
pip install --upgrade pip
pip install -e .
```

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
`cells`, `cellarea`, `fmax`, `setupslack` for ASIC.

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

### Examples

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

## Contributing

Contributions are welcome! To contribute:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/new-benchmark`)
3. Add your benchmark following the existing structure
4. Ensure your code passes linting (`flake8`)
5. Add tests for your benchmark
6. Submit a pull request

When adding new benchmarks:
* Use parameterizable Verilog for flexibility
* Include a Python wrapper class inheriting from `Design`
* Add documentation and test cases
* Follow the naming conventions in existing benchmarks

## Support

* **Issues**: [GitHub Issues](https://github.com/zeroasiccorp/logikbench/issues)
* **Discussions**: [GitHub Discussions](https://github.com/zeroasiccorp/logikbench/discussions)
* **Documentation**: See individual benchmark READMEs in each category folder

## License

The LogikBench project is licensed under the [MIT](LICENSE) license unless specified otherwise inside the individual benchmark folders.
