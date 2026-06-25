# hammenc (Hsiao SEC-DED encoder)

## What it is

A parameterizable **Hsiao single-error-correcting, double-error-detecting
(SEC-DED) encoder**. It appends `PW` check bits to a `DW`-bit data word to form
a `DW+PW`-bit systematic codeword that `hammdec` can correct (1-bit) and detect
(2-bit). This is the standard ECC used on memory/data paths.

The parity-check matrix is `H = [ M | I_PW ]`: the check bits are the `PW` unit
vectors (identity block), and data bit `k` owns column `M_k` = the `k`-th
distinct **odd-weight, weight>=3** `PW`-bit vector, taken lightest-weight first
(all weight-3 columns, then weight-5, ...). The column table is built once
(popcount + weight-ordered fill) and folds to constants at synthesis, so each
check bit is a fixed XOR of data bits. The encoder and `hammdec` MUST use the
same column assignment (the round-trip test guards this).

## Interface

| Signal   | Dir | Width | Meaning                                    |
|----------|-----|-------|--------------------------------------------|
| `clk`    | in  | 1     | clock (used when `PIPELINE=1`)             |
| `nreset` | in  | 1     | async active-low reset (`PIPELINE=1`)      |
| `in`     | in  | DW    | data word                                  |
| `out`    | out | DW+PW | codeword `{check[PW], data[DW]}`           |

## Parameters

| Parameter  | Default | Meaning                                          |
|------------|---------|--------------------------------------------------|
| `DW`       | 64      | data (information) bits                           |
| `PW`       | 8       | Hsiao check bits (need enough odd-wt cols >= DW)  |
| `PIPELINE` | 1       | 1 = register the input (1-cycle), 0 = pure comb. |

`PW` must satisfy: count of odd-weight, weight>=3 `PW`-bit columns >= `DW`
(e.g. DW=64 needs PW=8: 56 weight-3 + 8 weight-5).

## Mapping

Combinational XOR parity trees (the column table is constant-folded), plus the
optional `PIPELINE` input register. Maps to LUTs (+ FFs when pipelined); no DSP,
no BRAM.

## Files

- `rtl/hammenc.v` -- the encoder.
- The encoder is verified by the encode/decode round-trip smoke test at
  `../hammdec/testbench/test_hammdec_smoke.v` (no-error, single-error
  correction at every position, and double-error detection).

## References

This `hammenc.v` is an original RTL implementation of the Hsiao SEC-DED code; it
is not derived from a specific HDL source.

### Algorithm and code

1. R. W. Hamming, "Error detecting and error correcting codes," *Bell System
   Technical Journal*, vol. 29, no. 2, pp. 147-160, Apr. 1950.
2. M. Y. Hsiao, "A class of optimal minimum odd-weight-column SEC-DED codes,"
   *IBM Journal of Research and Development*, vol. 14, no. 4, pp. 395-401,
   Jul. 1970. (the specific SEC-DED construction implemented here)
3. S. Lin and D. J. Costello, *Error Control Coding*, 2nd ed., Prentice Hall,
   2004. (linear block codes, parity-check matrices)

### Hardware implementation

4. The Hsiao construction is itself the hardware optimization: minimum
   odd-weight columns minimize the parity-tree (XOR) fan-in/depth and balance
   per-check-bit cost vs. a plain Hamming code -- see Ref. 2.
5. C. L. Chen and M. Y. Hsiao, "Error-correcting codes for semiconductor memory
   applications: A state-of-the-art review," *IBM Journal of Research and
   Development*, vol. 28, no. 2, pp. 124-134, Mar. 1984. (SEC-DED ECC in
   hardware/memory)
