# crc32 (10GbE frame check sequence)

## What it is

A parallel **CRC-32** generator implementing the IEEE 802.3 / Ethernet frame
check sequence (FCS), sized for 10 Gigabit Ethernet. It consumes `W` bits per
clock (default **64**, the 10GbE XGMII datapath: 64 b x 156.25 MHz = 10 Gb/s)
and produces the frame FCS.

CRC-32 spec (the standard Ethernet / zlib CRC):

| Property   | Value                                  |
|------------|----------------------------------------|
| Polynomial | 0x04C11DB7 (reflected form 0xEDB88320) |
| Reflection | input and output reflected             |
| Init       | 0xFFFFFFFF                             |
| Final XOR  | 0xFFFFFFFF                             |
| Check      | CRC32("123456789") = 0xCBF43926        |

(Note: 10 GbE's FCS is CRC-32, not a 64-bit CRC; "64" here is the datapath
width, not the polynomial width.)

## Interface

| Signal      | Dir | Width | Meaning                                  |
|-------------|-----|-------|------------------------------------------|
| `clk`       | in  | 1     | clock                                    |
| `rst`       | in  | 1     | synchronous, active high                 |
| `in_valid`  | in  | 1     | data word valid this cycle               |
| `in_data`   | in  | W     | data word (byte 0 in [7:0], LSB first)   |
| `in_last`   | in  | 1     | last word of the frame                   |
| `out_valid` | out | 1     | FCS valid (one cycle after `in_last`)    |
| `out_crc`   | out | 32    | frame FCS                                |

The first valid word after reset (or after a word with `in_last`) starts a new
frame and re-initializes the CRC. **Frame length must be a multiple of W bits**
(full-width words only); partial final beats / byte-enables are out of scope.

## Parameters

| Parameter | Default | Meaning                                    |
|-----------|---------|--------------------------------------------|
| `W`       | 64      | datapath bits per clock (multiple of 8)    |

The CRC update is written as a per-bit reflected loop over the `W` input bits;
synthesis unrolls it into the parallel CRC XOR tree, so the same source covers
8 / 32 / 64 (etc.) by changing `W`.

## Mapping

Pure XOR logic plus the 32-bit CRC state register: maps to LUTs + flip-flops,
no DSP and no BRAM. Verified on `zeroasic_z1015`: ~325 LUTs + 66 FF at W=64,
no latches.

## Files

- `rtl/crc32.v` -- the parallel CRC-32.
- `testbench/test_crc32_smoke.v` -- Verilog-2005 self-checking smoke test. It
  validates a byte-serial reference model against the canonical check value
  (CRC32("123456789") = 0xCBF43926), then streams full-width frames through the
  DUT and compares the FCS against the reference. Run:

  ```
  iverilog -g2005 -o sim.out rtl/crc32.v testbench/test_crc32_smoke.v
  vvp sim.out
  ```

  (Add `-DWAVES` for a VCD dump.)
