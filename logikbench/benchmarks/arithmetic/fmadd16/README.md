# fmadd16

bfloat16 (bf16) fused multiply-add: `r = round(a*b + c)`, one fused rounding
step. It reuses the `fmadd32` datapath, overriding its parameters to the bf16
field layout (1 sign / 8 exponent / 7 mantissa bits, bias 127).

## What it is

`fmadd16` is a fixed 16-bit top that instantiates `fmadd32 #(.EXP(8), .MANT(7))`.
All arithmetic (full-width significand multiply, exponent-difference alignment,
add, leading-one normalize, round-to-nearest-even, flush-to-zero) lives in the
shared datapath documented in the `fmadd32` block; only the format widths
differ. bf16 keeps the fp32 exponent range with a 7-bit mantissa, a common
deep-learning training format.

As with `fmadd32`, the unit is IEEE-754-like but simplified for a synthesis
benchmark (FTZ subnormals, simplified Inf/NaN, ~1 ulp accuracy).

## Interface

| Signal | Dir | Width | Description                 |
|--------|-----|-------|-----------------------------|
| `a`    | in  | 16    | multiplicand (bf16)         |
| `b`    | in  | 16    | multiplier (bf16)           |
| `c`    | in  | 16    | addend (bf16)               |
| `r`    | out | 16    | `round(a*b + c)`, fused     |

## Synthesis mapping / what it stresses

Same structure as `fmadd32` at narrower width: an 8x8 mantissa multiplier,
alignment/normalize barrel shifters, and leading-one detect plus carry adds.
The narrower mantissa shifts the LUT/DSP balance relative to `fmadd32`.

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

`testbench/test_fmadd16_smoke.v` is a Verilog-2005 self-checking testbench
(real-valued golden, 1 ulp tolerance, FTZ). Compile it together with the
`fmadd32` block RTL, since `fmadd16` instantiates `fmadd32`.
