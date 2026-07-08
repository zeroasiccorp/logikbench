Content-Addressable Memory (CAM)
============================================

## Description

**Source:** [rtl/cam.v](rtl/cam.v)

Parametrized binary exact-match CAM with `2**AW` entries of `DW`-bit keys.
A write port loads entry `waddr` with key `wdata` and a valid bit `wvalid`.
The search port compares `sdata` against every valid entry in parallel and
returns `match` (any hit) and `match_addr` (lowest matching entry index).
Search compare is combinational; `match`/`match_addr` are registered.

The RTL contains the circuit: a `DW`-bit key array and a valid vector, one
comparator per entry (generated), an OR reduction for `match`, and a
priority encoder for `match_addr`.

## Parameters

- DW: key (data) width
- AW: address width; DEPTH = 2**AW entries

## Synthesis mapping

Maps to flip-flops (the key/valid storage) + `DEPTH` `DW`-bit equality
comparators + an OR tree + a priority encoder. It does NOT map to a dense RAM
(no address-indexed read), so LUT/FF usage scales with DEPTH*DW; this is a
comparator-dominated pattern rather than a BRAM one.

## Original Sources

- https://github.com/zeroasiccorp/logikbench/logikbench/cam

## References

### Algorithm / standard

- K. Pagiamtzis and A. Sheikholeslami, "Content-Addressable Memory (CAM)
  Circuits and Architectures: A Tutorial and Survey," IEEE J. Solid-State
  Circuits, vol. 41, no. 3, pp. 712-727, 2006.

### Hardware implementation

- Follows the standard register-based exact-match CAM architecture (per-entry
  key registers + parallel comparators + priority encoder). This is an original
  implementation; it follows the cited architecture but is not copied from it.

## License

- MIT (See LICENSE for more details)

## Modifications

- Original implementation.
