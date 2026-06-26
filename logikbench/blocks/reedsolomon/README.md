# reedsolomon (RS(544,514) KP4 FEC codec)

## What it is

A full **Reed-Solomon RS(544,514)** codec over **GF(2^10)** -- the KP4 forward
error correction used in IEEE 802.3 (400/200/100 GbE). It corrects up to
**t=15** symbol errors per 544-symbol codeword. `reedsolomon` (top) is a
self-checking loopback: the systematic encoder feeds the full decoder
(syndrome -> Berlekamp-Massey -> Chien -> Forney -> correction) with a
per-symbol error-injection port in between, so with <= t injected errors the
recovered data equals the input.

## Parameters of the code (fixed by the standard)

- Field GF(2^10), primitive polynomial `p(x) = x^10 + x^3 + 1` (0x409),
  alpha = x.
- n = 544 symbols, k = 514, 2t = 30 parity symbols, t = 15. Symbols are 10-bit.
- Generator `g(x) = prod_{i=0}^{29} (x - alpha^i)`, **first consecutive root
  FCR = 0**. Encoder and decoder share this convention.

## Architecture

- **`rs_gfmul`** -- GF(2^10) multiplier (carryless product + fixed reduction
  mod p(x), flat XOR network). Constant operands fold to constant multipliers.
- **`rs_gfinv`** -- multiplicative inverse via a power chain (a^1022), no ROM.
- **`rs_enc`** -- systematic encoder: LFSR division by g(x), 30 constant taps;
  k data symbols pass through, then 30 parity symbols (data-then-parity, 1
  symbol/clock).
- **`rs_syndrome`** -- 30 parallel Horner cells; S_i = r(alpha^i), i=0..29.
- **`rs_kes`** -- Berlekamp-Massey key-equation solver (one iteration/clock for
  2t cycles) -> error-locator Lambda(x), degree L.
- **`rs_dec`** -- decoder top: buffers the codeword, computes syndromes, runs
  BM, forms Omega = S*Lambda mod x^2t (sequentially) and the derivative
  Lambda', then a single-pass Chien search + Forney evaluation streams the
  codeword out, XORing each error magnitude at its root location. Flags
  `uncorrectable` when the root count != deg(Lambda).
- **`reedsolomon`** -- top loopback (enc -> err_in inject -> dec).

## Interface (top)

| Signal          | Dir | Width | Meaning                                  |
|-----------------|-----|-------|------------------------------------------|
| `clk`,`rst`     | in  | 1     | clock, synchronous reset                 |
| `in_valid`      | in  | 1     | input data symbol valid                  |
| `in_sym`        | in  | 10    | input data symbol                        |
| `in_last`       | in  | 1     | last (k-th) data symbol                  |
| `err_in`        | in  | 10    | per-symbol error XORed into the codeword |
| `in_ready`      | out | 1     | encoder can accept a symbol              |
| `out_valid`     | out | 1     | recovered codeword symbol valid          |
| `out_sym`       | out | 10    | recovered symbol (first k = data)        |
| `out_last`      | out | 1     | last symbol of the recovered codeword    |
| `uncorrectable` | out | 1     | > t errors detected (not corrected)      |

## Mapping

GF arithmetic (multipliers, inverse, syndrome/Chien cells) -> XOR/AND logic in
LUTs (no DSP -- GF multiply is not integer multiply). The 544-symbol codeword
buffer is a shift register (flops); BM/Chien accumulators are flops. No vendor
DSP. (A BRAM-backed `la_spram` codeword buffer is a natural area follow-up.)

## Files

- `rtl/rs_gfmul.v`, `rs_gfinv.v`, `rs_enc.v`, `rs_syndrome.v`, `rs_kes.v`,
  `rs_dec.v`, `reedsolomon.v`.
- `genrs.py` -- computes/verifies the baked GF constants (g(x), alpha powers,
  Chien constants).
- `testbench/test_reedsolomon_smoke.v` -- Verilog-2005 self-checking round trip
  (encode -> inject 0 / 10 / 15 / 16 errors -> decode -> compare). Run:

  ```
  iverilog -g2005 -o sim.out rtl/rs_gfmul.v rtl/rs_gfinv.v rtl/rs_syndrome.v \
           rtl/rs_kes.v rtl/rs_enc.v rtl/rs_dec.v rtl/reedsolomon.v \
           testbench/test_reedsolomon_smoke.v
  vvp sim.out
  ```

## References

The RTL is an original implementation following the cited architectures; it is
not copied from any specific HDL source.

### Algorithm

1. I. S. Reed and G. Solomon, "Polynomial codes over certain finite fields,"
   *J. SIAM*, vol. 8, no. 2, pp. 300-304, 1960.
2. E. R. Berlekamp, *Algebraic Coding Theory*, 1968; J. L. Massey, "Shift-
   register synthesis and BCH decoding," *IEEE Trans. IT*, 1969.
3. G. D. Forney, "On decoding BCH codes," *IEEE Trans. IT*, vol. 11, no. 4,
   pp. 549-557, 1965.
4. IEEE Std 802.3, Clause 91 (RS-FEC, KP4 RS(544,514) over GF(2^10)).

### Hardware / reference implementation

5. R. T. Chien, "Cyclic decoding procedures for BCH codes," *IEEE Trans. IT*,
   1964 (Chien search).
6. H. Lee, "High-speed VLSI architecture for parallel Reed-Solomon decoder,"
   *IEEE Trans. VLSI Systems*, vol. 11, no. 2, 2003 (syndrome/BM/Chien/Forney
   pipeline this design follows).
