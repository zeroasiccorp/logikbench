# fmadd8

**Source:** [rtl/fmadd8.v](rtl/fmadd8.v)

8-bit (E4M3 fp8) fused multiply-add: `r = round(a*b + c)`, one fused rounding
step. It reuses the `fmadd32` datapath, overriding its parameters to the E4M3
field layout (1 sign / 4 exponent / 3 mantissa bits, bias 7).

## What it is

`fmadd8` is a fixed 8-bit top that instantiates `fmadd32 #(.EXP(4), .MANT(3))`.
All arithmetic (full-width significand multiply, exponent-difference alignment,
add, leading-one normalize, round-to-nearest-even, flush-to-zero) lives in the
shared datapath documented in the `fmadd32` block; only the format widths
differ. E4M3 is a common 8-bit deep-learning inference/training format (4
exponent, 3 mantissa bits).

As with `fmadd32`, the unit is IEEE-754-like but simplified for a synthesis
benchmark (FTZ subnormals, simplified Inf/NaN, ~1 ulp accuracy).

## Interface

| Signal | Dir | Width | Description                 |
|--------|-----|-------|-----------------------------|
| `a`    | in  | 8     | multiplicand (E4M3 fp8)     |
| `b`    | in  | 8     | multiplier (E4M3 fp8)       |
| `c`    | in  | 8     | addend (E4M3 fp8)           |
| `r`    | out | 8     | `round(a*b + c)`, fused     |

## Synthesis mapping / what it stresses

Same structure as `fmadd32` at minimal width: a 4x4 mantissa multiplier, small
alignment/normalize shifters, and leading-one detect plus carry adds. At this
width the design maps almost entirely to LUTs, exercising the small-operand FP
control/rounding logic rather than DSP blocks.

## References

### Algorithm / standard

- IEEE Std 754-2019, *IEEE Standard for Floating-Point Arithmetic*. Defines the
  fusedMultiplyAdd operation and round-to-nearest-even used here.
- B. Parhami, *Computer Arithmetic: Algorithms and Hardware Designs*, 2nd ed.,
  Oxford University Press, 2010. Floating-point representation and rounding.

### Hardware implementation

- E. Hokenek, R. K. Montoye, P. W. Cook, "Second-Generation RISC Floating Point
  with Multiply-Add Fused," IEEE Journal of Solid-State Circuits, vol. 25,
  no. 5, pp. 1207-1213, 1990. The fused multiply-add datapath this design
  follows (shared with `fmadd32`).

### Provenance

Original implementation written for LogikBench (shares the `fmadd32` datapath);
follows the standard fused multiply-add architecture above and is not copied
from any specific HDL source.

## Testbench

`testbench/test_fmadd8_smoke.v` is a Verilog-2005 self-checking testbench
(real-valued golden, 1 ulp tolerance, FTZ). Compile it together with the
`fmadd32` block RTL, since `fmadd8` instantiates `fmadd32`.
