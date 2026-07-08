# hamming (Hsiao SEC-DED codec)

**Source:** [rtl/hamming.v](rtl/hamming.v)

## What it is

A parameterizable **Hsiao single-error-correcting, double-error-detecting
(SEC-DED) codec**: an encoder that appends `PW` check bits to a `DW`-bit data
word to form a `DW+PW`-bit systematic codeword, and a decoder that **corrects
any single-bit error** and **detects (without correcting) any double-bit
error**, returning the `DW`-bit corrected data and the `PW`-bit syndrome. This
is the standard ECC used on memory/data paths. `hamming` (top) wires the
encoder's codeword into the decoder through an error-injection XOR (`err_mask`),
so with `err_mask = 0` the decoded data equals the input data and the syndrome
is zero; nonzero `err_mask` exercises correction/detection.

## Architecture

The parity-check matrix is `H = [ M | I_PW ]`: the check bits are the `PW` unit
vectors (identity block), and data bit `k` owns column `M_k` = the `k`-th
distinct **odd-weight, weight>=3** `PW`-bit vector, taken lightest-weight first
(all weight-3 columns, then weight-5, ...). The column table is built once
(popcount + weight-ordered fill in an `always @*` block, not a Verilog function)
and folds to constants at synthesis, so each check bit is a fixed XOR of data
bits. Because every column is odd weight:

- syndrome == 0: no error;
- syndrome == column(k) (odd weight >= 3): single data-bit error -> corrected;
- syndrome is a unit vector (weight 1): single check-bit error, data clean;
- syndrome != 0 and even weight: double error, detected (not corrected).

- **`hamming_enc`** -- computes the `PW` check bits as constant XOR trees over
  the data and emits the systematic codeword `{check, data}`.
- **`hamming_dec`** -- recomputes the syndrome (received check XOR check from
  data), compares it against the constant-folded column table, and corrects the
  matching data bit; outputs corrected data plus the syndrome.
- **`hamming`** -- top codec: `hamming_enc` -> `err_mask` XOR -> `hamming_dec`.

The encoder and decoder MUST use the identical column assignment (the round-trip
test guards this).

## Interface

| Signal     | Dir | Width | Meaning                                    |
|------------|-----|-------|--------------------------------------------|
| `clk`      | in  | 1     | clock (used when `PIPELINE=1`)             |
| `nreset`   | in  | 1     | async active-low reset (`PIPELINE=1`)      |
| `in`       | in  | DW    | data word                                  |
| `err_mask` | in  | DW+PW | bit-flips applied to the codeword          |
| `out`      | out | DW    | corrected data                             |
| `syndrome` | out | PW    | error syndrome (0 = clean)                 |

## Parameters

| Parameter  | Default | Meaning                                          |
|------------|---------|--------------------------------------------------|
| `DW`       | 64      | data (information) bits                           |
| `PW`       | 8       | Hsiao check bits (need enough odd-wt cols >= DW)  |
| `PIPELINE` | 1       | 1 = register the input (1-cycle), 0 = pure comb. |

`PW` must satisfy: count of odd-weight, weight>=3 `PW`-bit columns >= `DW`
(e.g. DW=64 needs PW=8: 56 weight-3 + 8 weight-5).

## Mapping

Combinational XOR parity trees (encode check bits and decode syndrome; the
column table is constant-folded), plus syndrome equality compares against the
column table and the correction XORs, plus the optional `PIPELINE` input
registers. Maps to LUTs (+ FFs when pipelined); no DSP, no BRAM.

## Files

- `rtl/hamming_enc.v`, `rtl/hamming_dec.v` -- encoder / decoder.
- `rtl/hamming.v` -- top codec (enc -> err_mask -> dec).
- `testbench/test_hamming_smoke.v` -- Verilog-2005 self-checking round-trip
  smoke test: checks no-error (out == data, syndrome 0), single-bit error
  corrected at every codeword position (data + check), and double-bit error
  detected (syndrome != 0). Run:

  ```
  iverilog -g2005 -o sim.out rtl/hamming_enc.v rtl/hamming_dec.v rtl/hamming.v \
           testbench/test_hamming_smoke.v
  vvp sim.out
  ```

  (Add `-DWAVES` for a VCD dump.)

## References

This RTL is an original implementation of the Hsiao SEC-DED code; it is not
derived from a specific HDL source.

### Algorithm

1. R. W. Hamming, "Error detecting and error correcting codes," *Bell System
   Technical Journal*, vol. 29, no. 2, pp. 147-160, Apr. 1950.
2. M. Y. Hsiao, "A class of optimal minimum odd-weight-column SEC-DED codes,"
   *IBM Journal of Research and Development*, vol. 14, no. 4, pp. 395-401,
   Jul. 1970. (the specific SEC-DED construction implemented here)
3. S. Lin and D. J. Costello, *Error Control Coding*, 2nd ed., Prentice Hall,
   2004. (linear block codes, parity-check matrices, syndrome decoding)

### Hardware implementation

4. The Hsiao construction is itself the hardware optimization: the minimum
   odd-weight-column SEC-DED matrix minimizes the parity-tree (XOR) fan-in/depth
   and balances per-check-bit cost, and lets single-bit errors map to
   odd-weight syndromes and double errors to even-weight syndromes so that
   correction/detection is a set of syndrome equality compares -- see Ref. 2.
5. C. L. Chen and M. Y. Hsiao, "Error-correcting codes for semiconductor memory
   applications: A state-of-the-art review," *IBM Journal of Research and
   Development*, vol. 28, no. 2, pp. 124-134, Mar. 1984. (SEC-DED ECC in
   hardware/memory)
