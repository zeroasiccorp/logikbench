# atan

Arctangent `atan(t)` via a CORDIC vectoring-mode core. A multiplier-free,
table-free inverse-trig function: pure shift-add rotations.

## What it is

`atan` computes `atan(t)` (in radians) for a signed fixed-point operand `t` in
`Q(DW-QW).QW` format. Defaults are `DW = 16`, `QW = 8` (Q8.8), `N = 12`
CORDIC iterations. The output is the angle in `(-pi/2, pi/2)`, same format.

## Circuit

A vectoring-mode CORDIC, unrolled to one combinational stage per iteration
(`generate`). The vector `(x, y) = (1, t)` is rotated toward the x-axis; each
stage removes a known sub-angle and accumulates it into `z`:

```
d = (y_i < 0) ? +1 : -1
x_{i+1} = x_i - d*(y_i >> i)
y_{i+1} = y_i + d*(x_i >> i)
z_{i+1} = z_i - d*atan(2^-i)
```

`z` starts at 0 and converges to `atan(t)`. Because `z` accumulates rotation
angles, the result is **independent of the CORDIC gain** `K`, so (unlike the
`cos` rotation core) no `1/K` pre-scale is required; `x`/`y` are scaled by `K`
but are not output. The `atan(2^-i)` constants are a packed Q8.8 ROM. No
multiplier, no memory. Absolute accuracy at Q8.8 / `N = 12` is a few percent.

## Interface

| Signal | Dir | Width | Description                          |
|--------|-----|-------|--------------------------------------|
| `t`    | in  | `DW`  | operand, Q(DW-QW).QW                  |
| `out`  | out | `DW`  | atan(t) in radians, (-pi/2, pi/2)    |

## Synthesis mapping

`N` vectoring stages, each three adders plus two hard-wired (constant) shifts.
Pure LUT/carry logic: no DSP, no BRAM, no registers (combinational).

## References

### Algorithm / architecture

- J. E. Volder, "The CORDIC Trigonometric Computing Technique," *IRE Trans.
  Electronic Computers*, 1959. The original CORDIC algorithm (vectoring mode
  computes magnitude and angle).
- R. Andraka, "A survey of CORDIC algorithms for FPGA based computers,"
  *FPGA 1998*. Vectoring-mode arctangent and fixed-point implementation.

### Hardware implementation

Original implementation. It follows the standard unrolled vectoring-mode CORDIC
(shift-add stages, packed atan table, gain-independent angle accumulation) from
the references above; not copied from any specific source.

## Testbench

`testbench/test_atan_smoke.v` is a Verilog-2005 self-checking testbench. It
drives directed and random operands, checks `out` exactly against an
independent integer CORDIC reference, and additionally checks it against the
real-valued `$atan` within the CORDIC error bound. It prints `PASSED` /
`FAILED`.
