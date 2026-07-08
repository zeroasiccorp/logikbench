# fmadd32

**Source:** [rtl/fmadd32.v](rtl/fmadd32.v)

Single-precision (fp32) fused multiply-add: `r = round(a*b + c)`, computed as a
single fused operation with one rounding step. This is the base block; the
reduced-precision tops `fmadd16` (bf16) and `fmadd8` (E4M3) instantiate the
same datapath with overridden parameters.

## What it is

`fmadd32` is a thin top wrapper (fixed to the fp32 field layout by its default
parameters `EXP=8`, `MANT=23`) around a common, parametrized `fmadd` datapath.
The datapath:

1. multiplies the two significands to full width (product is not rounded);
2. aligns the addend to the product by exponent difference;
3. adds/subtracts the aligned significands (effective sign from the operands);
4. normalizes via a leading-one search;
5. rounds once, round-to-nearest-even (RNE), and packs the result.

Being *fused*, the product keeps full precision through the add and only the
final result is rounded. The unit is IEEE-754-like but simplified for a
synthesis benchmark: subnormals are flushed to zero (FTZ) on input and output,
and Inf/NaN are handled with simplified rules (Inf*0 and Inf-Inf give NaN, NaN
propagates). It is accurate to ~1 ulp and is not a fully IEEE-754-compliant FPU.

Format: 1 sign / 8 exponent / 23 mantissa bits (bias 127).

## Interface

| Signal | Dir | Width | Description                 |
|--------|-----|-------|-----------------------------|
| `a`    | in  | 32    | multiplicand (fp32)         |
| `b`    | in  | 32    | multiplier (fp32)           |
| `c`    | in  | 32    | addend (fp32)               |
| `r`    | out | 32    | `round(a*b + c)`, fused     |

## Synthesis mapping / what it stresses

- **Wide significand multiplier:** the 24x24 mantissa product maps to hard DSP
  blocks (or a large LUT multiplier on fabrics without them).
- **Barrel shifters:** exponent-difference alignment and post-normalize shifts
  exercise wide muxing / shift logic.
- **Leading-one detect + carry adds:** normalization and the significand adder
  exercise priority-encode and carry logic.

## References

### Algorithm / standard

- IEEE Std 754-2019, *IEEE Standard for Floating-Point Arithmetic*. Defines the
  fusedMultiplyAdd operation and round-to-nearest-even used here.
- B. Parhami, *Computer Arithmetic: Algorithms and Hardware Designs*, 2nd ed.,
  Oxford University Press, 2010. Floating-point representation, rounding, and
  arithmetic.

### Hardware implementation

- E. Hokenek, R. K. Montoye, P. W. Cook, "Second-Generation RISC Floating Point
  with Multiply-Add Fused," IEEE Journal of Solid-State Circuits, vol. 25,
  no. 5, pp. 1207-1213, 1990. The fused multiply-add datapath (full-width
  product, single alignment/normalize/round) this design follows.

### Provenance

Original implementation written for LogikBench. It follows the standard fused
multiply-add architecture in the references above and is not copied from any
specific HDL source.

## Testbench

`testbench/test_fmadd32_smoke.v` is a Verilog-2005 self-checking testbench. It
drives random operands, computes a reference `a*b+c` in Verilog `real`,
compares the RTL result within 1 ulp (modeling FTZ), and prints
`PASSED` / `FAILED`.
