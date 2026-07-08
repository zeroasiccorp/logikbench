# mod

**Source:** [rtl/mod.v](rtl/mod.v)

Unsigned integer modulo: `remainder = dividend mod divisor`, using a
sequential digit-recurrence divider.

## What it is

`mod` computes the remainder of dividing two `DW`-bit unsigned operands.
Default `DW = 16`. It uses the same restoring shift-subtract recurrence as the
`div` block -- the quotient is built internally but only the remainder is
exposed -- and completes in `DW` cycles with the `sqrt`-style valid/busy
handshake. Modulo by zero returns the dividend.

## Circuit

A `(2*DW+1)`-bit `{remainder, quotient}` register shifts left one place per
clock; when the remainder part is `>= divisor` it subtracts. After `DW` cycles
the remainder register holds `dividend mod divisor`. Single shift/compare/
subtract per cycle; no multiplier, no memory.

## Interface

| Signal      | Dir | Width | Description                          |
|-------------|-----|-------|--------------------------------------|
| `clk`       | in  | 1     | clock                                |
| `nreset`    | in  | 1     | async reset, active low              |
| `in_valid`  | in  | 1     | pulse to latch operands and start    |
| `dividend`  | in  | `DW`  | unsigned dividend                    |
| `divisor`   | in  | `DW`  | unsigned divisor                     |
| `out_valid` | out | 1     | pulses when the remainder is valid   |
| `busy`      | out | 1     | high while iterating                 |
| `remainder` | out | `DW`  | dividend mod divisor                 |

## Synthesis mapping

One `DW`-bit subtractor with a compare, the `{rem,quo}` shift register, and a
counter (FFs). No DSP, no BRAM. Latency `DW` cycles.

## References

### Algorithm / architecture

- B. Parhami, *Computer Arithmetic: Algorithms and Hardware Designs*, 2nd ed.,
  Oxford University Press, 2010. Restoring division and remainder.

### Hardware implementation

Original implementation. It follows the standard restoring digit-recurrence
divider (remainder output); not copied from any specific source.

## Testbench

`testbench/test_mod_smoke.v` is a Verilog-2005 self-checking testbench that
drives directed and random operands through the handshake, compares
`remainder` against the reference `%` (and the modulo-by-zero result), and
prints `PASSED` / `FAILED`.
