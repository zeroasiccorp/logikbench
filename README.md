LogikBench
==========================================================

LogikBench is a parametrized RTL benchmark suite designed to provide unbiased evaluation of:

1. EDA tools
2. Design flows
3. Foundry processes
4. IP libraries
4. FPGA devices
5. Processing architectures

LogikBench addresses a number of gaps in existing RTL benchmark suites, including:

 1. Small datasets
 2. Hard coded circuit sizes
 3. Limited circuit diversity
 4. Ambiguous licenses
 5. No execution infrastructure
 6. No standard metrics
 7. No standard data sets ("no imagenet for EDA")
 8. No standard scores ("no SpecInt/Dhrystone for EDA")
 9. Limited benchmark provenance ("who wrote it")

LogikBench includes over 100 different parametrized benchmark circuits split into five groupings. The number of groups and total benchmark counts are expected to grow significantly over time.

| Group                                         | Benchmarks | Description|
|-----------------------------------------------|------------|------------|
| [basic](logikbench/basic/README.md)           | 23         | Logic (mux, encoder, arbiter, crossbar, ...)
| [arithmetic](logikbench/arithmetic/README.md) | 33         | Arithmetic (add, shift, mul, ...)
| [memory](logikbench/memory/README.md)         | 12         | Memory (sp, dp, sdp, fifo, ...)
| [blocks](logikbench/blocks/README.md)         | 30         | Subsystems (fpu, spi ,picorv32, ...)
| [epfl](logikbench/epfl/README.md)             | 19         | EPFL benchmarks

When accounting for all possible parameter configurations, the LogikBench suite represents 10K+ unique circuits.

A LogikBench benchmark circuit consists of:
* A set of tech agnostic RTL Verilog files.
* A SiliconCompiler Design object.

The SiliconCompiler design object captures benchmark data as a set of files, parameters, topmodule name (and other settings) grouped together as a `fileset`. Every circuit in the LogikBench suite has a Python setup module that looks similar to the [`mux`](basic/mux/rtl/mux.v) setup code shown below.

```python
from os.path import dirname, abspath
from siliconcompiler.design import DesignSchema

class Mux(DesignSchema):
    def __init__(self):
        name = 'mux'
        fileset = 'rtl'
        rootname = f'{name}_root'
        super().__init__(name)
        self.set_dataroot(rootname, dirname(abspath(__file__)))
        self.add_file(f'rtl/{name}.v', fileset, dataroot=rootname)
        self.set_topmodule(name, fileset)
```

To use one of the benchmark circuits in a program, simply instantiate the circuit object. d you have access to all the methods inherited from SiliconCompiler.  The example below shows how to instantiate the `Mux` circuit in a program and then write out the RTL settings in a standard command format that can be read directly by tools like Icarus, Verilator, and slang.

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

The LogikBench Python package ships with the simple `lb` script for iterating through all the benchmark circuits.

If you want to run the benchmarks using this `lb`script, you will need to install the following required tools and plugins.

* [Yosys](https://github.com/YosysHQ/yosys)
* [Yosys-slang](https://github.com/povik/yosys-slang)
* [Yosys-syn](https://github.com/zeroasiccorp/yosys-syn/)


The example below shows how to use `lb` to synthesize all the circuits in the arithmetic group using the `synth_fpga` command in `yosys` and then output all runtime metrics into a single formatted json file.
```bash
lb -g arithmetic -t yosys -cmd synth_fpga -o results.json
```

Enter `lb -h` to get the full list of options available in the lb script.

## License

The LogikBench project is licensed under the [MIT](LICENSE) license unless specified otherwise inside the individual benchmark folders.
