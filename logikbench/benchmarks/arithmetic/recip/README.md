# recip

**Source:** [rtl/recip.v](rtl/recip.v)

Fixed-point reciprocal `1/x`, computed as a sequential fixed-numerator
division. The multiplicative inverse used by normalization, division-by-
multiply, and rsqrt-style datapaths.

## What it is

`recip` computes `1/X` for an unsigned `Q(DW-QW).QW` input `x` (value
`X = x/2^QW`), producing `1/X` in the same format. Defaults are `DW = 16`,
`QW = 8` (Q8.8). Since `1/X = 2^(2*QW)/x`, it is a restoring division of the
constant numerator `2^(2*QW)` by `x`, run for `NUMW = 2*QW+1` cycles with the
`sqrt`-style valid/busy handshake.

The result is saturated to the `DW`-bit range, so small inputs (including
`x = 0`) saturate to all ones.

## Interface

| Signal      | Dir | Width | Description                          |
|-------------|-----|-------|--------------------------------------|
| `clk`       | in  | 1     | clock                                |
| `nreset`    | in  | 1     | async reset, active low              |
| `in_valid`  | in  | 1     | pulse to latch x and start           |
| `x`         | in  | `DW`  | unsigned input, Q(DW-QW).QW          |
| `out_valid` | out | 1     | pulses when out is valid             |
| `busy`      | out | 1     | high while iterating                 |
| `out`       | out | `DW`  | 1/x in Q(DW-QW).QW, saturated        |

## Synthesis mapping

A restoring divider (a `DW`-bit subtractor/compare, `{rem,quo}` shift register,
counter) with a constant numerator, plus a saturation compare. No DSP, no
BRAM. Latency `2*QW+1` cycles.

## References

### Algorithm / architecture

- B. Parhami, *Computer Arithmetic: Algorithms and Hardware Designs*, 2nd ed.,
  Oxford University Press, 2010. Division and reciprocal computation.

### Hardware implementation

Original implementation. It follows the standard restoring digit-recurrence
divider specialized to a constant numerator; not copied from any specific
source.

## Testbench

`testbench/test_recip_smoke.v` is a Verilog-2005 self-checking testbench that
drives inputs through the handshake, checks `out` exactly against the reference
`2^(2*QW)/x` with saturation, and (for non-saturated mid-range inputs) against
the real-valued `1/X`. It prints `PASSED` / `FAILED`.
