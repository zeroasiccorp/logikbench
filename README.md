LogicBenchy
==========================================================

LogicBenchy is a technology agnostic RTL design benchmark suite leveraging the SiliconCompiler project to automate running RTL benchmarks to a diverse set of compiler targets.

The LogicBenchy project was designed to address inaccurate:
- strawman spreadsheets used by ASIC and FPGA system architects
- single value gate-density numbers provided by foundries
- back of the envelope process scaling estimations
- non-standard vendor IP benchmarks with a long list of footnotes
- non-stardard vendor tool benchmarks bound by NDAs

**!!NOTE!!**

Each benchmark must be self contained with zero external dependencies and runnable via SiliconCompiler

# Quickstart Guide

## Step1: Install Python package

**Install from PyPI**
```bash
python3 -m pip install --upgrade logicbenchy
```

(or)

**Install from source**

```bash
git clone https://github.com/zeroasiccorp/logicbenchy
cd logicbenchy
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

The main LogicBenchy project is licended under [MIT](LICENSE). Individual benchmark components are covered by licensed documented by the LICENSE file found in the root directory of each benchmark.
