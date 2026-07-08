# exp

**Source:** [rtl/exp.v](rtl/exp.v)

Exponential `e^x` via range reduction plus a polynomial. The standard
hardware / math-library method for exp: split off a power-of-two factor (a
shift) and approximate the small remaining fraction with a polynomial.

## What it is

`exp` computes `e^x` for a signed fixed-point input `x` in `Q(DW-QW).QW`
format, saturating the result into the signed output range. Defaults are
`DW = 16`, `QW = 8` (Q8.8).

Method:

```
e^x = 2^(x*log2e) = 2^k * 2^f
```

where `k = floor(x*log2e)` (an integer, applied as a shift) and `f` is the
fractional part in `[0,1)`. `2^f` is evaluated with a cubic polynomial (the
Taylor series of `2^f`: `1 + ln2*f + (ln2^2/2)*f^2 + (ln2^3/6)*f^3`) in
Horner form. The `2^k` factor is a left shift (`k>=0`) or right shift (`k<0`).

The result is **saturated**: large `x` clamps to the maximum output, and very
negative `x` flushes to 0. At Q8.8 the accuracy is a few percent (relative).

## Interface

| Signal | Dir | Width | Description                          |
|--------|-----|-------|--------------------------------------|
| `x`    | in  | `DW`  | signed input, Q(DW-QW).QW            |
| `out`  | out | `DW`  | e^x, saturated, same format          |

## Synthesis mapping

At the defaults (`DW=16, QW=8`):

- One multiplier for `x*log2e` plus three for the Horner polynomial -> FPGA DSP
  blocks (or logic on ASIC). This is the DSP-heavy transcendental counterpart
  to the shift-add CORDIC blocks (`cos`/`atan`).
- A variable shift (barrel shifter) for the `2^k` scaling, and saturation
  comparators.
- Combinational; no registers, no BRAM.

## References

### Algorithm / architecture

- J.-M. Muller, *Elementary Functions: Algorithms and Implementation*, 3rd ed.,
  Birkhauser, 2016. Range reduction and polynomial evaluation of exp/log.
- P. T. P. Tang, "Table-driven implementation of the exponential function in
  IEEE floating-point arithmetic," *ACM TOMS*, 1989. The `2^k * 2^f`
  decomposition.

### Hardware implementation

Original implementation. It follows the standard range-reduction-plus-polynomial
exponential (`2^k` shift, `2^f` Horner polynomial, saturation); not copied from
any specific source.

## Testbench

`testbench/test_exp_smoke.v` is a Verilog-2005 self-checking testbench. It
drives directed and random inputs, checks `out` exactly against an independent
integer reference of the datapath (including saturation), and additionally
checks the non-saturated results against the real-valued `$exp` within a
relative tolerance. It prints `PASSED` / `FAILED`.
