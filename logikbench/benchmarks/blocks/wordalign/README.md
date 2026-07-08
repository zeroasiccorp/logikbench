# wordalign

**Source:** [rtl/wordalign.v](rtl/wordalign.v)

Comma / sync-pattern detector and barrel bitslip aligner -- the code-group
synchronization (CGS) function of a serial data-converter link. It finds a known
alignment pattern at an arbitrary bit offset in the deserialized stream and
rotates the data so the pattern lands at a fixed position.

## What it is

Each cycle a `W`-bit deserialized word arrives. The block forms a two-word
sliding window (previous | current) and compares a `PW`-bit slice at every bit
offset against the `COMMA` pattern (one comparator per offset, generated). The
lowest matching offset is isolated (one-hot) and encoded to binary; the block
locks onto it and thereafter barrel-rotates the window by that offset, so the
aligned word -- with the comma at its low bits -- appears on `dout`. `locked`
indicates the offset has been acquired.

Parameters: `W` (word width, default 40 = four 10-bit symbols), `PW` (pattern
width, default 10), `COMMA` (default the 8b/10b K.28.5 comma). All datapath
logic is combinational `assign` plus a small lock register.

## Interface

| Signal   | Dir | Width       | Description                    |
|----------|-----|-------------|--------------------------------|
| `clk`    | in  | 1           | clock                          |
| `nreset` | in  | 1           | async reset, active low        |
| `din`    | in  | `W`         | deserialized word              |
| `dout`   | out | `W`         | aligned word (comma at low bits)|
| `locked` | out | 1           | comma offset acquired          |
| `offset` | out | `clog2(W)`  | locked bit offset              |

## Synthesis mapping / what it stresses

- **Wide comparator array:** `W` parallel `PW`-bit equality comparators.
- **Priority encode:** lowest-set isolation and one-hot-to-binary encode.
- **Barrel shifter:** the `2W`-to-`W` rotate by a variable offset.

## References

### Algorithm / standard

- JEDEC JESD204B, *Serial Interface for Data Converters*. Code-group
  synchronization: detecting the /K28.5/ comma and slipping the lane to byte
  alignment, the function modeled here.
- A. X. Widmer and P. A. Franaszek, "A DC-Balanced, Partitioned-Block, 8B/10B
  Transmission Code," IBM J. Res. Dev., 1983. Defines the comma characters used
  for alignment.

### Provenance

Original implementation written for LogikBench; a clean-room aligner following
the alignment concept in the references above, not copied from any specific HDL
source.

## Testbench

`testbench/test_wordalign_smoke.v` is a Verilog-2005 self-checking testbench. It
confirms the block stays unlocked with no comma present, then locks to the
correct offset when comma-bearing words arrive and presents the comma aligned to
the low bits of `dout`. Prints `PASSED` / `FAILED`.
