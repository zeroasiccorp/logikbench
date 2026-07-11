# ISCAS'85 Benchmarks

The ISCAS'85 suite is a set of ten (commonly counted as eleven, including the
trivial `c17`) combinational gate-level benchmark circuits released by Franc
Brglez and Hideo Fujiwara at the 1985 IEEE International Symposium on Circuits
and Systems. They were distributed as a "neutral netlist" (gate-level,
technology independent) so that the test, synthesis, and physical-design
communities could compare tools on a common, reproducible set of circuits. They
remain one of the most widely cited hardware benchmark suites in EDA.

Every circuit is purely combinational (no state), built from primitive logic
gates. Sizes range from the 6-gate `c17` up to `c7552`.

## Origin and License

The original ISCAS'85 netlists predate the modern open-source movement: they
carry **no formal open-source license** (MIT, Apache, GPL, etc.). Brglez and
Fujiwara released them as a **public utility to the EDA community**, freely
available to anyone (originally over FTP). They are best characterized as
**public domain / free for academic and commercial use**, and are treated as
uncopyrighted academic data here.

Because no license text exists for the raw circuits, this directory ships **no
`LICENSE` file** -- there is nothing to copy. Provenance is documented instead,
per the References below. (Note: some modern redistributions that *modify* the
circuits -- e.g. Trojan-inserted or ML-graph variants -- apply their own MIT or
Creative Commons license to those modifications; that does not apply here, as
these are the unmodified structural netlists.)

## Provenance

The Verilog netlists vendored here are the unmodified, technology-independent
gate-level circuits (primitive `and`/`nand`/`nor`/`not`/... gates) originally
published in the reference below. They were obtained from the TalTech benchmark
mirror (public domain, no license attached):

* Source: https://pld.ttu.ee/~maksim/benchmarks/iscas85/verilog/
* Retrieved: 2026-07-03

`c880` uses the primitive-gate variant (`c880a.v` on the mirror); the mirror's
base `c880.v` is a cell-library-mapped netlist that references undefined cells
and does not synthesize standalone. All other circuits are the base `.v` files.

## Timing constraints (SDC)

ISCAS'85 circuits are combinational and have no clock port, so LogikBench's
shared `logikbench/targets/default.sdc` constrains them with a virtual clock
(input-to-output paths timed at the `--clk` period). No per-benchmark SDC is
required.

## Benchmark Listing

| Circuit | Function                                             |
|---------|------------------------------------------------------|
| c17     | Trivial 6-gate circuit (smoke test)                  |
| c432    | 27-channel interrupt controller (priority decoder)   |
| c499    | 32-bit single-error-correcting (SEC) circuit         |
| c880    | 8-bit ALU                                            |
| c1355   | 32-bit single-error-correcting (SEC) circuit         |
| c1908   | 16-bit single-error-correcting/double-detecting      |
| c2670   | 12-bit ALU and controller                            |
| c3540   | 8-bit ALU                                            |
| c5315   | ALU with parity                                      |
| c6288   | 16x16 combinational multiplier                       |
| c7552   | 32-bit adder/comparator                              |

Functional interpretations follow the reverse-engineering study by Hansen,
Yalcin, and Hayes (see References); the original release treated the circuits as
neutral netlists without documented function.

## How to Cite

If you use the ISCAS'85 benchmarks, please cite the original work:

```bibtex
@inproceedings{brglez1985iscas85,
  title={A Neutral Netlist of 10 Combinational Benchmark Circuits and a Target Translator in Fortran},
  author={Brglez, Franc and Fujiwara, Hideo},
  booktitle={Proc. IEEE International Symposium on Circuits and Systems (ISCAS)},
  pages={663--698},
  year={1985}
}
```

## References

### Algorithm / origin

* F. Brglez and H. Fujiwara, "A Neutral Netlist of 10 Combinational Benchmark
  Circuits and a Target Translator in Fortran," in Proc. IEEE International
  Symposium on Circuits and Systems (ISCAS), Kyoto, Japan, May 1985,
  pp. 663-698.

### Circuit function / reverse engineering

* M. C. Hansen, H. Yalcin, and J. P. Hayes, "Unveiling the ISCAS-85 Benchmarks:
  A Case Study in Reverse Engineering," IEEE Design & Test of Computers,
  vol. 16, no. 3, pp. 72-80, 1999. DOI: 10.1109/54.785838.

### Format reference

* ISCAS benchmark format manual, USC SPORT-lab:
  https://sportlab.usc.edu/~msabrishami/benchmarks.html
