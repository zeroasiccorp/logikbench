# divs

Signed integer division: `quotient` and `remainder` of two `DW`-bit signed
operands, with truncation toward zero (the signed companion of `div`).

## What it is

`divs` divides two signed `DW`-bit operands. Default `DW = 16`. It follows
C/Verilog signed semantics: the quotient truncates toward zero (its sign is the
XOR of the operand signs) and the remainder takes the dividend's sign, so
`dividend = quotient*divisor + remainder`.

Internally it converts both operands to magnitude, runs the same unsigned
restoring digit-recurrence as `div` for `DW` cycles, then negates the quotient
and remainder as required. Handshake mirrors the `sqrt` block.

## Interface

| Signal      | Dir | Width | Description                          |
|-------------|-----|-------|--------------------------------------|
| `clk`       | in  | 1     | clock                                |
| `nreset`    | in  | 1     | async reset, active low              |
| `in_valid`  | in  | 1     | pulse to latch operands and start    |
| `dividend`  | in  | `DW`  | signed dividend                      |
| `divisor`   | in  | `DW`  | signed divisor                       |
| `out_valid` | out | 1     | pulses when the result is valid      |
| `busy`      | out | 1     | high while iterating                 |
| `quotient`  | out | `DW`  | signed quotient (toward zero)        |
| `remainder` | out | `DW`  | signed remainder (dividend's sign)   |

## Synthesis mapping

The unsigned restoring core (a `DW`-bit subtractor/compare, `{rem,quo}` shift
register, counter) plus operand/result sign negation (adders). No DSP, no
BRAM. Latency `DW` cycles.

## References

### Algorithm / architecture

- B. Parhami, *Computer Arithmetic: Algorithms and Hardware Designs*, 2nd ed.,
  Oxford University Press, 2010. Signed division and sign handling.

### Hardware implementation

Original implementation. It follows the standard sign-magnitude wrapper around
a restoring digit-recurrence divider; not copied from any specific source.

## Testbench

`testbench/test_divs_smoke.v` is a Verilog-2005 self-checking testbench that
drives directed and random signed operands through the handshake, compares
`quotient`/`remainder` against Verilog signed `/` and `%`, and prints
`PASSED` / `FAILED`.
