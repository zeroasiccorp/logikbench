# ISCAS'89 Benchmarks

The ISCAS'89 suite is a collection of sequential gate-level benchmark circuits
released by Franc Brglez, David Bryan, and Krzysztof Kozminski at the 1989 IEEE
International Symposium on Circuits and Systems. It extends the combinational
[ISCAS'85](../iscas85/README.md) set with state: each circuit is a synchronous
sequential netlist of primitive gates plus D flip-flops, intended as a common
reference for sequential test generation, scan insertion, synthesis, and
physical design.

Sizes span roughly three orders of magnitude, from the tiny `s27` (a handful of
flip-flops) to `s38584` (well over a thousand flip-flops). Most of the circuits
are synthesized/anonymous designs profiled combinationally in the original
paper; only a few have a documented high-level function, so this suite is best
treated as a scaling ladder rather than a set of named functional blocks.

## Origin and License

Like ISCAS'85, these netlists predate modern open-source licensing and carry
**no formal open-source license** (MIT, Apache, GPL, etc.). Brglez, Bryan, and
Kozminski released them as a **public utility to the EDA community**, freely
available to anyone. They are treated here as **public domain / free for
academic and commercial use** -- uncopyrighted academic data.

Because no license text exists for the raw circuits, this directory ships **no
`LICENSE` file**. Provenance is documented instead, per the References below.
(Modern redistributions that *modify* the circuits may apply their own MIT or
Creative Commons license to those modifications; that does not apply to the
unmodified structural netlists here.)

## Provenance

The gate-level netlists originate from the public-domain ISCAS'89 release (see
References). The Verilog source files were obtained from the TalTech benchmark
mirror (public domain, no license attached):

* Source: https://pld.ttu.ee/~maksim/benchmarks/iscas89/verilog/
* Retrieved: 2026-07-03

The circuit logic is unmodified, but the original files are not directly
synthesizable, so each was normalized (logic untouched):

* The flip-flop primitive was replaced with an equivalent synthesizable
  behavioral model. The originals model the flop either at switch level
  (simulation-only device primitives) or by wrapping an undefined library cell;
  neither maps in a logic-synthesis flow. The replacement is a positional
  `dff (CK, Q, D)` with `always @(posedge CK) Q <= D;`.
* The unused `GND`/`VDD` power ports were removed from the circuit module (they
  are never referenced internally).
* `s1196` is the one exception where the original `dff` instances carry no
  clock and the module has no clock port; a `CK` input was added and each
  instance rewired to the 3-argument form, making it a proper synchronous
  circuit consistent with the rest of the suite.

This mirror carries the widely distributed 28-circuit subset; the classic
`s208` and `s1494` are not included upstream.

## Timing constraints (SDC)

ISCAS'89 circuits are sequential, and their clock port is named `CK` -- which
does not match the `*clk*`/`*clock*` glob that LogikBench's shared
`logikbench/targets/default.sdc` uses to auto-detect clocks. Each benchmark
therefore ships a small SDC (`sdc/<name>.sdc`) that pins the clock explicitly
and then defers to the shared defaults:

```tcl
set LB_CLK [get_ports CK]
source $LB_DEFAULT_SDC
```

This is the standard per-benchmark customization path documented in the
top-level README's "ASIC Timing Constraints (SDC)" section.

## Benchmark Listing

The 28 circuits vendored here:

`s27`, `s298`, `s344`, `s349`, `s382`, `s386`, `s400`, `s420`, `s444`,
`s510`, `s526`, `s641`, `s713`, `s820`, `s832`, `s838`, `s953`, `s1196`,
`s1238`, `s1423`, `s1488`, `s5378`, `s9234`, `s13207`, `s15850`,
`s35932`, `s38417`, `s38584`.

The numeric suffix approximates the combinational gate count; all circuits are
single-clock (`CK`) synchronous. The largest (`s35932`, `s38417`, `s38584`) are
substantial and may need `--timeout` on slower flows.

## How to Cite

If you use the ISCAS'89 benchmarks, please cite the original work:

```bibtex
@inproceedings{brglez1989iscas89,
  title={Combinational Profiles of Sequential Benchmark Circuits},
  author={Brglez, Franc and Bryan, David and Kozminski, Krzysztof},
  booktitle={Proc. IEEE International Symposium on Circuits and Systems (ISCAS)},
  volume={3},
  pages={1929--1934},
  year={1989}
}
```

## References

### Algorithm / origin

* F. Brglez, D. Bryan, and K. Kozminski, "Combinational Profiles of Sequential
  Benchmark Circuits," in Proc. IEEE International Symposium on Circuits and
  Systems (ISCAS), Portland, OR, USA, May 1989, vol. 3, pp. 1929-1934.
  DOI: 10.1109/ISCAS.1989.100747.

### Format reference

* ISCAS benchmark format manual, USC SPORT-lab:
  https://sportlab.usc.edu/~msabrishami/benchmarks.html
