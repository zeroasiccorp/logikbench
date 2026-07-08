# lrelu

**Source:** [rtl/lrelu.v](rtl/lrelu.v)

Leaky ReLU activation: `out = (in >= 0) ? in : slope * in`, with a
hardware-friendly power-of-two leak slope `slope = 2^-ASHIFT`. The
non-saturating alternative to `relu` that keeps a small gradient for negative
inputs.

## What it is

`lrelu` passes non-negative inputs through unchanged and scales negative inputs
by `2^-ASHIFT` using an arithmetic right shift (no multiplier). Operands are
signed `DW`-bit fixed-point; defaults are `DW = 16` and `ASHIFT = 7`
(leak slope `1/128` approximately 0.0078, close to the common 0.01). Purely
combinational.

Using a power-of-two slope is the standard efficient hardware realization: the
negative branch is a wired shift plus a sign-select, so the whole activation is
just a comparator, a shift, and a mux.

## Interface

| Signal | Dir | Width | Description                          |
|--------|-----|-------|--------------------------------------|
| `in`   | in  | `DW`  | signed input                         |
| `out`  | out | `DW`  | leaky-ReLU of `in`                   |

## Synthesis mapping

A sign comparator, an arithmetic right shift by the constant `ASHIFT` (free
wiring), and a 2:1 mux. LUT-only; no registers, no DSP, no BRAM.

## References

### Algorithm

- A. L. Maas, A. Y. Hannun, and A. Y. Ng, "Rectifier Nonlinearities Improve
  Neural Network Acoustic Models," *ICML Workshop on Deep Learning for Audio,
  Speech and Language Processing*, 2013. Introduces the leaky ReLU.

### Hardware implementation

Original implementation. It follows the standard power-of-two-slope leaky-ReLU
realization (compare, arithmetic shift, select); not copied from any specific
source.

## Testbench

`testbench/test_lrelu_smoke.v` is a Verilog-2005 self-checking testbench that
drives random signed inputs, compares `out` against the reference
`(in >= 0) ? in : (in >>> ASHIFT)`, and prints `PASSED` / `FAILED`.
