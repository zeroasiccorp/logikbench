# EPFL Benchmarks

The EPFL Combinational Benchmark Suite was introduced in 2015 with the aim of defining a new comparative standard for the logic optimization and synthesis community. It originally consisted of 23 combinational circuits designed to challenge modern logic optimization tools. The benchmark suite is divided into arithmetic, random/control and MtM circuits, and each circuit is distributed in Verilog, VHDL, BLIF and AIGER formats.

The EPFL benchmarks were copied over to LogikBench to simplify dependency management. The decision to copy over the EPFL files (rather than linking to it) was justified by the static nature of the benchmark suite. You can access the original files here:

* Repository: https://github.com/lsils/benchmarks
* Commit:  94e25f33b9bcbaa155e20ceedc6f6dc45bdffddf

## Benchmark Listing

| Circuit       | Params | Description             |
|---------------|--------|-------------------------|
| adder         | n/a    | 128b adder
| arbiter       | n/a    |
| bar           | n/a    |
| cavlc         | n/a    |
| dec           | n/a    |
| div           | n/a    |
| hyp           | n/a    |
| i2c           | n/a    |
| int2float     | n/a    |
| log2          | n/a    |
| max           | n/a    |
| mem_ctrl      | n/a    |
| multiplier    | n/a    |
| priority      | n/a    |
| router        | n/a    |
| sin           | n/a    |
| sqrt          | n/a    |
| square        | n/a    |
| voter         | n/a    |
