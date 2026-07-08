# codec8b10b

**Source:** [rtl/codec8b10b.v](rtl/codec8b10b.v)

8b/10b line-coding encoder and decoder -- the DC-balanced, run-length-limited
line code used on high-speed serial data-converter links (e.g. JESD204B). The
block instantiates an independent encoder and decoder so both directions are
exercised.

## What it is

The encoder maps each 8-bit byte (HGF EDCBA) to a 10-bit symbol (abcdei fghj)
via a 5b/6b and a 3b/4b sub-block code, tracking running disparity (RD) to keep
the transmitted 1/0 counts balanced. It handles the D.x.7 primary/alternate
selection that bounds run length, and emits the K.28.5 comma when `enc_k` is
asserted. The decoder reverses the mapping: it normalizes disparity (folding a
minority-ones symbol to its RD- form) and looks the result up in a single
reverse table, flags invalid symbols on `dec_err`, and detects the K.28.5 comma
on `dec_k`.

The design covers all 256 data symbols plus the K.28.5 comma (sufficient for
code-group synchronization / alignment). Constant coding tables are held in
`case` ROMs; all other logic is combinational `assign`. Encoder and decoder each
register their output (1-cycle latency each).

## Interface

| Signal     | Dir | Width | Description                       |
|------------|-----|-------|-----------------------------------|
| `clk`      | in  | 1     | clock                             |
| `nreset`   | in  | 1     | async reset, active low           |
| `enc_k`    | in  | 1     | encode the K.28.5 comma           |
| `enc_din`  | in  | 8     | data byte to encode               |
| `enc_dout` | out | 10    | encoded 10-bit symbol             |
| `dec_din`  | in  | 10    | 10-bit symbol to decode           |
| `dec_dout` | out | 8     | decoded byte                      |
| `dec_k`    | out | 1     | decoded symbol is the comma       |
| `dec_err`  | out | 1     | invalid 10-bit code               |

## Synthesis mapping / what it stresses

- **LUT / ROM logic:** the 5b/6b, 3b/4b, and reverse tables map to LUT logic (or
  small distributed ROM); a classic combinational-optimization workload.
- **Small stateful control:** the running-disparity registers plus the
  disparity-dependent complement/alternate selection.

## References

### Algorithm / standard

- A. X. Widmer and P. A. Franaszek, "A DC-Balanced, Partitioned-Block, 8B/10B
  Transmission Code," IBM Journal of Research and Development, vol. 27, no. 5,
  pp. 440-451, 1983. The 8b/10b code, sub-block partitioning, running disparity,
  and D.x.7 alternate encoding implemented here.
- JEDEC JESD204B, *Serial Interface for Data Converters*. Defines 8b/10b as the
  converter-link line code and the K.28.5 comma used for lane alignment.

### Provenance

Original implementation written for LogikBench. It follows the 8b/10b code
defined in the references above (tables and disparity rules); it is a clean-room
implementation, not copied from any specific HDL source.

## Testbench

`testbench/test_codec8b10b_smoke.v` is a Verilog-2005 self-checking testbench.
It loops the encoder output back into the decoder and checks the decoded
byte/comma against the input, and independently verifies the encoded stream's
8b/10b invariants (4-6 ones per symbol, running disparity bounded to +/-1, run
length <= 5) over all 256 data symbols in both disparity states plus commas and
random traffic. Prints `PASSED` / `FAILED`.
