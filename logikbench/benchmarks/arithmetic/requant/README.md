# requant

**Source:** [rtl/requant.v](rtl/requant.v)

Requantization: scale a wide accumulator down to a narrow, saturated output --
`out = saturate( round( (acc * scale) >> shift ) )`. This is the output stage
of every quantized neural-network layer, converting an `int32` MAC result back
to `int8` for the next layer.

## What it is

`requant` takes a wide signed accumulator `acc`, multiplies it by a
fixed-point `scale`, arithmetic-right-shifts by a runtime `shift`, rounds, and
saturates the result into a narrow signed output. Defaults: `IW = 32`
(int32 accumulator), `MW = 16` (scale), `SHW = 6` (shift 0..63), `OW = 8`
(int8 output). Purely combinational.

The `(scale, shift)` pair encodes the per-tensor requantization factor: a real
scale `S = M0 * 2^-shift` is represented by the integer multiplier `scale`
(= `M0`) and the right shift. Because both are runtime inputs, the design
exercises a full-width multiplier plus a variable barrel shifter, not just a
fixed shift.

### Rounding

Rounding is **round-half-away-from-zero** on the discarded low bits: values
above the halfway point round up, below round down, and exact ties round away
from zero (a positive product rounds up, a negative product rounds down). This
is the TFLite / gemmlowp convention (`MultiplyByQuantizedMultiplier`), so the
block matches what deployed int8 inference actually computes. (The suite's
generic `round` block instead uses round-half-to-even; both are valid, but
away-from-zero is the ML-inference standard modeled here.)

### Saturation

The rounded value is clamped symmetrically into the signed `OW`-bit range
`[-2^(OW-1), 2^(OW-1)-1]` (for int8: `[-128, +127]`).

## Interface

| Signal  | Dir | Width | Description                             |
|---------|-----|-------|-----------------------------------------|
| `acc`   | in  | `IW`  | wide signed accumulator (e.g. int32)    |
| `scale` | in  | `MW`  | signed fixed-point multiplier           |
| `shift` | in  | `SHW` | arithmetic right-shift amount           |
| `out`   | out | `OW`  | rounded, saturated result (e.g. int8)   |

## Synthesis mapping

At the defaults (`IW=32, MW=16, OW=8`):

- One signed `IW x MW` (32x16) multiplier -> maps to FPGA DSP block(s) or an
  ASIC multiplier array.
- A variable barrel shifter (`shift` runtime) on the `PW = IW+MW` = 48-bit
  product.
- Rounding logic: a mask/compare of the discarded bits plus a conditional
  increment (LUT/carry logic).
- Saturation: two signed comparators and a 3-way select.
- Combinational; no registers, no BRAM.

## References

### Algorithm

- B. Jacob et al., "Quantization and Training of Neural Networks for Efficient
  Integer-Arithmetic-Only Inference," *CVPR 2018*. Per-tensor requantization
  via an integer multiplier and right shift.
- gemmlowp (Google low-precision GEMM library), "Quantization" doc. The
  multiplier-plus-shift downscale of int32 accumulators.
- B. Parhami, *Computer Arithmetic: Algorithms and Hardware Designs*, 2nd ed.,
  Oxford University Press, 2010. Rounding modes and saturating arithmetic.

### Hardware implementation

Original implementation. It follows the standard requantize datapath
(multiply, rounding right shift, saturate) from the references above; not
copied from any specific source.

## Testbench

`testbench/test_requant_smoke.v` is a Verilog-2005 self-checking testbench that
drives random `acc`/`scale`/`shift` plus directed tie cases, computes the
reference (round-half-away-from-zero shift then saturate) in a wide
accumulator, compares `out`, and prints `PASSED` / `FAILED`.
