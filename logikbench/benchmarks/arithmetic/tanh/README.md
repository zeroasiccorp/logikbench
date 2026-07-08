# tanh

**Source:** [rtl/tanh.v](rtl/tanh.v)

Hyperbolic-tangent activation `tanh(x)`, implemented as a multiplier-free
piecewise-linear approximation via the identity `tanh(x) = 2*sigmoid(2x) - 1`.
tanh is a common RNN/LSTM activation and the classic squashing nonlinearity.

## What it is

`tanh` approximates `tanh` on a signed fixed-point input `x` in
`Q(DW-QW).QW` format, producing an output in `[-1, 1]` (same format). Defaults
are `DW = 16`, `QW = 8` (Q8.8); `QW >= 5` is required for the segment constants
to be exact.

It reuses the **PLAN** (Piecewise Linear Approximation) sigmoid of Amin,
Curtis, and Hayes-Gill (1997) applied to `2x`, then maps it with
`tanh(x) = 2*sigmoid(2x) - 1`. The sigmoid segment slopes are powers of two
(`1/4`, `1/8`, `1/32`), so every segment is an arithmetic shift plus a constant
add -- **no multiplier**. The `2x` scaling and the final `2*sig - 1` are shifts
and an add. Maximum absolute error is about 0.04 (twice the PLAN sigmoid
error).

## Interface

| Signal | Dir | Width | Description                      |
|--------|-----|-------|----------------------------------|
| `x`    | in  | `DW`  | signed input (Q(DW-QW).QW)       |
| `out`  | out | `DW`  | tanh(x) in [-1,1], same format   |

## Synthesis mapping

- `2x`, `|2x|`, and `2*sig - 1`: shifts and small adders (free/LUT).
- Segment select: a comparator chain on `|2x|` (three thresholds), each segment
  an arithmetic shift plus a constant add.
- LUT-only: no multiplier, no registers, no BRAM.

## References

### Algorithm

- H. Amin, K. M. Curtis, and B. R. Hayes-Gill, "Piecewise linear approximation
  applied to nonlinear function of a neural network," *IEE Proc. Circuits,
  Devices and Systems*, 1997. The PLAN sigmoid used here.
- The identity `tanh(x) = 2*sigmoid(2x) - 1` (standard).

### Hardware implementation

Original implementation. It follows the PLAN piecewise-linear sigmoid mapped to
tanh via the standard identity (power-of-two slopes, shift-and-add segments);
not copied from any specific source.

## Testbench

`testbench/test_tanh_smoke.v` is a Verilog-2005 self-checking testbench. It
drives directed and random inputs, checks `out` exactly against an independent
integer reference (PLAN on `2x`, then `2*sig - 1`), and additionally checks the
result against the true real-valued `tanh` within the approximation error
bound. It prints `PASSED` / `FAILED`.
