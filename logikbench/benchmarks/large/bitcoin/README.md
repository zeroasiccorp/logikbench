# bitcoin

**Source:** [rtl/bitcoin.v](rtl/bitcoin.v)

A parametrized Bitcoin proof-of-work miner: it searches for a block-header
nonce whose double-SHA256 digest is at or below the difficulty target. Built on
the [sha256](../../blocks/sha256/README.md) core, and modeled after the `hft`
block (a top composing named sub-modules with a self-checking smoke test).

## What it is

Bitcoin PoW is `SHA256d(header) = SHA256(SHA256(header))` over the 80-byte block
header, iterated over the 32-bit nonce field until the little-endian digest is
`<= target`. This core does exactly that, with `NENGINES` parallel search lanes.

## Circuit

```
bitcoin                top: split header into two SHA-256 blocks (once),
                       generate NENGINES lanes over interleaved nonces,
                       arbitrate the golden nonce
+- bitcoin_engine          one lane: step the nonce, run SHA256d, compare
   +- bitcoin_sha256d      double-SHA256: init(block_a) -> next(block_b+nonce)
   |  +- sha256_core       -> init(pad(H1)); reuses the sha256 benchmark core
   +- bitcoin_compare      byte-reverse the digest, unsigned <= target
```

- **Header layout** (as hashed, MSB first): `block_a = header[639:128]` (bytes
  0..63, nonce-independent), `block_b = header[127:0] + SHA padding` (bytes
  64..79, holds the nonce at block bits `[415:384]`). Only the nonce word
  changes per trial; `block_a` and the rest of `block_b` are broadcast to every
  lane.
- **Parallelism / size:** `NENGINES` sets the number of lanes (~one SHA-256
  core each). Default **128** (~1.3M cells); scale up for authentic
  miner-array sizes. Set via `set_param('NENGINES', ...)` in `bitcoin.py`
  (the flow forwards it to the mapper) or the RTL default in `bitcoin.v`.
- **SHA-256 reuse:** `sha256_core` is pulled in from the `sha256` benchmark as
  a dependency fileset (`add_depfileset(Sha256())`) -- no duplicated RTL.

### On the midstate optimization

Real miners precompute the "midstate" (the SHA-256 state after `block_a`, which
is nonce-independent) once and only re-run `block_b` per nonce. The stock
`sha256_core` starts every hash from the standard IV and exposes no state-load
port, so this core re-runs `block_a` each trial (init(a) -> next(b) -> init(c)).
This is functionally identical and keeps the SHA-256 core unmodified; the gate
count (the benchmark's purpose) is unchanged. Applying midstate reuse would
require a core variant with a hash-state input.

## Parallelism and I/O

The `NENGINES` lanes partition the nonce space by interleaving: lane `e` tries
`nonce_base + e`, then steps by `NENGINES`, so together they cover every nonce
with no gaps or overlap at ~`NENGINES`x the throughput of a single lane.

Nonce search is **compute-bound, not bandwidth-bound**, which is why it scales
to large lane counts with no shared bus or memory pressure:

- **Nonces are generated internally** by each lane's counter, not fed in --
  sweeping billions of nonces moves zero bytes across a lane boundary. Each
  lane only inserts its own 32-bit nonce into its local copy of `block_b`.
- **Inputs are loaded once per work item.** The header, `block_a`/
  `block_b_base`, and `target` are broadcast to all lanes as static wires; a new
  header arrives rarely relative to the ~2^32 nonces swept between them.
- **Output is one 32-bit `golden_nonce`**, and only when a lane wins (rare).

So per hash the I/O is negligible while the compute is ~192 SHA-256 rounds
(three block compressions). The first lane to see `H2 <= target` raises `found`,
and the top reports the lowest-index winner. The only cost that grows with
`NENGINES` is the physical fanout of the broadcast nets (a buffering/timing
concern handled by synthesis, not a data-bandwidth bottleneck) -- each lane's
hot data (its nonce and SHA-256 working state) is entirely local. This is the
structural reason nonce search is the canonical embarrassingly-parallel
workload.

## Testbench

`testbench/test_bitcoin_smoke.v` is a self-checking smoke test (`lb sim`): it
loads the real Bitcoin **genesis block** header and target, seeds the nonce
base just below the known winning nonce `0x1dac2b7c` (2083236893), and checks
that the miner finds it -- exercising the full SHA256d datapath, the target
compare, and multi-lane arbitration end-to-end. Prints `PASSED`/`FAILED`. (A
full 2^32 sweep is infeasible in simulation, so the base is seeded near the
golden nonce; the testbench uses `NENGINES = 2`.)

## References

* S. Nakamoto, "Bitcoin: A Peer-to-Peer Electronic Cash System," 2008.
  https://bitcoin.org/bitcoin.pdf
* FIPS PUB 180-4, "Secure Hash Standard (SHS)," NIST, Aug. 2015.
* Reuses [secworks/sha256](../../blocks/sha256/README.md) (BSD-2-Clause).
