# sobel3x3 (streaming Sobel edge detector)

## What it is
A streaming 3x3 **Sobel** edge detector. The constant +-1/+-2 kernels compute
Gx and Gy with shifts/adds (no multiplier), and the output is the saturated L1
edge magnitude `|Gx|+|Gy|`.

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
line-buffer depth). Two line buffers use lambdalib `la_spram` (BRAM), depth `IMGW` (default 512).

## Mapping
Window taps + a handful of adders/abs + saturate -> LUTs/FFs, **0 DSP** (kernel
folds to shifts/adds), 2 BRAM line buffers (la_spram). (Default IMGW/IMGH = 64.)

## Files
`rtl/sobel3x3.v`, `testbench/test_sobel3x3_smoke.v` (self-checking vs a software
Sobel). Run: `iverilog -g2005 -o sim.out rtl/sobel3x3.v \\
         <lambdalib>/ramlib/la_spram/rtl/la_spram.v \\
         <lambdalib>/ramlib/la_spram/rtl/la_spram_impl.v
testbench/test_sobel3x3_smoke.v && vvp sim.out`.

## References
Original implementation. **Algorithm:** I. Sobel, G. Feldman, "A 3x3 isotropic
gradient operator for image processing," 1968; R. Gonzalez & R. Woods, *Digital
Image Processing*. **Hardware:** standard line-buffer/sliding-window streaming
filter architecture (e.g. FPGA image-processing line-buffer designs).
