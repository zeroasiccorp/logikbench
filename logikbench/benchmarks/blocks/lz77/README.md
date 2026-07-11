# lz77 (hash-based LZSS compressor codec)

**Source:** [rtl/lz77.v](rtl/lz77.v)

## What it is

A hardware **LZ77/LZSS compressor** (encoder) plus a matching **decompressor**
(decoder), wired together as a self-checking loopback so the reconstructed byte
stream equals the input. The encoder uses the standard FPGA-compressor
structure: a **hashed match finder** over a **32 KB sliding window** with a
**64-byte parallel match-extend** datapath. `lz77` (top) feeds the encoder's
token stream straight into the decoder.

## Architecture

- **`lz77_enc`** - a 4-byte multiplicative hash of the current position indexes
  a 16K-entry table that holds the `NWAY=4` most-recent positions with that
  hash. The candidates are extended in parallel: each gets a replicated history
  bank (`lz77_hbank`) and a `lz77_cand` match extender that compares up to
  `WW=64` bytes in one cycle. The longest match `>= MINMATCH=4` wins and emits a
  `{len,dist}` match token (advance `len`); otherwise a literal token (advance
  1). The 32 KB history is word-organized byte-write BRAM so the two words
  covering any source byte read in a single cycle. ~64 B/cycle on long matches.
- **`lz77_dec`** - consumes tokens and reconstructs into a 32 KB circular output
  history (synchronous-read BRAM with a 1-deep write-forward for the `dist==1`
  read-after-write hazard); a match copies `len` bytes from `dist` back, one per
  cycle, with overlap (RLE) support.
- **`lz77`** - top: `lz77_enc -> lz77_dec` loopback example.
- Submodules: **`lz77_hash`** (constant-multiply hash), **`lz77_cand`** (gather
  + overlap + leading-match length), **`lz77_hbank`** (even/odd word history
  bank replica).

## Correctness vs. ratio

The hash is only a **hint**: every candidate is verified by the explicit byte
compare and gated by `dist` in `[1, min(pos, WIN)]`, so a stale, aliased, or
garbage hash entry can never produce an invalid match -- it simply becomes a
literal. The codec is **lossless regardless of match quality**. Two deliberate
*ratio-only* simplifications (never correctness): only the current position is
inserted into the hash table each step (interior positions are skipped), and
only `NWAY` candidates are checked.

## Parameters

| Param      | Default | Meaning                                         |
|------------|---------|-------------------------------------------------|
| `WIN`      | 32768   | history window size in bytes (15-bit distances) |
| `WW`       | 64      | parallel compare / max match length in bytes    |
| `NWAY`     | 4       | candidate positions per hash bucket             |
| `HASHBITS` | 12      | hash-table entries = 2^HASHBITS (4096)          |
| `MINMATCH` | 4       | shortest emitted match (= hash byte count)      |
| `PW`       | 16      | stored position width (hash entry = NWAY*PW)    |

## Interface

| Signal      | Dir | Width | Meaning                          |
|-------------|-----|-------|----------------------------------|
| `clk`       | in  | 1     | clock                            |
| `rst`       | in  | 1     | synchronous, active high         |
| `in_valid`  | in  | 1     | input byte valid                 |
| `in_byte`   | in  | 8     | input byte                       |
| `in_last`   | in  | 1     | last byte of the stream (flush)  |
| `in_ready`  | out | 1     | codec can accept a byte          |
| `out_valid` | out | 1     | reconstructed byte valid         |
| `out_byte`  | out | 8     | reconstructed byte               |

## Mapping

Hash table (16K x 4 positions), the shared 32 KB history (even/odd word,
byte-write enable, single-port, probed serially over NWAY candidates), and the
decoder's 32 KB output history map to **BRAM** (single-port `la_spram`, half the
ASIC area of dual-port). The 64-byte parallel compare, barrel-shift gather,
candidate select, and the circular byte-write commit map to **LUTs + FFs**. The
constant-multiply hash maps to a small multiplier.

With defaults the block synthesizes to roughly ~17.4K LUTs, ~660 FFs,
2 multipliers, and the three memories as BRAM macros. The hash table dominates
BRAM (16384 x 96 bits = 192 KB); `HASHBITS` and `NWAY` trade compression ratio
for memory footprint.

## Files

- `rtl/lz77_enc.v`, `rtl/lz77_dec.v` -- encoder / decoder.
- `rtl/lz77.v` -- top loopback codec.
- `rtl/lz77_hash.v`, `rtl/lz77_cand.v`, `rtl/lz77_hbank.v` -- submodules.
- `testbench/test_lz77_smoke.v` -- Verilog-2005 self-checking round-trip
  (random, periodic/RLE, tiny-alphabet inputs -> enc -> dec -> compare). Run:

  ```
  iverilog -g2005 -o sim.out rtl/lz77_hash.v rtl/lz77_cand.v rtl/lz77_hbank.v \
           rtl/lz77_enc.v rtl/lz77_dec.v rtl/lz77.v testbench/test_lz77_smoke.v
  vvp sim.out
  ```

## References

The RTL is an original implementation; it is not derived from a specific HDL
source.

### Algorithm

1. J. Ziv and A. Lempel, "A universal algorithm for sequential data
   compression," *IEEE Trans. Information Theory*, vol. 23, no. 3,
   pp. 337-343, 1977. (LZ77)
2. J. A. Storer and T. G. Szymanski, "Data compression via textual
   substitution," *Journal of the ACM*, vol. 29, no. 4, pp. 928-951, 1982.
   (LZSS: explicit literal/match flagging)
3. DEFLATE Compressed Data Format Specification, RFC 1951, 1996. (hashed
   3/4-byte match finding over a 32 KB window, as in zlib)

### Hardware / reference implementation

4. zlib `deflate.c` (J. Gailly, M. Adler) -- the hash-chain match finder
   (4-byte hash, recent-position chains) this design parallelizes.
5. M. S. Abdelfattah et al., "Gzip on a chip: high performance lossless data
   compression on FPGAs using OpenCL," *IWOCL*, 2014. (parallel windowed
   LZ77 match finding on FPGA)
