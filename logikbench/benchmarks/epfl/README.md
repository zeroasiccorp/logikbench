# EPFL Benchmarks

The EPFL Combinational Benchmark Suite was introduced in 2015 with the aim of defining a new comparative standard for the logic optimization and synthesis community. It originally consisted of 23 combinational circuits designed to challenge modern logic optimization tools. The benchmark suite is divided into arithmetic, random/control and MtM circuits, and each circuit is distributed in Verilog, VHDL, BLIF and AIGER formats.

The EPFL benchmarks were copied over to LogikBench to simplify dependency management. The decision to copy over the EPFL files (rather than linking to it) was justified by the static nature of the benchmark suite. You can access the original files here:

* Repository: https://github.com/lsils/benchmarks
* Commit:  94e25f33b9bcbaa155e20ceedc6f6dc45bdffddf

## Benchmark Listing

| Benchmark         | Upstream | Description                 |
|-------------------|----------|-----------------------------|
| adder        | adder    | 128-bit adder               |
| arbiter      | arbiter  | Arbiter                     |
| bar          | bar      | Barrel shifter              |
| cavlc        | cavlc    | CAVLC encoder               |
| dec          | dec      | Decoder                     |
| div          | div      | Divider                     |
| hyp          | hyp      | Hypotenuse calculator       |
| i2c          | i2c      | I2C controller              |
| int2float    | int2float | Integer-to-float converter |
| log2         | log2     | Log base 2                  |
| max          | max      | Maximum                     |
| memctrl      | mem_ctrl | Memory controller           |
| multiplier   | multiplier | Multiplier                |
| priority     | priority | Priority encoder            |
| router       | router   | Router                      |
| sin          | sin      | Sine function               |
| sqrt         | sqrt     | Square root                 |
| square       | square   | Square function             |
| voter        | voter    | Voter circuit               |

## Modifications

The RTL logic is unchanged. Two name changes:

1. **`mem_ctrl` normalized to `memctrl`** (folder, file, and top module) so the
   identifier is a single token.
2. **`priority` top module renamed to `priority_encoder`** -- `priority` is a
   reserved SystemVerilog keyword, so slang (LogikBench lints in SV mode)
   rejects a module named `priority`. The benchmark name stays `priority`; only
   the RTL module and the design's top-module setting use `priority_encoder`.

All other circuits keep their upstream file and top-module name (e.g. `adder.v`
/ `module adder`).

## How to Cite

If you use the EPFL benchmarks, please cite the original work:

L. Amaru, P.-E. Gaillardon, and G. De Micheli, "The EPFL Combinational Benchmark
Suite," in Proc. 24th International Workshop on Logic & Synthesis (IWLS), 2015.

```bibtex
@inproceedings{amaru2015epfl,
  title={The EPFL Combinational Benchmark Suite},
  author={Amar{\'u}, Luca and Gaillardon, Pierre-Emmanuel and De Micheli, Giovanni},
  booktitle={Proceedings of the 24th International Workshop on Logic \& Synthesis (IWLS)},
  year={2015}
}
```
