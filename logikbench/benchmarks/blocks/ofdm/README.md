# ofdm (OFDM loopback modem)

**Source:** [rtl/ofdm.v](rtl/ofdm.v)

## What it is

An **OFDM modem** (802.11a/g style) with a complete transmit + receive chain in
one block, looped back internally (ideal channel) so the recovered bits equal
the input bits. It reuses the logikbench **`fft`** block as the transform
engine. Supported modulation (`mod`): **QPSK, 16-QAM, 64-QAM** (Gray-coded
square QAM).

The benchmark exercises the OFDM-specific datapath -- QAM mapping/demapping,
subcarrier handling, cyclic prefix, bit-reversal reorder, and IFFT/FFT
sequencing -- on top of two instances of the FFT accelerator.

## Architecture

Frame-based, one OFDM symbol per transaction:

- **TX**: bits -> QAM mapper -> IFFT -> cyclic-prefix insertion -> time samples.
  The IFFT reuses the `fft` block via `ifft(X) = conj(fft(conj(X)))` (the fft's
  1/N scaling is the IFFT scale).
- **RX**: cyclic-prefix removal -> FFT -> `<<LOG2N` rescale (undo the RX FFT's
  extra 1/N) -> QAM demapper -> bits.

The `fft` block is streaming with a fixed latency (70 for N=64), bit-reversed
output, and 1/N scaling, so the modem includes bit-reversal reorder buffers and
holds the two `fft` instances in reset between symbols (clean pipeline per
symbol). QPSK slicing is sign-only; 16/64-QAM slicing needs amplitude, hence
the rescale before the PAM slicer.

## Interface

| Signal      | Dir | Width | Meaning                                       |
|-------------|-----|-------|-----------------------------------------------|
| `clk`       | in  | 1     | clock                                         |
| `rst`       | in  | 1     | synchronous, active high                      |
| `in_valid`  | in  | 1     | start: one symbol of bits                     |
| `mod`       | in  | 2     | 0 = QPSK, 1 = 16-QAM, 2 = 64-QAM              |
| `in_bits`   | in  | 6*N   | per-subcarrier 6-bit slots (low 2*B used)     |
| `out_valid` | out | 1     | recovered bits valid                          |
| `out_bits`  | out | 6*N   | recovered bits (same slot layout)             |

Bits are carried in fixed 6-bit per-subcarrier slots: `in_bits[sc*6 +: 6] =
{Qfield[2:0], Ifield[2:0]}`, with each field's low `B` bits significant
(`B = mod+1`: 1/2/3 bits per axis for QPSK/16-QAM/64-QAM). Constellation levels
are +/-{1,3,5,7}*AMP per axis (`AMP = 2048`).

## Parameters

| Parameter | Default | Meaning                          |
|-----------|---------|----------------------------------|
| `DW`      | 16      | sample width (Q1.15)             |
| `N`       | 64      | FFT size / subcarriers           |
| `CP`      | 16      | cyclic-prefix length             |

(`N=64`/`CP=16` and the latency constant target the 802.11a 64-point profile.)

## Mapping

Verified on `zeroasic_z1015`: ~8500 LUTs, ~10.2k FF (the reorder/symbol buffers
are parallel-access, so flip-flops rather than BRAM), and 48 DSP cells (the two
`fft` instances' twiddle multipliers); no latches.

## Scope notes

- All 64 subcarriers carry data in this version (no separate pilot/null
  subcarrier map yet) and the channel is an ideal internal loopback (the 1-tap
  equalizer is identity), so the test is a clean encode/decode round-trip. Real
  802.11a pilot/null mapping and a pilot-based equalizer are natural follow-ons.

## Files

- `rtl/ofdm.v` -- top: the full TX+RX loopback example, instantiates
  `ofdm_tx` + `ofdm_rx` with the TX stream wired to the RX (ideal channel).
- `rtl/ofdm_tx.v` -- transmitter (QAM map -> IFFT -> cyclic prefix), streams
  out N+CP time samples; one `fft` instance.
- `rtl/ofdm_rx.v` -- receiver (CP removal -> FFT -> rescale -> QAM demap);
  one `fft` instance.
- `testbench/test_ofdm_smoke.v` -- Verilog-2005 self-checking loopback smoke
  test: random frames at each modulation order (QPSK/16-QAM/64-QAM) through
  TX->RX, checking recovered bits == input bits. Run (compile fft + ofdm):

  ```
  iverilog -g2005 -o sim.out ../fft/rtl/fft.v \
           rtl/ofdm_tx.v rtl/ofdm_rx.v rtl/ofdm.v \
           testbench/test_ofdm_smoke.v
  vvp sim.out
  ```

## References

This `ofdm.v` is an original RTL implementation; it composes the logikbench
`fft` block (see `../fft/README.md`) with original mapper/demapper/CP/control
logic. It is not derived from a specific HDL source.

### Algorithm and standard

1. S. B. Weinstein and P. M. Ebert, "Data transmission by frequency-division
   multiplexing using the discrete Fourier transform," *IEEE Trans.
   Communications*, vol. 19, no. 5, pp. 628-634, Oct. 1971. (DFT-based OFDM)
2. IEEE Std 802.11a-1999, OFDM PHY (64-point FFT, CP, BPSK/QPSK/16-/64-QAM,
   Gray-coded constellations and normalization).
3. R. van Nee and R. Prasad, *OFDM for Wireless Multimedia Communications*,
   Artech House, 2000.

### Hardware implementation

4. The transform reuses the pipelined R2SDF FFT core; see `../fft/README.md`
   and its references (Wold & Despain 1984; He & Torkelson 1996; Parhi 1999).
5. K. K. Parhi, *VLSI Digital Signal Processing Systems*, Wiley, 1999 --
   FFT/IFFT datapaths and fixed-point QAM mapping used in OFDM modems.
