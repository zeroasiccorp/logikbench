LogikBench
==========================================================

An parametrized RTL benchmark suite for open and unbiased evaluation of:
1. EDA tools and flows (synthesis, placement, routing, verification, ...)
2. Foundry processes
3. Standard cell librares
4. FPGA devices
5. Digital architectures

# Installation

```bash
git clone https://github.com/zeroasiccorp/logikbench
cd logikbench
pip install --upgrade pip
pip install -e .
```

# Quick Start Quide

## Basic synthesis examples

The project includes a basic baremetal script that loops over a set of benchmarks and provides a summary of the results.

**Run `basic` group**
```sh
python examples/baremetal/make.py -g basic
```

**Run multiple groups**
```sh
python examples/baremetal/make.py -g basic arithmetic
```

**Specify a single benchmark**
```sh
python examples/baremetal/make.py -g arithmetic -n add
```

**Specify name of output file**
```sh
python examples/baremetal/make.py -g arithmetic -n add -o results.csv
```

**Clean up before re-running**
```sh
python examples/baremetal/make.py -g arithmetic -clean
```

**Run a single benchmark in vivado**
```sh
python examples/baremetal/make.py -g memory -name ramsp -tool vivado
```

# Benchmark Listing

TBD

# License

The LogikBench project is licensed under [MIT](LICENSE). Individual benchmarks are  are covered by licensed documented by the LICENSE file found in the root directory of each benchmark.
