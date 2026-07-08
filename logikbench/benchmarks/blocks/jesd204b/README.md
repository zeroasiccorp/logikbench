# jesd204b

Full-duplex JESD204B link interface, integrated from the LogikBench serial-link
modules. It brings a converter link up (code-group synchronization), then
frames, scrambles, and 8b/10b-encodes samples on transmit, and aligns, decodes,
deskews, descrambles, and deframes them on receive.

## What it is

The `L*10`-bit lane symbols are the chip boundary (an external SERDES is
assumed). Internally the transmit and receive link layers share the SYNC
handshake, so the block can be exercised in loopback.

- **TX** (`jesd204b_tx`): while not synced, every lane sends the K.28.5 comma
  (CGS). Once synced, samples are transport-framed (`linkmap`), scrambled per
  lane (`jscram8`, `1+x^14+x^15`), and 8b/10b encoded (`enc8b10b`). A pipeline
  bubble sends commas until real octets are ready.
- **RX** (`jesd204b_rx`): each lane bit-aligns to the comma (`wordalign`),
  8b/10b decodes (`dec8b10b`), and counts commas for code-group sync. Once all
  lanes are synced, data octets are buffered in per-lane elastic FIFOs and
  released together (**lane deskew**), descrambled (`jdescram8`), and
  transport-deframed (`linkmap`) back into samples.

Reused blocks are pulled in as dependencies (`codec8b10b`, `wordalign`,
`linkmap`); the JESD204B scrambler and the deskew FIFO are the only new RTL.
Parameters: `L` lanes (default 4), `M` converters (2), `N` sample bits (16).

**Feature set (Standard):** code-group synchronization, self-synchronous
scrambling, per-lane deskew, transport framing. **Out of scope:** ILAS (initial
lane alignment sequence) and LMFC/deterministic latency (the "Full" tier);
deskew here aligns lanes on the first data octet via the elastic FIFOs rather
than an ILAS multiframe boundary. This is a Subclass-0-style link.

## Interface

| Signal       | Dir | Width    | Description                    |
|--------------|-----|----------|--------------------------------|
| `clk`        | in  | 1        | clock                          |
| `nreset`     | in  | 1        | async reset, active low        |
| `tx_samples` | in  | `M*N`    | samples to transmit            |
| `tx_valid`   | in  | 1        | transmit sample valid          |
| `tx_ready`   | out | 1        | link ready to accept a sample  |
| `tx_lanes`   | out | `L*10`   | transmit lane symbols          |
| `rx_lanes`   | in  | `L*10`   | receive lane symbols           |
| `rx_samples` | out | `M*N`    | recovered samples              |
| `rx_valid`   | out | 1        | recovered sample valid         |
| `synced`     | out | 1        | link code-group synchronized   |
| `rx_err`     | out | 1        | 8b/10b decode error            |

## Synthesis mapping / what it stresses

- **Full link datapath:** per-lane comparator arrays + barrel shifters
  (align), coding-table logic (8b/10b), wide XOR scramblers, deskew FIFOs
  (BRAM/LUTRAM), and a wide transport permutation -- a realistic mixed
  control/datapath integration across many submodules.

## References

### Algorithm / standard

- JEDEC JESD204B, *Serial Interface for Data Converters*. Code-group
  synchronization, the `1+x^14+x^15` self-synchronous scrambler, lane deskew,
  and the transport layer integrated here.
- A. X. Widmer and P. A. Franaszek, "A DC-Balanced, Partitioned-Block, 8B/10B
  Transmission Code," IBM J. Res. Dev., 1983. The line code (via `codec8b10b`).

### Provenance

Original implementation written for LogikBench; a clean-room integration
following the JESD204B specification and reusing the LogikBench serial-link
modules. Not copied from any specific HDL source, and in particular not derived
from any vendor's (license-incompatible) JESD204 RTL.

## Testbench

`testbench/test_jesd204b_smoke.v` is a Verilog-2005 self-checking testbench. It
loops the transmit lanes back to the receive lanes with a per-lane skew
(0,1,2,3 cycles) to exercise deskew, waits for the link to synchronize, and
scoreboards the recovered samples in order across the full round trip. Prints
`PASSED` / `FAILED`.
