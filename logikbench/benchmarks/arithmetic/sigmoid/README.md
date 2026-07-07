# sigmoid

Logistic sigmoid activation `sigmoid(x) = 1 / (1 + e^-x)`, implemented as a
multiplier-free piecewise-linear (PLAN) approximation. Sigmoids appear as
gates in LSTMs/GRUs and as the final activation in binary classifiers.

## What it is

`sigmoid` approximates the logistic function on a signed fixed-point input `x`
in `Q(DW-QW).QW` format, producing an output in `[0, 1]` (same format).
Defaults are `DW = 16`, `QW = 8` (Q8.8); `QW >= 5` is required for the segment
constants to be exact.

It uses the **PLAN** (Piecewise Linear Approximation of a Nonlinear function)
sigmoid of Amin, Curtis, and Hayes-Gill (1997), whose segment slopes are all
powers of two:

| range of `|x|`      | approximation          |
|---------------------|------------------------|
| `|x| >= 5.0`        | `1.0`                  |
| `2.375 <= |x| < 5`  | `|x|/32 + 0.84375`     |
| `1.0 <= |x| < 2.375`| `|x|/8  + 0.625`       |
| `0.0 <= |x| < 1.0`  | `|x|/4  + 0.5`         |

Because the slopes are `1/4`, `1/8`, `1/32`, each segment is an arithmetic
shift plus a constant add -- **no multiplier**. The function is evaluated on
`|x|` and mirrored using `sigmoid(-x) = 1 - sigmoid(x)`. Maximum absolute error
of the PLAN approximation is about 0.019.

## Interface

| Signal | Dir | Width | Description                     |
|--------|-----|-------|---------------------------------|
| `x`    | in  | `DW`  | signed input (Q(DW-QW).QW)      |
| `out`  | out | `DW`  | sigmoid(x) in [0,1], same format |

## Synthesis mapping

- Segment select: a small comparator chain on `|x|` (three thresholds).
- Per-segment: an arithmetic right shift (free wiring) and a constant add.
- Absolute value and the `1 - y` mirror: two small adders / negations.
- LUT-only: no multiplier, no registers, no BRAM.

## References

### Algorithm

- M. T. Tommiska, "Efficient digital implementation of the sigmoid function
  for reprogrammable logic," *IEE Proc. Computers and Digital Techniques*,
  2003. Survey of hardware sigmoid approximations.
- H. Amin, K. M. Curtis, and B. R. Hayes-Gill, "Piecewise linear approximation
  applied to nonlinear function of a neural network," *IEE Proc. Circuits,
  Devices and Systems*, 1997. The PLAN approximation used here.

### Hardware implementation

Original implementation. It follows the PLAN piecewise-linear sigmoid
(power-of-two slopes, shift-and-add segments, mirrored about zero) from the
references above; not copied from any specific source.

## Testbench

`testbench/test_sigmoid_smoke.v` is a Verilog-2005 self-checking testbench. It
drives directed and random inputs, checks `out` exactly against an independent
integer reference of the PLAN segments, and additionally checks the result
against the true real-valued sigmoid within the PLAN error bound. It prints
`PASSED` / `FAILED`.
