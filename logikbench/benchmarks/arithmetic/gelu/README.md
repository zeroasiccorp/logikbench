# gelu

Gaussian Error Linear Unit `GELU(x) = x * Phi(x)`, implemented with the
sigmoid approximation `GELU(x) ~= x * sigmoid(1.702 x)`. GELU is the default
activation in transformer models (BERT, GPT).

## What it is

`gelu` approximates GELU on a signed fixed-point input `x` in `Q(DW-QW).QW`
format. Defaults are `DW = 16`, `QW = 8` (Q8.8); `QW >= 5` is required for the
segment constants to be exact.

It uses the well-known **sigmoid approximation** of GELU,
`x * sigmoid(1.702 x)`, with the inner sigmoid computed by the **PLAN**
piecewise-linear approximation (Amin/Curtis/Hayes-Gill 1997, power-of-two
slopes). The datapath is: scale by the constant `1.702`, PLAN-sigmoid, then
multiply by `x`. This is a double approximation (sigmoid-form GELU plus PLAN
sigmoid), so its error against true GELU is larger than the pure PLAN blocks.

## Interface

| Signal | Dir | Width | Description                  |
|--------|-----|-------|------------------------------|
| `x`    | in  | `DW`  | signed input (Q(DW-QW).QW)   |
| `out`  | out | `DW`  | GELU(x), same format         |

## Synthesis mapping

At the defaults (`DW=16, QW=8`):

- Two `DW x DW` multipliers: `1.702*x` (constant multiply) and `x*sigmoid`.
  These map to FPGA DSP blocks (or logic on ASIC).
- The PLAN sigmoid core: a comparator chain plus shift-and-add segments (LUT).
- Combinational; no registers, no BRAM.

## References

### Algorithm

- D. Hendrycks and K. Gimpel, "Gaussian Error Linear Units (GELUs)," 2016.
  Defines GELU and the sigmoid approximation `x * sigmoid(1.702 x)`.
- H. Amin, K. M. Curtis, and B. R. Hayes-Gill, "Piecewise linear approximation
  applied to nonlinear function of a neural network," *IEE Proc. Circuits,
  Devices and Systems*, 1997. The PLAN sigmoid used for the inner sigmoid.

### Hardware implementation

Original implementation. It follows the sigmoid-approximation GELU with a PLAN
piecewise-linear inner sigmoid (constant scale, shift-and-add sigmoid, final
multiply); not copied from any specific source.

## Testbench

`testbench/test_gelu_smoke.v` is a Verilog-2005 self-checking testbench. It
drives directed and random inputs, checks `out` exactly against an independent
integer reference of the datapath, and additionally checks the result against
the true real-valued GELU within a (generous) tolerance reflecting the double
approximation. It prints `PASSED` / `FAILED`.
