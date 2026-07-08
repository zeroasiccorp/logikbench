# rsqrt

**Source:** [rtl/rsqrt.v](rtl/rsqrt.v)

Fixed-point inverse square root `1/sqrt(x)`, computed in two sequential
digit-recurrence phases (no multiplier). The reciprocal-sqrt used by vector
normalization and RMS/layer-norm.

## What it is

`rsqrt` computes `1/sqrt(X)` for an unsigned `Q(DW-QW).QW` input `x` (value
`X = x/2^QW`), producing the result in the same format. Defaults are
`DW = 16`, `QW = 8` (Q8.8); `QW` and `DW` must be even. Since
`1/sqrt(X) = 2^(3*QW/2)/sqrt(x)`, the block runs two phases:

1. **sqrt** -- `floor(sqrt(x))` via the non-restoring square-root recurrence
   (same as the `sqrt` block), `DW/2` cycles.
2. **divide** -- the constant `2^(3*QW/2)` divided by that root via the
   restoring divider, `3*QW/2+1` cycles.

Both phases are shift-add digit recurrences (no multiplier). `x = 0` saturates
to all ones. Handshake mirrors the `sqrt` block.

## Interface

| Signal      | Dir | Width | Description                          |
|-------------|-----|-------|--------------------------------------|
| `clk`       | in  | 1     | clock                                |
| `nreset`    | in  | 1     | async reset, active low              |
| `in_valid`  | in  | 1     | pulse to latch x and start           |
| `x`         | in  | `DW`  | unsigned input, Q(DW-QW).QW          |
| `out_valid` | out | 1     | pulses when out is valid             |
| `busy`      | out | 1     | high while iterating                 |
| `out`       | out | `DW`  | 1/sqrt(x) in Q(DW-QW).QW, saturated  |

## Synthesis mapping

A square-root recurrence (adder/compare + shifts) followed by a restoring
divider (adder/compare + shift register), sharing a small controller. No DSP,
no BRAM. Latency `DW/2 + 3*QW/2 + 1` cycles. Accuracy is limited by the
`floor(sqrt)` step (a few percent).

## References

### Algorithm / architecture

- B. Parhami, *Computer Arithmetic: Algorithms and Hardware Designs*, 2nd ed.,
  Oxford University Press, 2010. Digit-recurrence square root and division.

### Hardware implementation

Original implementation. It follows standard digit-recurrence square root
followed by a constant division (both shift-add); not copied from any specific
source.

## Testbench

`testbench/test_rsqrt_smoke.v` is a Verilog-2005 self-checking testbench that
drives inputs through the handshake, checks `out` exactly against the reference
`2^(3*QW/2)/floor(sqrt(x))` (with the x=0 saturation), and (for mid-range
inputs) against the real-valued `1/sqrt(X)`. It prints `PASSED` / `FAILED`.
