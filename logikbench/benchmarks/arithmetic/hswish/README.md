# hswish

Hard-swish activation: `out = x * relu6(x + 3) / 6`. A piecewise-polynomial,
multiplier-cheap approximation of swish (`x * sigmoid(x)`), introduced for
MobileNetV3 to get swish-like accuracy without an exponential.

## What it is

`hswish` computes the hard-swish of a signed fixed-point input `x` in
`Q(DW-QW).QW` format. Defaults are `DW = 16`, `QW = 8` (Q8.8). It is evaluated
by region:

- `x <= -3` : `0`
- `x >=  3` : `x`   (the clamp `relu6(x+3)` saturates to 6, so `x*6/6 = x`)
- otherwise : `x * (x + 3) / 6`

Purely combinational. `relu6(y) = clamp(y, 0, 6)` is folded into the region
split, so no explicit clamp is needed. The divide-by-6 is a compile-time
constant division (synthesizes to a multiply-by-reciprocal plus shift).

## Interface

| Signal | Dir | Width | Description                  |
|--------|-----|-------|------------------------------|
| `x`    | in  | `DW`  | signed input (Q(DW-QW).QW)   |
| `out`  | out | `DW`  | hard-swish of `x`, same format |

## Synthesis mapping

At the defaults (`DW=16, QW=8`):

- One `DW x DW` multiplier for `x * (x + 3)` -> FPGA DSP block (or logic).
- A constant divide-by-6 (multiply-by-reciprocal + shift).
- Two signed comparators and a 3-way select for the region logic.
- Combinational; no registers, no BRAM.

## References

### Algorithm

- A. Howard et al., "Searching for MobileNetV3," *ICCV 2019*. Defines
  hard-swish `x * ReLU6(x+3) / 6` as an efficient swish replacement.
- P. Ramachandran, B. Zoph, and Q. V. Le, "Searching for Activation
  Functions," 2017. The swish activation that hard-swish approximates.

### Hardware implementation

Original implementation. It follows the standard region-split evaluation of the
MobileNetV3 hard-swish definition (clamp folded into the regions, constant
divide-by-6); not copied from any specific source.

## Testbench

`testbench/test_hswish_smoke.v` is a Verilog-2005 self-checking testbench. It
drives directed and random inputs, checks `out` exactly against an independent
integer reference of the region formula, and additionally checks the result
against the true real-valued hard-swish within a fixed-point tolerance. It
prints `PASSED` / `FAILED`.
