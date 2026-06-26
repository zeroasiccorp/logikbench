# conv2d (streaming programmable 3x3 convolution)

## What it is
A streaming **programmable 3x3 2D convolution**. Nine runtime signed
coefficients (packed `coeff`, Q1.(CW-1)) multiply the 3x3 window -- one
multiplier per tap (-> 9 DSPs) -- summed in an adder tree, then rounded and
saturated. The `coeff` port is the one addition to the shared interface below.

## Pipeline interface (shared by sobel3x3 / median3x3 / conv2d)

These three 3x3 filters use an identical streaming interface so they cascade
directly (one filter's output is a valid input to the next):

| Signal      | Dir | Width | Meaning                                  |
|-------------|-----|-------|------------------------------------------|
| `clk`,`rst` | in  | 1     | clock, synchronous reset                 |
| `in_valid`  | in  | 1     | input pixel valid                        |
| `in_sof`    | in  | 1     | start-of-frame (first pixel of a frame)  |
| `in_pix`    | in  | DW(8) | input pixel (raster order)               |
| `out_valid` | out | 1     | output pixel valid                       |
| `out_sof`   | out | 1     | start-of-frame of the output frame       |
| `out_pix`   | out | DW(8) | filtered pixel                           |

Output is **same-size** (one output pixel per input pixel, zero-padded border),
so geometry is preserved across a chain. Verified: `sobel3x3 -> median3x3 ->
conv2d` cascaded matches a software sobel->median->conv reference.

Parameters: `DW` (pixel width, 8), `IMGW`/`IMGH` (frame size; `IMGW` sets the
line-buffer depth). Two line buffers (currently shift registers; `la_spram`
BRAM is the area follow-up for large `IMGW`).

Extra port: `coeff [9*CW-1:0]` (nine signed taps c0..c8 = window p00..p22).

## Mapping
**9 DSP** multipliers (programmable coeffs prevent constant-folding), adder
tree + round/saturate + window -> LUTs/FFs, 2 line buffers. (CW=8 Q1.7 default.)

## Files
`rtl/conv2d.v`, `testbench/test_conv2d_smoke.v` (self-checking vs software 2D
conv for identity + blur kernels). Run: `iverilog -g2005 -o sim.out
rtl/conv2d.v testbench/test_conv2d_smoke.v && vvp sim.out`.

## References
Original implementation. **Algorithm:** discrete 2D convolution / FIR image
filtering; Gonzalez & Woods, *Digital Image Processing*. **Hardware:**
multiply-accumulate per tap + line-buffer sliding window (FPGA conv engines).
