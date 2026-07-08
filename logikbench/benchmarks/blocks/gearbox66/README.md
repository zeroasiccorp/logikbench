# gearbox66

**Source:** [rtl/gearbox66.v](rtl/gearbox66.v)

64b/66b link encode/decode datapath -- the line-coding scheme used on high-rate
serial data-converter and Ethernet links. It scrambles a 64-bit payload, tags a
2-bit sync header, and repacks the 66-bit blocks to a 64-bit stream with a
bit gearbox; a loopback then reverses all three steps.

## What it is

- **Self-synchronous scrambler / descrambler** (`G(x) = 1 + x^39 + x^58`), 64-bit
  parallel. Each output bit XORs the payload bit with two state taps; the state
  shifts in the scrambled bit, so the descrambler self-synchronizes with no
  seed exchange. Implemented as an unrolled 64-step generate chain (a wide XOR
  network).
- **Sync header**: 2 bits (01 = data, 10 = control) prepended to the 64-bit
  scrambled payload to form a 66-bit block; checked on receive (`rx_herr`).
- **Bit gearbox**: a 66->64 accumulator packs 66-bit blocks into a 64-bit output
  stream (asserting a periodic bubble via `tx_ready`); a 64->66 accumulator
  reverses it. The two are wired in loopback so the block self-tests.

Datapath is combinational `assign` (scramble/descramble XOR networks, shifts)
plus the accumulator/state registers. Fixed 64-bit payload, 66-bit block.

## Interface

| Signal     | Dir | Width | Description                    |
|------------|-----|-------|--------------------------------|
| `clk`      | in  | 1     | clock                          |
| `nreset`   | in  | 1     | async reset, active low        |
| `tx_valid` | in  | 1     | present a payload              |
| `tx_data`  | in  | 64    | payload                        |
| `tx_ctrl`  | in  | 1     | control block (header 10)      |
| `tx_ready` | out | 1     | gearbox can accept a payload   |
| `rx_data`  | out | 64    | recovered payload              |
| `rx_ctrl`  | out | 1     | recovered header type          |
| `rx_valid` | out | 1     | recovered payload valid        |
| `rx_herr`  | out | 1     | illegal sync header            |

## Synthesis mapping / what it stresses

- **Wide XOR networks:** the two unrolled 64-bit self-synchronous scramblers.
- **Barrel shifters + accumulators:** the 66/64 and 64/66 gearboxes (variable
  shifts into a ~132-bit accumulator).
- **Handshake control:** the `tx_ready` bubble and valid pipelining.

## References

### Algorithm / standard

- IEEE Std 802.3, Clause 49 (64B/66B PCS). The 64b/66b sync header, the
  `1 + x^39 + x^58` self-synchronous scrambler, and the gearbox concept.
- JEDEC JESD204C, *Serial Interface for Data Converters*. Adopts 64b/66b link
  layer coding for high-rate converter links.

### Provenance

Original implementation written for LogikBench; a clean-room datapath following
the 64b/66b scheme and scrambler polynomial in the references above, not copied
from any specific HDL source.

## Testbench

`testbench/test_gearbox66_smoke.v` is a Verilog-2005 self-checking testbench. It
drives random payloads (respecting `tx_ready`), records them in a FIFO
scoreboard, and checks the loopback-recovered payloads and headers in order
across the full scramble + gearbox + gearbox + descramble round trip, with no
header errors. Prints `PASSED` / `FAILED`.
