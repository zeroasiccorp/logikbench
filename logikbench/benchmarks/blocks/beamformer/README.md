# beamformer

**Source:** [rtl/beamformer.v](rtl/beamformer.v)

A parametrized N-channel delay-and-sum receive beamformer, the core of phased-
array and ultrasound receive front ends.

## What it is

Each of `NCHAN` channels applies a programmable delay (focus/steering) to its
incoming sample stream and an apodization weight, and all channels are summed
into one focused output sample: `beam[n] = sum_c weight_c * sample_c[n - d_c]`.
Delays and weights are held inputs (configured per beam); samples stream in on
`in_valid` and one focused sample streams out on `out_valid` (3-cycle latency).

## Circuit

```
beamformer                top: NCHAN channels, shared summation
+- beamformer_channel      RAM-based delay line + apodization multiply (x NCHAN)
|  +- la_dpram             circular-buffer delay memory (lambdalib dependency)
+- beamformer_sum          sign-extending adder tree, registered output
```

The per-channel delay is **RAM-based**: incoming samples are written into a
circular buffer (lambdalib `la_dpram`, reused via a dependency fileset) and the
delayed sample is read back at address `wptr - delay`. Because `la_dpram` has a
registered read that returns old data on a same-address read/write collision,
`delay == 0` (the current sample) is served by a one-cycle-aligned bypass
instead of the RAM.

## Parameters

- `NCHAN` - number of channels (default 8); sets the parallel hardware and the
  adder-tree width. RAM-based, so cost is ~linear in `NCHAN`.
- `DW`    - sample width, signed (default 12)
- `WW`    - apodization weight width, signed (default 12)
- `DEPTH` - per-channel delay buffer depth (default 64); `AW = clog2(DEPTH)` is
  the delay/address width and the maximum steering delay.

## Testbench

`testbench/test_beamformer_smoke.v` is a self-checking smoke test (`lb sim`): it
drives an identical ramp on every channel so the focused output has a closed
form, and checks both the zero-delay bypass (`beam = NCHAN*k`) and a nonzero
per-channel delay through the RAM (`beam = NCHAN*k - 3`). Prints `PASSED` or
`FAILED`.

## References

* Delay-and-sum beamforming: standard phased-array / medical-ultrasound receive
  front end (per-channel focusing delay + apodization, coherent summation).
