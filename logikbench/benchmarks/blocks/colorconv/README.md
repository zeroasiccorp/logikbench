# colorconv

**Source:** [rtl/colorconv.v](rtl/colorconv.v)

A streaming color-space conversion image accelerator: it converts one pixel per
cycle between RGB and YCbCr using fixed-point BT.601 coefficients.

## What it is

Digital video and image pipelines constantly convert between the RGB color
space (capture/display) and the YCbCr luma/chroma space (compression/transport).
`colorconv` is the small, fixed-latency datapath that performs that conversion
on a pixel stream, with a `mode` input selecting the direction:

- `mode 0`: **RGB to YCbCr** (`c0=Y, c1=Cb, c2=Cr`)
- `mode 1`: **YCbCr to RGB** (`r,g,b` carry `Y,Cb,Cr`; `c0=R, c1=G, c2=B`)
- `mode 2`: **RGB to grayscale** (`c0=c1=c2=Y`)

## Circuit

```
colorconv                streaming top: register in, convert, register out
+- colorconv_matrix (x3) per-channel 3-term fixed-point multiply-add
+- colorconv_clamp  (x3) saturate each signed result to [0, 2^DW-1]
```

Each output channel is a dot product of three BT.601 coefficients with the
three input components plus a bias, rounded and arithmetic-right-shifted by 8
(coefficients are Q0.8, i.e. scaled by 256), then saturated. The coefficient
set (and the chroma bias `2^(DW-1)`) is selected combinationally from `mode`.
The pipeline is two registered stages, with `in_valid` pipelined to `out_valid`.

## Parameters

- `DW` = 8 : pixel component width (bits per channel).

## Coefficients

BT.601 full-range, scaled by 256 and rounded:
`Y = (77*R + 150*G + 29*B) >> 8`,
`Cb = (-43*R - 85*G + 128*B) >> 8 + 128`,
`Cr = (128*R - 107*G - 21*B) >> 8 + 128`, with the matching inverse for
`mode 1`. The `+128` bias generalizes to `2^(DW-1)`.

## Testbench

`testbench/test_colorconv_smoke.v` is a self-checking smoke test (`lb sim`): it
streams the primaries (white/black/red/green/blue) plus an arbitrary pixel and
compares the YCbCr outputs against BT.601 golden values computed in real
arithmetic (within a small fixed-point tolerance), checks the grayscale mode
produces three equal outputs, and checks the neutral YCbCr-to-RGB point. Prints
`PASSED` or `FAILED`.

## References

* ITU-R BT.601, "Studio encoding parameters of digital television for standard
  4:3 and wide-screen 16:9 aspect ratios."
