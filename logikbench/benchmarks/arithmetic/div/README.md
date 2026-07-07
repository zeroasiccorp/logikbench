# div

Unsigned integer division: `quotient = floor(dividend / divisor)` plus the
`remainder`, using a sequential digit-recurrence divider.

## What it is

`div` divides two `DW`-bit unsigned operands, producing the quotient and
remainder. Default `DW = 16`. It uses the classic **restoring** shift-subtract
recurrence and completes in `DW` cycles, with the same valid/busy handshake as
the `sqrt` block.

Divide-by-zero yields an all-ones quotient (the natural result of the
recurrence) rather than trapping.

## Circuit

A `(2*DW+1)`-bit `{remainder, quotient}` register shifts left one position per
clock; when the remainder part is `>= divisor` it subtracts the divisor and
sets the quotient LSB. The datapath is a single shift, compare, and subtract
per cycle -- no multiplier, no memory.

## Interface

| Signal      | Dir | Width | Description                          |
|-------------|-----|-------|--------------------------------------|
| `clk`       | in  | 1     | clock                                |
| `nreset`    | in  | 1     | async reset, active low              |
| `in_valid`  | in  | 1     | pulse to latch operands and start    |
| `dividend`  | in  | `DW`  | unsigned dividend                    |
| `divisor`   | in  | `DW`  | unsigned divisor                     |
| `out_valid` | out | 1     | pulses when the result is valid      |
| `busy`      | out | 1     | high while iterating                 |
| `quotient`  | out | `DW`  | floor(dividend / divisor)            |
| `remainder` | out | `DW`  | dividend - quotient*divisor          |

Usage: pulse `in_valid` for one cycle; `busy` stays high for `DW` cycles; read
`quotient`/`remainder` when `out_valid` pulses.

## Synthesis mapping

One `DW`-bit adder/subtractor with a compare, plus the `{rem,quo}` shift
register and a small counter (FFs). No DSP, no BRAM. Latency `DW` cycles.

## References

### Algorithm / architecture

- B. Parhami, *Computer Arithmetic: Algorithms and Hardware Designs*, 2nd ed.,
  Oxford University Press, 2010. Restoring and non-restoring division.

### Hardware implementation

Original implementation. It follows the standard restoring digit-recurrence
divider (shift-subtract on a combined remainder/quotient register); not copied
from any specific source.

## Testbench

`testbench/test_div_smoke.v` is a Verilog-2005 self-checking testbench that
drives directed and random operands through the handshake, compares
`quotient`/`remainder` against the reference `/` and `%` (and the all-ones
divide-by-zero result), and prints `PASSED` / `FAILED`.
