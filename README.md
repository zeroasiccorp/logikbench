LogikBench
==========================================================

LogikBench is a parameterized RTL benchmark suite for open and unbiased evaluation of:

1. EDA tools and flows (synthesis, PNR, verification)
2. Foundry processes
3. Cell libraries
4. FPGA device architectures
5. Digital architectures

The benchmark includes over 100 benchmark circuits split into logical groupings.

| Group      | Benchmarks | Description|
|------------|------------|------------|
| basic      | 23         | Logic benchmarks (mux, arbiter, crossbar,...)
| arithmetic | 33         | Arithmetic (add, shift, mul,...)
| memory     | 12         | Memory (sp, dp, sdp, fifo,...)
| blocks     | 30         | Macro functions (ialu, spi ,ibex,..)
| epfl       | 19         | EPFL benchmarks

The LogikBench project addresses a number of gaps in current benchmarks:

 1. Small datasets
 2. Hard coded circuit values
 3. Limited diversity
 4. Lack of execution infrastructure
 5. Hard coded eda flows
 6. Lack of standard scores ("no SpecInt/Dhrystone for EDA")
 7. Lack of standardized metrics
 8. Lack of standard data sets ("no imagenet for EDA")
 9. Lack of provenance (eg. anonymous BLIF circuits)

# Installation

```bash
git clone https://github.com/zeroasiccorp/logikbench
cd logikbench
pip install --upgrade pip
pip install -e .
```

# Prerequisites

If you want to run the benchmarks using the example scripts, you will need to install the required tools and plugins.

* [Yosys](https://github.com/YosysHQ/yosys)
* [Yosys-slang](https://github.com/povik/yosys-slang)
* [Yosys-syn](https://github.com/zeroasiccorp/yosys-syn/)

# Quick Start Guide

```
python examples/synthesis/make.py -g basic -command "synth_fpga" -options -o results.csv
```

## Basic synthesis

The project includes a basic synthesis script that loops over a set of benchmarks and provides a summary of the results as a csv or json file. The script is provided as a reference only. A summary of the synthesis results are placed in build/results.json by default.

To create custom synthesis scripts, extract extensive metric reporting, and to run benchmarks in parallel, you should use the SiliconCompiler flow.

**Run `basic` group**
```sh
python examples/synthesis/make.py -g basic
```

**Run multiple groups**
```sh
python examples/synthesis/make.py -g basic arithmetic
```

**Specify a single benchmark**
```sh
python examples/synthesis/make.py -g arithmetic -n add
```

**Specify name of output file**
```sh
python examples/synthesis/make.py -g arithmetic -n add -o results.csv
```

**Clean up before re-running**
```sh
python examples/synthesis/make.py -g arithmetic -clean
```

# License

The LogikBench project is licensed under [MIT](LICENSE) unless otherwise noted inside the individual benchmarks.
