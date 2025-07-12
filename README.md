LogikBench
==========================================================

An parametrized RTL benchmark suite for open and unbiased evaluation of:
1. EDA tools and flows (synthesis, placement, routing, verification, ...)
2. Foundry processes
3. Standard cell librares
4. FPGA devices
5. Digital architectures

| Group      | Benchmarks | Description|
|------------|------------|------------|
| basic      | 23         | Logic benchmarks (mux, arbiter, crossbar,...)
| arithmetic | 33         | Arithmetic (add, shift, mul,...)
| memory     | 12         | Memory (sp, dp, sdp, fifo,...)
| blocks     | 30         | Macro functions (ialu, spi ,ibex,..)
| epfl       | 19         | EPFL benchmarks

# Installation

```bash
git clone https://github.com/zeroasiccorp/logikbench
cd logikbench
pip install --upgrade pip
pip install -e .
```

# Quick Start Quide

## SiliconCompiler

TBD

## Basic synthesis

The project includes a basic synthesis script that loops over a set of benchmarks and provides a summary of the results as a csv or json file.

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

**Run a single benchmark in vivado**
```sh
python examples/synthesis/make.py -g memory -name ramsp -tool vivado
```

# Benchmark Listing

# License

The LogikBench project is licensed under [MIT](LICENSE). Individual benchmarks are  are covered by licensed documented by the LICENSE file found in the root directory of each benchmark.
