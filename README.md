LogikBench
==========================================================

LogikBench is a technology agnostic RTL design benchmark suite leveraging the SiliconCompiler project to automate running RTL benchmarks to a diverse set of compiler targets.

LogikBench was designed to be used for:
- EDA tool benchmarking (synthesis, placement, routing,...)
- Foundry process benchmarking
- Standard cell library benchmarking
- FPGA device benchmarking

# Benchmark Expansion

To propose a new benchmark for inclusion, edit the ./docs/benchmarks.csv file and submit a PR.


**Install from source**

```bash
git clone https://github.com/zeroasiccorp/logikbench
cd logikbench
python3 -m pip install -e .
```

## Step2: Install preq-requisites

You will need to install any binary tools required by the target. The easiest way to do this is via sc-install. For example, to install yosys,

```bash
sc-install yosys
```

## Step3: Run a benchmark

```bash
lb -b mult -m cellarea -to syn
```

## License

The main LogikBench project is licended under [MIT](LICENSE). Individual benchmark components are covered by licensed documented by the LICENSE file found in the root directory of each benchmark.
