# LogikBench

[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Python Version](https://img.shields.io/badge/python-3.10+-blue.svg)](https://www.python.org/downloads/)
[![PyPI](https://img.shields.io/pypi/v/logikbench.svg)](https://pypi.org/project/logikbench/)
[![CI](https://github.com/zeroasiccorp/logikbench/actions/workflows/ci.yml/badge.svg)](https://github.com/zeroasiccorp/logikbench/actions)
[![Downloads](https://static.pepy.tech/badge/logikbench)](https://pepy.tech/project/logikbench)

**119 parametrized RTL benchmarks for unbiased EDA evaluation**

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
| [blocks](logikbench/blocks/README.md)         | 31         | Complex subsystems and IP blocks         |
| [epfl](logikbench/epfl/README.md)             | 20         | EPFL arithmetic and control benchmarks   |

## Benchmark Inventory

### Basic Logic (22 benchmarks)

| Benchmark | Description | Verilog |
|-----------|-------------|---------|
| arbiter | Priority arbiter | [arbiter.v](logikbench/basic/arbiter/rtl/arbiter.v) |
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
| axiram | AXI RAM interface | [axiram.v](logikbench/memory/axiram/rtl/axiram.v) |
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

### Complex Blocks (31 benchmarks)

| Benchmark | Description | Verilog |
|-----------|-------------|---------|
| aes | AES encryption | [aes.v](logikbench/blocks/aes/rtl/aes.v) |
| apbregs | APB register block | [apbregs.v](logikbench/blocks/apbregs/rtl/apbregs.v) |
| axicrossbar | AXI crossbar | [axicrossbar.v](logikbench/blocks/axicrossbar/rtl/axicrossbar.v) |
| axidev | AXI device | [axidev.v](logikbench/blocks/axidev/rtl/axidev.v) |
| axihost | AXI host | [axihost.v](logikbench/blocks/axihost/rtl/axihost.v) |
| conv2d | 2D convolution engine | [conv2d.v](logikbench/blocks/conv2d/rtl/conv2d.v) |
| en8b10b | 8b/10b encoder | [en8b10b.v](logikbench/blocks/en8b10b/rtl/en8b10b.v) |
| ethmac | Ethernet MAC | [ethmac.v](logikbench/blocks/ethmac/rtl/ethmac.v) |
| fft | Fast Fourier Transform | [fft.v](logikbench/blocks/fft/rtl/fft.v) |
| firfix | Fixed-point FIR filter | [firfix.v](logikbench/blocks/firfix/rtl/firfix.v) |
| firprog | Programmable FIR filter | [firprog.v](logikbench/blocks/firprog/rtl/firprog.v) |
| fpu32 | 32-bit floating-point unit | [fpu32.v](logikbench/blocks/fpu32/rtl/fpu32.v) |
| fpu64 | 64-bit floating-point unit | [fpu64.v](logikbench/blocks/fpu64/rtl/fpu64.v) |
| hamming | Hamming encoder/decoder | [hamming.v](logikbench/blocks/hamming/rtl/hamming.v) |
| i2c | I2C controller | [i2c.v](logikbench/blocks/i2c/rtl/i2c.v) |
| ialu | Integer ALU | [ialu.v](logikbench/blocks/ialu/rtl/ialu.v) |
| ibex | Ibex RISC-V core | [ibex.v](logikbench/blocks/ibex/rtl/ibex.v) |
| lfsr | Linear feedback shift register | [lfsr.v](logikbench/blocks/lfsr/rtl/lfsr.v) |
| matmul | Matrix multiplication | [matmul.v](logikbench/blocks/matmul/rtl/matmul.v) |
| median3x3 | 3x3 median filter | [median3x3.v](logikbench/blocks/median3x3/rtl/median3x3.v) |
| nvdla | NVIDIA Deep Learning Accelerator | [nvdla.v](logikbench/blocks/nvdla/rtl/nvdla.v) |
| ofdm | OFDM modulator | [ofdm.v](logikbench/blocks/ofdm/rtl/ofdm.v) |
| picorv32 | PicoRV32 RISC-V core | [picorv32.v](logikbench/blocks/picorv32/rtl/picorv32.v) |
| sad8x8 | 8x8 sum of absolute differences | [sad8x8.v](logikbench/blocks/sad8x8/rtl/sad8x8.v) |
| serv | SERV bit-serial RISC-V core | [serv.v](logikbench/blocks/serv/rtl/serv.v) |
| sobel3x3 | 3x3 Sobel filter | [sobel3x3.v](logikbench/blocks/sobel3x3/rtl/sobel3x3.v) |
| spi | SPI controller | [spi.v](logikbench/blocks/spi/rtl/spi.v) |
| uart | UART | [uart.v](logikbench/blocks/uart/rtl/uart.v) |
| umihost | UMI host interface | [umihost.v](logikbench/blocks/umihost/rtl/umihost.v) |
| umiregs | UMI register block | [umiregs.v](logikbench/blocks/umiregs/rtl/umiregs.v) |
| viterbi | Viterbi decoder | [viterbi.v](logikbench/blocks/viterbi/rtl/viterbi.v) |

### EPFL Benchmarks (20 benchmarks)

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

## Installation

The fastest way to start using LogikBench is to install it via PyPI:

```bash
pip install logikbench
```

Developers looking to contribute to the project, should clone the repo and install package locally as shown below.

```bash
git clone https://github.com/zeroasiccorp/logikbench
cd logikbench
pip install --upgrade pip
pip install -e .
```

## Running Benchmarks

LogikBench includes the `lb` command-line tool for batch processing benchmarks.

### Prerequisites

To run benchmarks with the `lb` script, install:

* [Yosys](https://github.com/YosysHQ/yosys) - Open-source synthesis tool
* [Yosys-slang](https://github.com/povik/yosys-slang) - SystemVerilog frontend plugin

### Example

Synthesize all arithmetic benchmarks for iCE40 FPGA and export metrics:

```bash
lb -g arithmetic -t yosys -c synth_ice40 -o results.json
```

Run `lb -h` to see all available options.

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
