# linkmap

**Source:** [rtl/linkmap.v](rtl/linkmap.v)

Transport-layer framer and deframer for a serial data-converter link. It maps
converter samples to octets and distributes the octets across lanes (framer),
and reverses the mapping (deframer). This is the deterministic sample<->lane
reorganization at the heart of a JESD204-style link.

## What it is

`M` converters each produce `S` samples per frame; samples are `N` bits (a
multiple of 8). Each sample is split into `N/8` octets, and octet `g` is placed
on lane `g mod L` at frame position `g / L` -- the round-robin octet-to-lane
mapping. The framer performs this permutation; the deframer performs the
inverse. Both are independent combinational permutations (built with `generate`,
one octet wire per iteration) with registered outputs, so both paths are
exercised and neither optimizes to the other.

Parameters: `M` (converters), `S` (samples/frame), `N` (sample width, multiple
of 8), `L` (lanes); requires `M*S*(N/8)` divisible by `L`. Defaults 4/4/16/4
give a 256-bit frame over 4 lanes.

## Interface

| Signal     | Dir | Width     | Description                    |
|------------|-----|-----------|--------------------------------|
| `clk`      | in  | 1         | clock                          |
| `nreset`   | in  | 1         | async reset, active low        |
| `smp_in`   | in  | `M*S*N`   | packed samples (to frame)      |
| `lane_out` | out | `M*S*N`   | framed lane data               |
| `lane_in`  | in  | `M*S*N`   | framed lane data (to deframe)  |
| `smp_out`  | out | `M*S*N`   | recovered samples              |

## Synthesis mapping / what it stresses

- **Wide permutation / fan-out routing:** the octet-to-lane mapping is pure
  wiring that scales with `M`, `S`, `N`, `L` -- it stresses the tool's handling
  of wide reshuffles and register fan-in/out rather than logic.
- **Register banks:** the framed and deframed outputs.

## References

### Algorithm / standard

- JEDEC JESD204B, *Serial Interface for Data Converters*. The transport layer:
  mapping converter samples to octets and distributing octets across lanes,
  which this block models in parametric form.

### Provenance

Original implementation written for LogikBench; a clean-room, parametric
transport mapping following the octet-to-lane scheme in the reference above, not
copied from any specific HDL source.

## Testbench

`testbench/test_linkmap_smoke.v` is a Verilog-2005 self-checking testbench. It
loops the framer output back into the deframer and checks the recovered samples
match the input (across the 2-cycle latency), and that the framer actually
permutes the data. Prints `PASSED` / `FAILED`.
