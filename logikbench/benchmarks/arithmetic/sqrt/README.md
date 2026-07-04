# sqrt

Unsigned integer square root.

## What it is

`sqrt` computes `root = floor(sqrt(x))` for a `DW`-bit unsigned input `x`,
together with the remainder `rem = x - root*root`. `DW` must be even; `root` is
`DW/2` bits and `rem` is `DW/2+1` bits. The remainder always satisfies
`0 <= rem <= 2*root`, so `root*root + rem == x` holds exactly. Default `DW = 32`.

## Circuit

Sequential digit-by-digit (non-restoring) square root. A one-hot weight `bitm`
sweeps from `4^(DW/2-1)` down to `4^0`, one position per clock. Each cycle the
running remainder `num` is trial-compared against `res + bitm`; when it fits,
that amount is subtracted and the result bit is set. The datapath is a single
add plus a compare/subtract and two shifts -- no multiplier and no memory.

- Latency: `DW/2` cycles per operation.
- Handshake: pulse `in_valid` for one cycle to latch `x` and start; `busy` is
  high while iterating; `out_valid` pulses for one cycle when `root`/`rem` are
  valid.

## Interface

| Signal      | Dir | Width      | Description                         |
|-------------|-----|------------|-------------------------------------|
| `clk`       | in  | 1          | clock                               |
| `nreset`    | in  | 1          | asynchronous reset, active low      |
| `in_valid`  | in  | 1          | pulse to latch `x` and start        |
| `x`         | in  | `DW`       | radicand (unsigned)                 |
| `out_valid` | out | 1          | pulses when `root`/`rem` are valid  |
| `busy`      | out | 1          | high while iterating                |
| `root`      | out | `DW/2`     | `floor(sqrt(x))`                     |
| `rem`       | out | `DW/2+1`   | `x - root*root` (`0..2*root`)       |

## Synthesis mapping

Small: a `DW`-bit adder/subtractor + comparator and three `DW`-bit registers
(`num`, `res`, `bitm`) plus a little control. **0 DSP, 0 BRAM** (no multiplier,
no memory). Area and the critical path scale with `DW`; throughput is one result
every `DW/2` cycles.

## References

### Algorithm

- Digit-by-digit (digit-recurrence) square root; see B. Parhami, *Computer
  Arithmetic: Algorithms and Hardware Designs*, square-root chapter, and the
  classic binary non-restoring shift-subtract method.

### Hardware implementation

Original implementation. It follows the standard digit-recurrence square-root
architecture cited above (one result digit per cycle, add/compare/subtract
datapath) and is not copied from any specific source.

## Testbench

`testbench/test_sqrt_smoke.v` is a Verilog-2005 self-checking testbench. It
drives directed edge cases (0, 1, perfect squares and their neighbours, the
maximum value) and random radicands, then checks the algorithm-independent
invariants `root*root + rem == x` and `rem <= 2*root`, which uniquely define
`floor(sqrt(x))`. It prints `PASSED` / `FAILED`.
