# chiplink

**Source:** [rtl/chiplink.v](rtl/chiplink.v)

A source-synchronous parallel chiplet die-to-die (D2D) link controller in the
style of AIB / BoW / UCIe -- the **digital** layer of the link. Single data
rate (SDR): the transmitter forwards its clock alongside the lane data, and the
receiver captures in that forwarded-clock domain, deskews the lanes, reassembles
the word, and crosses into its own core clock through an asynchronous FIFO.

## What it is

The block is a complete transmit endpoint and receive endpoint whose link wires
are exposed at the top level (they are NOT looped back inside the design -- a
testbench or the far die closes the link, applying per-lane skew and forwarded-
clock flight delay). A DW-bit word is serialized across NLANES wires over
SER = DW/NLANES forwarded-clock cycles (one bit per lane per cycle); the
receiver trains on a per-frame marker to deskew the lanes, reassembles the word,
and hands it to the core clock domain.

## Circuit / clock domains

```
tx_clk domain            | forwarded clock          | rx_clk domain
-------------------------|--------------------------|----------------------
chiplink_tx              |  chiplink_rx (capture)   |  chiplink_rx (core)
  serialize + forward    |   sample lanes (rx_fwclk)|   pop FIFO -> rx_dout
  clock + training marker|   per-lane deskew (train)|   rx_aligned
                         |   reassemble word        |
                         |   push -> [cdc_fifo] ------> pop
```

- **chiplink_tx** (tx_clk): forwards tx_clk as tx_fwclk, drives one lane bit per
  cycle, sends a frame-phase-0 training marker after reset, then data.
- **chiplink_train** (rx_fwclk): per-lane lock to the marker, reports its capture
  phase.
- **chiplink_rx** (rx_fwclk -> rx_clk): captures lanes in the forwarded-clock
  domain, deskews each lane relative to lane 0 (aligning to the latest lane),
  reassembles the word, pushes it into the CDC FIFO; pops in rx_clk.
- **chiplink_cdc_fifo**: gray-code asynchronous FIFO with 2-flop pointer
  synchronizers -- the real clock-domain crossing from the forwarded clock into
  the receiver core clock.

## Parameters

- `NLANES` (default 8): parallel wires.
- `DW` (default 32): word width. `SER = DW/NLANES` must be a power of two.

## Layer / scope

This models the **digital source-synchronous link controller**: clock
forwarding (as a distinct clock domain), the SDR gearbox, per-lane whole-UI
deskew + training, the clock-domain-crossing FIFO, and word alignment. Lane 0 is
the deskew reference (earliest lane); skew is resolved within one frame
(whole-UI, < SER cycles).

### Not modeled (mixed-signal PHY IP, out of scope for RTL)

- Analog drivers / receivers / termination / ESD.
- DLL / phase-interpolator clock eye-centering.
- Sub-UI analog per-bit deskew.
- The DDR SerDes front-end. (A DDR gearbox would double the per-wire rate but
  requires the analog eye-centering above to capture both edges, so the digital
  model is SDR; DDR is a possible extension that depends on the out-of-scope
  PHY.)
- Lane redundancy / repair, inter-frame (> one frame) skew.

## Testbench

`testbench/test_chiplink_smoke.v` is a self-checking smoke test (`lb sim`). It
runs tx_clk and rx_clk at different, asynchronous frequencies (10 ns / 14 ns) to
exercise the clock-domain crossing, connects the link externally with a distinct
per-lane whole-cycle skew, waits for `rx_aligned` after training, then streams K
known words on the transmit side and verifies the same K words emerge in order
on `rx_dout` in the receiver clock domain (having crossed the async FIFO),
printing `PASSED` or `FAILED`.

## References

This `chiplink.v` is an original RTL implementation, written from
source-synchronous (forwarded-clock) parallel die-to-die link principles
(AIB/BoW/UCIe) and a standard DDR-gearbox + per-lane-deskew + clock-domain-
crossing architecture; it is not derived from a specific HDL source.

* Intel Advanced Interface Bus (AIB).
* Open Compute Project Bunch of Wires (BoW) / OpenHBI.
* Universal Chiplet Interconnect Express (UCIe) specification.
