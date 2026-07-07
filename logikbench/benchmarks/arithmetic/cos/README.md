# cos

Cosine `cos(z)` via a CORDIC rotation-mode core. A multiplier-free,
table-free transcendental: pure shift-add rotations, complementary to the
existing LUT-based `sine`.

## What it is

`cos` computes `cos(z)` for a signed fixed-point angle `z` in radians,
`Q(DW-QW).QW` format. Defaults are `DW = 16`, `QW = 8` (Q8.8), `N = 12`
CORDIC iterations. The output is `cos(z)` in the same format.

**Domain:** `z` in `[-pi/2, pi/2]`. CORDIC rotation converges for
`|z| <= ~1.7433` rad; the principal range `[-pi/2, pi/2]` (where `cos >= 0`)
is within that bound and is the documented, supported domain. (Full-range
cosine would add an up-front quadrant reduction.)

## Circuit

A rotation-mode CORDIC, unrolled to one combinational stage per iteration with
a `generate` loop (no procedural unroll). Each stage does three shift-adds:

```
d = (z_i >= 0) ? +1 : -1
x_{i+1} = x_i - d*(y_i >> i)
y_{i+1} = y_i + d*(x_i >> i)
z_{i+1} = z_i - d*atan(2^-i)
```

`x` is initialised to `1/K` (`K ~= 1.6468` is the CORDIC gain) so that after
the rotations `x -> cos(z)` and `y -> sin(z)`; only `x` is output. The
`atan(2^-i)` constants are a packed Q8.8 ROM of small constants. There is no
multiplier and no memory. Absolute accuracy at Q8.8 / `N = 12` is a few percent
(limited by the 8-bit fractional quantisation of the constants and the
intermediate rotations, not by the iteration count); internal fractional guard
bits would tighten it if needed.

## Interface

| Signal | Dir | Width | Description                          |
|--------|-----|-------|--------------------------------------|
| `z`    | in  | `DW`  | angle in radians, Q(DW-QW).QW        |
| `out`  | out | `DW`  | cos(z), same format                  |

## Synthesis mapping

`N` rotation stages, each three adders plus two hard-wired (constant) shifts.
Pure LUT/carry logic: no DSP, no BRAM, no registers (combinational). This is
the shift-add counterpart to the BRAM-based `sine` lookup.

## References

### Algorithm / architecture

- J. E. Volder, "The CORDIC Trigonometric Computing Technique," *IRE Trans.
  Electronic Computers*, 1959. The original CORDIC algorithm.
- R. Andraka, "A survey of CORDIC algorithms for FPGA based computers,"
  *FPGA 1998*. CORDIC modes, gain, and fixed-point implementation on FPGAs.

### Hardware implementation

Original implementation. It follows the standard unrolled rotation-mode CORDIC
(shift-add stages, 1/K pre-scale, packed atan table) from the references above;
not copied from any specific source.

## Testbench

`testbench/test_cos_smoke.v` is a Verilog-2005 self-checking testbench. It
drives directed and random angles in `[-pi/2, pi/2]`, checks `out` exactly
against an independent integer CORDIC reference, and additionally checks it
against the real-valued `$cos` within the CORDIC error bound. It prints
`PASSED` / `FAILED`.
