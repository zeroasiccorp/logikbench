# crc32 (10GbE frame check sequence)

**Source:** [rtl/crc32.v](rtl/crc32.v)

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

| Signal      | Dir | Width        | Meaning                                |
|-------------|-----|--------------|----------------------------------------|
| `clk`       | in  | 1            | clock                                  |
| `rst`       | in  | 1            | synchronous, active high               |
| `in_valid`  | in  | 1            | data word valid this cycle             |
| `in_data`   | in  | W            | data word (byte 0 in [7:0], LSB first) |
| `in_last`   | in  | 1            | last word of the frame                 |
| `in_bytes`  | in  | clog2(W/8)+1 | valid bytes in the last word (1..W/8)  |
| `out_valid` | out | 1            | FCS valid (one cycle after `in_last`)  |
| `out_crc`   | out | 32           | frame FCS                              |

The first valid word after reset (or after a word with `in_last`) starts a new
frame and re-initializes the CRC.

**Arbitrary frame byte-lengths are supported.** Non-last words consume all W/8
bytes (`in_bytes` ignored). On the last word, `in_bytes` gives the number of
valid bytes (1..W/8), which must occupy the low byte lanes (`in_data[7:0]` is
byte 0); the upper lanes are ignored. The core taps the running CRC at every
byte boundary and, on the last word, folds in only the `in_bytes` valid bytes
(an 8:1 select for W=64), so any byte length works.

## Parameters

| Parameter | Default | Meaning                                    |
|-----------|---------|--------------------------------------------|
| `W`       | 64      | datapath bits per clock (multiple of 8)    |

The CRC update is written as a per-bit reflected loop over the `W` input bits;
synthesis unrolls it into the parallel CRC XOR tree, so the same source covers
8 / 32 / 64 (etc.) by changing `W`.

## Mapping

Pure XOR logic (the parallel CRC tree plus the per-byte taps and the last-word
byte-count mux) and the 32-bit CRC state register: maps to LUTs + flip-flops,
no DSP and no BRAM. Verified on `zeroasic_z1015`: ~608 LUTs + 66 FF at W=64,
no latches.

## Files

- `rtl/crc32.v` -- the parallel CRC-32.
- `testbench/test_crc32_smoke.v` -- Verilog-2005 self-checking smoke test. It
  validates a byte-serial reference model against the canonical check value
  (CRC32("123456789") = 0xCBF43926), then streams arbitrary-length frames
  (including odd byte counts, exercising the partial last word) through the DUT
  and compares the FCS against the reference. Run:

  ```
  iverilog -g2005 -o sim.out rtl/crc32.v testbench/test_crc32_smoke.v
  vvp sim.out
  ```

  (Add `-DWAVES` for a VCD dump.)

## References

This `crc32.v` is an original RTL implementation, written from the CRC
definition and the standard parallel-CRC (unrolled LFSR) architecture; it is
not derived from a specific HDL source.

### Algorithm and standard

1. W. W. Peterson and D. T. Brown, "Cyclic codes for error detection," *Proc.
   IRE*, vol. 49, no. 1, pp. 228-235, Jan. 1961. (cyclic redundancy check)
2. IEEE Std 802.3 (Ethernet), frame check sequence: CRC-32, polynomial
   0x04C11DB7, reflected, init/xorout 0xFFFFFFFF. Check value 0xCBF43926.

### Hardware implementation (parallel CRC)

3. T.-B. Pei and C. Zukowski, "High-speed parallel CRC circuits in VLSI,"
   *IEEE Trans. Communications*, vol. 40, no. 4, pp. 653-657, Apr. 1992.
   (parallel/unrolled CRC computation in hardware)
4. G. Albertengo and R. Sisto, "Parallel CRC generation," *IEEE Micro*,
   vol. 10, no. 5, pp. 63-71, Oct. 1990.
5. D. V. Sarwate, "Computation of cyclic redundancy checks via table look-up,"
   *Communications of the ACM*, vol. 31, no. 8, pp. 1008-1013, Aug. 1988.
   (byte-at-a-time CRC; basis of the testbench's reference model)
