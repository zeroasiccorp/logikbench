# dotprod

**Source:** [rtl/dotprod.v](rtl/dotprod.v)

Unsigned dot product (sum of element-wise products) of two length-`N`
vectors -- the fundamental multiply-accumulate reduction at the core of FIR
filters, matrix multiply, and neural-network layers.

## What it is

`dotprod` computes `out = sum(a[i] * b[i])` for `i = 0 .. N-1`, where `a` and
`b` are two `N`-element vectors of `DW`-bit unsigned operands packed into the
`a` and `b` ports. The default configuration is `N = 8`, `DW = 16`.

The result is kept at **full precision**: each `DW x DW` product is `2*DW`
bits, and summing `N` of them needs `$clog2(N)` extra bits, so
`out` is `2*DW + $clog2(N)` bits wide. This is intentional -- a narrower
accumulator would truncate the products and no longer model a real dot product
(and would under-size the multiplier/DSP datapath the benchmark is meant to
exercise).

## Circuit

A parallel array of `N` `DW x DW` multipliers whose products feed a single
adder reduction. It is purely combinational: `N` products are formed and summed
into the `2*DW + $clog2(N)`-bit result.

## Interface

| Signal | Dir | Width               | Description                          |
|--------|-----|---------------------|--------------------------------------|
| `a`    | in  | `N*DW`              | vector a, packed `{a[N-1] .. a[0]}`  |
| `b`    | in  | `N*DW`              | vector b, packed `{b[N-1] .. b[0]}`  |
| `out`  | out | `2*DW + $clog2(N)`  | full-precision sum of products       |

## Synthesis mapping

At the default `N = 8`, `DW = 16`:

- `N` = 8 unsigned 16x16 multipliers. On FPGA these map to the device
  DSP/multiplier blocks (one or more per product depending on operand width);
  on ASIC they synthesize to logic.
- An `N`-input adder tree summing the `2*DW`-bit products into the
  `2*DW + $clog2(N)`-bit accumulator (LUT/carry logic; DSP adder cascade on
  fabrics that support it).
- Combinational, so no registers and no BRAM.

## References

### Algorithm

- B. Parhami, *Computer Arithmetic: Algorithms and Hardware Designs*, 2nd ed.,
  Oxford University Press, 2010. Multiply-accumulate and multi-operand addition
  (dot product as a sum of products).

### Hardware implementation

This RTL is an original implementation. It follows the standard parallel
multiplier array plus adder-tree reduction for a sum of products; it is not
copied from any specific source.

## Testbench

`testbench/test_dotprod_smoke.v` is a Verilog-2005 self-checking testbench. It
drives random vectors, computes the reference dot product in a wide accumulator,
compares it against `out`, and prints `PASSED` / `FAILED`.
