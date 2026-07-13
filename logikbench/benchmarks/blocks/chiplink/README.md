# chiplink

**Source:** [rtl/chiplink.v](rtl/chiplink.v)

A chiplet die-to-die (D2D) link in the style of **AIB** (Advanced Interface
Bus) and **BoW** (Bunch of Wires): a source-synchronous parallel interface that
serializes words across many wires, tolerates independent per-lane skew, and
recovers word alignment with a training pattern.

## What it is

A `DW`-bit word is sent across `NLANES` parallel wires, `SER = DW/NLANES` bits
per lane per frame (a frame is `SER` cycles). Each wire has its own flight time,
so the receiver must **deskew** the lanes and **realign** them into words before
the payload is meaningful. This is a synthesizable model of the *link logic* --
framing, training, per-lane deskew, and word alignment -- not the analog/DDR
PHY. TX and RX are wired lane-to-lane in one block so it is self-contained and
testable, with a per-lane skew input that delays each lane between them.

## Circuit

```
chiplink                top: TX -> per-lane skew -> RX; trains until aligned
+- chiplink_tx          serialize word over NLANES lanes; send a one-hot
|                       alignment marker per frame during training
+- (per-lane skew)      delays each lane independently (models flight-time skew)
+- chiplink_rx          per-lane history + word assembly; emits DW words
   +- chiplink_train    per lane: find the marker's phase, set the deskew delay,
                        assert aligned when every lane is locked
```

- **Training / deskew:** during training every lane sends a one-hot marker (a
  single `1` at frame phase 0). The marker arrives at a different receive phase
  per lane; each `chiplink_train` latches that phase and sets a per-lane delay
  so the marker -- and hence every payload bit -- realigns to a common frame
  boundary. `aligned` asserts once all lanes are locked; the TX then switches
  from markers to data.
- **Data:** after alignment the TX carries one word per frame (handshaked with
  `din_ready`); the RX deskews each lane, assembles the word, and presents it on
  `dout`/`dout_valid`.

## Parameters

- `NLANES` (default 8): number of parallel wires.
- `DW` (default 32): word width. Must be a multiple of `NLANES`.
- `SER = DW/NLANES`: bits per lane per frame; must be >= 2 (so the marker is
  unambiguous). Per-lane skew must be < `SER` cycles (intra-frame deskew).

## Testbench

`testbench/test_chiplink_smoke.v` applies a different skew to each lane, runs
training, waits for `aligned`, then streams distinct known words through the
link and checks that the receive side reconstructs the same words in order
(found as a contiguous run in the received stream, to absorb the fixed link
latency). Prints `PASSED`/`FAILED`, with a watchdog.

## References

This `chiplink.v` is an original RTL implementation, written from AIB/BoW-style
source-synchronous die-to-die link principles and a standard per-lane deskew /
word-alignment architecture; it is not derived from a specific HDL source.

* Advanced Interface Bus (AIB), Intel / CHIPS Alliance:
  https://github.com/chipsalliance/AIB-specification
* Bunch of Wires (BoW) / Open Domain-Specific Architecture (ODSA), Open Compute
  Project: https://www.opencompute.org/
