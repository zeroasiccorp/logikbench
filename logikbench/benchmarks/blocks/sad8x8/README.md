# sad8x8 (8x8 block sum-of-absolute-differences)

**Source:** [rtl/sad8x8.v](rtl/sad8x8.v)

## What it is
An **8x8 SAD** block matcher for motion estimation. Two NxN blocks are presented
as packed buses; all 64 absolute differences `|a-b|` are computed in parallel
and summed in an adder tree to the SAD (max 16320, 14-bit). Registered I/O
(valid_in -> valid_out, 1-cycle). No multiply, no memory.

It shares the `clk`/`rst`/`valid`/8-bit-pixel conventions of the streaming 3x3
filters and is a measurement (reduction) block -- it sits at the tail of an
image pipeline rather than passing a same-size stream.

## Interface
| Signal      | Dir | Width   | Meaning                              |
|-------------|-----|---------|--------------------------------------|
| `clk`,`rst` | in  | 1       | clock, synchronous reset             |
| `valid_in`  | in  | 1       | block pair valid                     |
| `curblk`    | in  | N*N*PW  | current block (pixel k at [k*PW+:PW])|
| `refblk`    | in  | N*N*PW  | reference block, same packing        |
| `valid_out` | out | 1       | SAD valid (1-cycle latency)          |
| `sad`       | out | 14      | sum of absolute differences          |

Parameters: `N` (block size, 8), `PW` (pixel width, 8).

## Mapping
64 abs-diff cells (subtract/compare/select) + 63-adder tree -> LUTs/FFs, **0
DSP, 0 BRAM**.

## Files
`rtl/sad8x8.v`, `testbench/test_sad8x8_smoke.v` (self-checking: identical /
offset / max / random block pairs vs reference). Run: `iverilog -g2005 -o
sim.out rtl/sad8x8.v testbench/test_sad8x8_smoke.v && vvp sim.out`.

## References
Original implementation. **Algorithm:** block-matching motion estimation, SAD
metric (MPEG/H.26x). **Hardware:** systolic/parallel SAD arrays for VLSI motion
estimation (e.g. Vos & Stegherr; standard ME accelerator designs).
