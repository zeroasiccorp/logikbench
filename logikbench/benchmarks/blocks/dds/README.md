# dds

**Source:** [rtl/dds.v](rtl/dds.v)

A direct digital synthesizer (DDS) / numerically-controlled oscillator (NCO):
a phase accumulator drives a quarter-wave sine ROM to generate signed sine and
cosine samples at a programmable frequency.

## What it is

Each cycle a phase accumulator adds a frequency control word (`fcw`) to the
phase; the output frequency is `fout = fclk * fcw / 2^PW`. The top `AW` bits of
the phase address a sine ROM that reconstructs a full-period sine (and cosine, a
quarter period ahead) from a single stored quarter wave.

## Circuit

```
dds                     top: accumulator + LUT, registered sine/cosine outputs
+- dds_phase_acc        PW-bit phase accumulator (phase += fcw when enabled)
`- dds_lut              quarter-wave sine ROM + quadrant symmetry -> sine, cosine
```

- **`dds_phase_acc`** -- a `PW`-bit accumulator; synchronous, active-low reset
  clears the phase.
- **`dds_lut`** -- stores only a quarter wave (angles 0..pi/2, `2^(AW-2)`
  entries). Quadrant decode of the top two phase bits reconstructs the full
  signed period (rising/falling mirror via `NQ-1-idx`, sign from the upper
  quadrants); cosine is the same sample a quarter period ahead
  (`sample(phase + 2^(AW-2))`).

## Parameters

| Param | Default | Meaning |
|-------|---------|---------|
| `PW`  | 24      | phase accumulator width (frequency resolution) |
| `AW`  | 10      | sine-ROM phase address bits (full period = `2^AW`) |
| `OW`  | 12      | signed output sample width |

## Generation

The quarter-wave ROM in `rtl/dds_lut.v` is a synthesizable constant `case`
table generated at build time (no `$sin`, no `$readmemh`): entry `i` holds
`round(sin(pi/2 * i / 2^(AW-2)) * (2^(OW-1)-1))`. It is generated for the
default `AW=10`, `OW=12` and must be regenerated if those change.

## Testbench

`testbench/test_dds_smoke.v` is a self-checking smoke test (`lb sim`): it sets a
frequency control word that advances the top phase bits by one per cycle
(one 1024-sample period), captures the sine/cosine stream, and checks the
waveform shape -- zero / +full / zero / -full at the quadrant boundaries,
constant power (`sin^2 + cos^2`), and cosine leading sine by a quarter period.
Tolerances absorb LUT quantization. Prints `PASSED`/`FAILED`.

## References

This `dds.v` is an original RTL implementation, written from the direct digital
synthesis (NCO) definition and the standard phase-accumulator + quarter-wave
sine-LUT architecture; it is not derived from a specific HDL source.

* J. Tierney, C. Rader, B. Gold, "A Digital Frequency Synthesizer," IEEE Trans.
  Audio and Electroacoustics, vol. 19, no. 1, pp. 48-57, 1971.
* Standard quarter-wave-symmetry sine-lookup NCO architecture.
