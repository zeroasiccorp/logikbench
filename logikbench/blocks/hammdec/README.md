# hammdec (Hsiao SEC-DED decoder)

## What it is

A parameterizable **Hsiao single-error-correcting, double-error-detecting
(SEC-DED) decoder**. It takes the `DW+PW`-bit systematic codeword produced by
`hammenc`, **corrects any single-bit error** and **detects (without correcting)
any double-bit error**, and outputs the `DW`-bit corrected data plus the
`PW`-bit syndrome.

It recomputes the syndrome = received check XOR (XOR of the data-bit columns of
all set data bits), using the same Hsiao parity-check matrix as `hammenc`
(check-bit columns = identity; data bit `k` = the `k`-th odd-weight, weight>=3
`PW`-bit column, lightest first). Because every column is odd weight:

- syndrome == 0: no error;
- syndrome == column(k) (odd weight >= 3): single data-bit error -> corrected;
- syndrome is a unit vector (weight 1): single check-bit error, data clean;
- syndrome != 0 and even weight: double error, detected (not corrected).

The column table must match `hammenc` (the round-trip test guards this).

## Interface

| Signal     | Dir | Width | Meaning                                  |
|------------|-----|-------|------------------------------------------|
| `clk`      | in  | 1     | clock (used when `PIPELINE=1`)           |
| `nreset`   | in  | 1     | async active-low reset (`PIPELINE=1`)    |
| `in`       | in  | DW+PW | received codeword `{check, data}`        |
| `out`      | out | DW    | corrected data                           |
| `syndrome` | out | PW    | error syndrome (0 = clean)               |

## Parameters

| Parameter  | Default | Meaning                                          |
|------------|---------|--------------------------------------------------|
| `DW`       | 64      | data (information) bits                           |
| `PW`       | 8       | Hsiao check bits                                 |
| `PIPELINE` | 1       | 1 = register the input (1-cycle), 0 = pure comb. |

## Mapping

Combinational XOR parity trees (syndrome) plus equality compares against the
constant-folded column table and the correction XORs; optional `PIPELINE` input
register. Maps to LUTs (+ FFs when pipelined); no DSP, no BRAM.

## Files

- `rtl/hammdec.v` -- the decoder.
- `testbench/test_hammdec_smoke.v` -- Verilog-2005 self-checking smoke test:
  `hammenc` -> error injection -> `hammdec` round-trip. Checks no-error
  (decoded == data, syndrome 0), single-bit error corrected at every codeword
  position (data + check), and double-bit error detected (syndrome != 0). Run
  (compile both RTL files):

  ```
  iverilog -g2005 -o sim.out ../hammenc/rtl/hammenc.v rtl/hammdec.v \
           testbench/test_hammdec_smoke.v
  vvp sim.out
  ```

  (Add `-DWAVES` for a VCD dump.)

## References

This `hammdec.v` is an original RTL implementation of the Hsiao SEC-DED code; it
is not derived from a specific HDL source. It is the decode counterpart of
`hammenc` and must use the identical column assignment.

### Algorithm and code

1. R. W. Hamming, "Error detecting and error correcting codes," *Bell System
   Technical Journal*, vol. 29, no. 2, pp. 147-160, Apr. 1950.
2. M. Y. Hsiao, "A class of optimal minimum odd-weight-column SEC-DED codes,"
   *IBM Journal of Research and Development*, vol. 14, no. 4, pp. 395-401,
   Jul. 1970. (the specific SEC-DED construction implemented here)
3. S. Lin and D. J. Costello, *Error Control Coding*, 2nd ed., Prentice Hall,
   2004. (syndrome decoding of linear block codes)

### Hardware implementation

4. The Hsiao construction is itself the hardware optimization: odd-weight
   columns let single-bit data errors map to odd-weight syndromes and double
   errors to even-weight syndromes, so correction/detection is a set of
   syndrome equality compares with minimal XOR depth -- see Ref. 2.
5. C. L. Chen and M. Y. Hsiao, "Error-correcting codes for semiconductor memory
   applications: A state-of-the-art review," *IBM Journal of Research and
   Development*, vol. 28, no. 2, pp. 124-134, Mar. 1984. (SEC-DED ECC in
   hardware/memory)
