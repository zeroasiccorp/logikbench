# median3x3 (streaming 3x3 median filter)

## What it is
A streaming 3x3 **median** filter (salt-and-pepper denoise). The 3x3 window
feeds an odd-even transposition sorting network (36 compare-swaps) and the
middle element (median of 9) is output. Compares only -- no multiplier.

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
~36 8-bit compare-swap cells + window/control -> LUTs/FFs, **0 DSP**, 2 line
buffers.

## Files
`rtl/median3x3.v`, `testbench/test_median3x3_smoke.v` (self-checking vs a
software median-of-9). Run: `iverilog -g2005 -o sim.out rtl/median3x3.v \\
         <lambdalib>/ramlib/la_spram/rtl/la_spram.v \\
         <lambdalib>/ramlib/la_spram/rtl/la_spram_impl.v
testbench/test_median3x3_smoke.v && vvp sim.out`.

## References
Original implementation. **Algorithm:** J. Tukey, *Exploratory Data Analysis*,
1977 (running median); median filtering for impulse noise. **Hardware:** sorting
-network median (odd-even transposition / Batcher); line-buffer streaming.
