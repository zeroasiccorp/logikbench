# tpu

**Source:** [rtl/tpu.v](rtl/tpu.v)

Weight-stationary systolic matrix-multiply tile, in the style of the Google
TPU matrix-multiply unit (MXU).

## What it is

`tpu` computes one tile product `C = A * B`, where `A` and `B` are `N x N`
signed `int8` matrices and `C` is `N x N` signed `int32`. `N`, `DW`, and `ACCW`
are parameters; `DW = 8` (int8 operands) and `ACCW = 32` (int32 accumulators)
are the classic TPU datatype.

This benchmark is configured at **`N = 128`** (a 128x128, 16384-PE array --
the scale of the Google TPU v1 MXU, ~10M gates), set via `set_param('N', ...)`
in `tpu.py`. The RTL default is `N = 8`.

`B` is the *weight* matrix: it is loaded into the array and held stationary in
the processing elements. `A` is the *activation* matrix: it is streamed through
the array, and the result `C` drains out the bottom.

## Circuit

The design is a 2D mesh of `N x N` identical processing elements
(`tpu_pe`), assembled by `tpu_array` and wrapped by `tpu`:

- **`tpu_pe`** -- one processing element. It holds a single stationary signed
  weight `w` and contains the only arithmetic in the array: a signed
  `DW x DW` multiply and an `ACCW`-bit add (`psum_out = psum_in + a * w`).
  Activations register west-to-east; partial sums register north-to-south and
  accumulate. The weights also form a per-column load shift register.
- **`tpu_array`** -- instantiates the PE mesh with one `generate` instance per
  element (no procedural unroll). Weights enter the top, activations the left,
  results leave the bottom; the top-row partial-sum inputs are tied to zero.
- **`tpu`** -- the streaming wrapper. It adds the input *skew* (row `i` of `A`
  delayed `i` cycles) and output *de-skew* (column `j` of `C` delayed `N-1-j`
  cycles) needed to time-align the systolic data flow, plus the load/compute
  control and the result-valid pipeline. Skew chains are generated per-row /
  per-column shift registers.

### Dataflow (weight-stationary)

With weight `B[i][j]` held at PE`(i,j)` and activation `A[m][i]` entering
row `i`, column `j` accumulates `C[m][j] = sum_i A[m][i] * B[i][j]` as the
partial sum flows down. This is the canonical weight-stationary mapping.

## Interface

| Signal    | Dir | Width      | Description                                   |
|-----------|-----|------------|-----------------------------------------------|
| `clk`     | in  | 1          | clock                                         |
| `rst`     | in  | 1          | synchronous, active high                      |
| `w_valid` | in  | 1          | weight-row valid (load phase)                 |
| `w_data`  | in  | `N*DW`     | one weight row, packed `{ col N-1 .. col 0 }` |
| `a_valid` | in  | 1          | activation-row valid (compute phase)          |
| `a_data`  | in  | `N*DW`     | one activation row, same packing              |
| `c_valid` | out | 1          | result-row valid                              |
| `c_data`  | out | `N*ACCW`   | one result row, same packing                  |

Usage: pulse `w_valid` for `N` cycles, pushing the weight matrix one row per
cycle **bottom row first** (`cycle k = B[N-1-k][*]`, because the array loads by
shifting down). Then stream `A` one row per cycle on `a_data`/`a_valid`. Result
row `C[m][*]` appears on `c_data` with `c_valid` high, `2*N-1` cycles after its
`A` row was accepted.

## Synthesis mapping

At the default `N = 8`, int8:

- ~`N*N` = 64 signed 8x8 multipliers (one per PE). On FPGA these map to the
  device DSP/multiplier blocks; on ASIC they synthesize to logic.
- 64 32-bit accumulator adds plus the activation/partial-sum/weight pipeline
  registers (LUT/FF).
- Triangular input-skew and output-de-skew shift registers
  (`N*(N-1)/2` activation registers and `N*(N-1)/2` result registers).
- No on-chip RAM: a single tile streams through, so there are no large
  buffers and **no BRAM** (this also avoids any block-RAM mapping pitfalls).

## References

### Algorithm / architecture

- N. P. Jouppi et al., "In-Datacenter Performance Analysis of a Tensor
  Processing Unit," *ISCA 2017*. Describes the TPU MXU: a weight-stationary
  systolic array of 8-bit multiply-accumulate cells.
- H. T. Kung and C. E. Leiserson, "Systolic Arrays (for VLSI)," in *Sparse
  Matrix Proceedings*, 1978. The foundational systolic-array formulation for
  matrix multiplication in VLSI.

### Hardware implementation

This RTL is an original implementation. It follows the weight-stationary
systolic-array architecture described in the references above (stationary
weights in the PEs, activations streaming horizontally, partial sums
accumulating vertically, with input/output skew for time alignment); it is not
copied from any specific source.

## Testbench

`testbench/test_tpu_smoke.v` is a Verilog-2005 self-checking testbench. It
loads a weight matrix, streams an activation matrix, and compares every drained
result row against a software integer matmul reference. It exercises an
identity-weight passthrough and several random signed int8 tiles, and prints
`PASSED` / `FAILED`.
