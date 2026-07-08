# ln

**Source:** [rtl/ln.v](rtl/ln.v)

Natural logarithm `ln(x)` via mantissa/exponent normalization plus a
polynomial. The standard hardware / math-library method for log: split the
input into a power-of-two exponent and a mantissa in `[1,2)`, approximate
`log2` of the mantissa with a polynomial, then scale by `ln2`.

## What it is

`ln` computes `ln(x)` for a signed fixed-point operand `x > 0` in `Q(DW-QW).QW`
format. Defaults are `DW = 16`, `QW = 8` (Q8.8). For `x <= 0` (outside the
domain) the output is 0.

Method:

```
x = 2^(p-QW) * m,  m in [1,2)          (p = leading-one position)
log2(x) = (p - QW) + log2(m)
ln(x)   = log2(x) * ln2
```

`log2(m)` is a cubic polynomial in `u = m - 1` (Horner form). The exponent
`p - QW` comes from a leading-one detector (same pattern as the `log2` block),
and the mantissa is produced by a normalizing shift. At Q8.8 the accuracy is a
few hundredths (absolute).

## Interface

| Signal | Dir | Width | Description                          |
|--------|-----|-------|--------------------------------------|
| `x`    | in  | `DW`  | operand > 0, Q(DW-QW).QW             |
| `out`  | out | `DW`  | ln(x), same format (0 for x <= 0)    |

## Synthesis mapping

At the defaults (`DW=16, QW=8`):

- A leading-one detector (priority encoder) and a normalizing barrel shift.
- Three multipliers for the Horner `log2` polynomial plus one for the `*ln2`
  scale -> FPGA DSP blocks (or logic on ASIC). Like `exp`, this is a
  DSP-heavy transcendental (vs the shift-add CORDIC blocks).
- Combinational; no registers, no BRAM.

## References

### Algorithm / architecture

- J.-M. Muller, *Elementary Functions: Algorithms and Implementation*, 3rd ed.,
  Birkhauser, 2016. Argument reduction and polynomial evaluation of log.
- P. T. P. Tang, "Table-driven implementation of the logarithm function in
  IEEE floating-point arithmetic," *ACM TOMS*, 1990. The exponent/mantissa
  split for logarithms.

### Hardware implementation

Original implementation. It follows the standard normalize-plus-polynomial
logarithm (leading-one exponent, mantissa polynomial for log2, scale by ln2);
not copied from any specific source.

## Testbench

`testbench/test_ln_smoke.v` is a Verilog-2005 self-checking testbench. It
drives directed and random positive inputs, checks `out` exactly against an
independent integer reference of the datapath, and additionally checks it
against the real-valued `$ln` within tolerance. It prints `PASSED` / `FAILED`.
