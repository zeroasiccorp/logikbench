# viterbi (convolutional decoder)

## What it is

A soft-decision **Viterbi decoder** for the **K=7, rate-1/2** convolutional code
with generator polynomials **G0 = 133, G1 = 171 (octal)** -- the de-facto
standard code used by IEEE 802.11a/g, DVB, and CCSDS/NASA. The decoder finds
the maximum-likelihood transmitted bit sequence through the 64-state code
trellis and corrects channel errors.

## Architecture

- **64 states** (2^(K-1)), **fully-parallel add-compare-select (ACS)**: all 64
  butterflies evaluated every clock, one trellis step per clock.
- **Soft-decision** inputs: each coded bit arrives as an `SW`-bit confidence
  symbol (default 3-bit); the branch metric is the soft (correlation) distance.
- Path metrics are **normalized** every step (subtract the running minimum) so a
  fixed metric width never overflows.
- **RAM-based traceback**: survivor decisions (1 bit/state) are written to a
  memory each step; the frame is then traced back from the best (minimum
  path-metric) state to recover the decoded bits. The survivor memory maps to
  FPGA BRAM.

### Operation (frame-based)

Stream a frame of soft symbol pairs with `in_valid`, asserting `in_last` on the
final pair. The decoder then traces back the whole frame from the best state and
streams the decoded bits out (`out_valid`/`out_bit`), oldest first. Terminate
the encoder with a 6-bit (K-1) zero tail so the trellis ends in state 0 for best
accuracy. Frame length must be <= `MAXLEN`.

Note: this is a **block/frame** decoder (accept the frame, then trace it back),
chosen so the traceback is simple and bit-exact, rather than a continuous
multi-bank streaming traceback. Same parallel-ACS + RAM-traceback datapath;
throughput is ~2 clocks per decoded bit (ACS phase + traceback phase).

## Interface

| Signal      | Dir | Width | Meaning                                  |
|-------------|-----|-------|------------------------------------------|
| `clk`       | in  | 1     | clock                                    |
| `rst`       | in  | 1     | synchronous, active high                 |
| `in_valid`  | in  | 1     | soft symbol pair valid                   |
| `in_sym0`   | in  | SW    | soft estimate of coded bit 0 (G0)        |
| `in_sym1`   | in  | SW    | soft estimate of coded bit 1 (G1)        |
| `in_last`   | in  | 1     | last symbol pair of the frame            |
| `out_valid` | out | 1     | decoded bit valid                        |
| `out_bit`   | out | 1     | decoded bit (oldest first)               |

## Parameters

| Parameter | Default | Meaning                                       |
|-----------|---------|-----------------------------------------------|
| `SW`      | 3       | soft symbol width (bits)                      |
| `MAXLEN`  | 256     | maximum frame length (decoded bits)           |

The code (K=7, G0=133, G1=171) is fixed; `SW` and `MAXLEN` are configurable.

## Mapping

Verified on `zeroasic_z1015`: ~6900 LUTs (the 64 ACS adders/comparators + the
64-way min reduction + control), ~880 FF (path metrics), and BRAM for the
survivor memory (`sdpram_16384x1` + `sdpram_1024x16`), no DSP, no latches.

## Files

- `rtl/viterbi.v` -- the decoder (BMU + 64-way ACS + traceback FSM).
- `testbench/test_viterbi_smoke.v` -- Verilog-2005 self-checking smoke test. It
  encodes random frames (+ zero tail) with the 133/171 convolutional encoder,
  maps coded bits to soft symbols, optionally injects channel errors, decodes,
  and checks the recovered bits equal the original -- both error-free (exact)
  and with correctable errors injected. Run:

  ```
  iverilog -g2005 -o sim.out rtl/viterbi.v testbench/test_viterbi_smoke.v
  vvp sim.out
  ```

  (Add `-DWAVES` for a VCD dump.)

## References

This `viterbi.v` is an original RTL implementation written from the algorithm
and standard decoder architecture (it is not derived from a specific HDL
source). The algorithm and the hardware structure it follows are documented in
the references below.

### Algorithm and code

1. A. J. Viterbi, "Error bounds for convolutional codes and an asymptotically
   optimum decoding algorithm," *IEEE Trans. Information Theory*, vol. 13,
   no. 2, pp. 260-269, Apr. 1967.
2. G. D. Forney, Jr., "The Viterbi algorithm," *Proceedings of the IEEE*,
   vol. 61, no. 3, pp. 268-278, Mar. 1973.
3. S. Lin and D. J. Costello, *Error Control Coding*, 2nd ed., Prentice Hall,
   2004. (convolutional codes, Viterbi decoding, traceback depth ~5-6*K)
4. IEEE Std 802.11-2020, sec. on convolutional coding (the K=7, rate-1/2
   G0=133 / G1=171 octal code used here); same code as CCSDS 131.0-B.

### Hardware implementation (ACS, normalization, traceback)

5. K. K. Parhi, *VLSI Digital Signal Processing Systems*, Wiley, 1999 --
   chapter on Viterbi decoders (add-compare-select units, survivor/traceback
   memory, pipelining). The standard VLSI-architecture reference.
6. H.-L. Lou, "Implementing the Viterbi algorithm," *IEEE Signal Processing
   Magazine*, vol. 12, no. 5, pp. 42-52, Sep. 1995. (practical
   fixed-point/hardware implementation tutorial)
7. C. B. Shung, P. H. Siegel, G. Ungerboeck, and H. K. Thapar, "VLSI
   architectures for metric normalization in the Viterbi algorithm," *Proc.
   IEEE Int. Conf. Communications (ICC)*, 1990. (path-metric normalization --
   the subtract-minimum scheme used here)
8. G. Feygin and P. G. Gulak, "Architectural tradeoffs for survivor sequence
   memory management in Viterbi decoders," *IEEE Trans. Communications*,
   vol. 41, no. 3, pp. 425-429, Mar. 1993. (traceback vs. register-exchange
   survivor memory)
