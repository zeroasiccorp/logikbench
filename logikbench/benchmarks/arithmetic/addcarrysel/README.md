# addcarrysel

**Source:** [rtl/addcarrysel.v](rtl/addcarrysel.v)

Carry-select adder (structural): `{cout, sum} = a + b + cin`.

## What it is

`addcarrysel` is `DW/BS` blocks of `BS` bits. The first block is a ripple adder on `cin`. Every other block computes two ripple sums, for a carry in of 0 and of 1, and a mux selects one with the carry out of the block below. A fast adder that is not a prefix network, as a control: the block carries form a chain of `DW/BS-1` muxes.

The adder is written gate by gate (AND/OR/XOR assigns in `generate` loops), so
the structure exists in the netlist before synthesis restructures it. It is
part of a set (`addripple`, `addsklansky`, `addkoggestone`, `addbrentkung`,
`addhancarlson`, `addcarrysel`) with the same interface as `add`, for checking
whether a synthesis flow preserves or destroys a given adder architecture.

## Interface

| Signal | Dir | Width | Description |
|---|---|---|---|
| `a` | in | `DW` | addend |
| `b` | in | `DW` | addend |
| `cin` | in | 1 | carry in |
| `cout` | out | 1 | carry out |
| `sum` | out | `DW` | sum |

## Parameters

| Name | Default | Description |
|---|---|---|
| `DW` | 16 | data width, a power of two (8, 16, 32, 64, 128 benchmarked) |
| `BS` | 4 | block size, must divide `DW` |

## Structure

Measured on the elaborated netlist (2-input AND/OR/XOR gates, before any
optimization) for all benchmarked widths, and checked by
`tests/test_adders.py`:

- mux stages on the carry path: `DW/BS-1`
- muxes: `(DW/BS-1)*(BS+1)`
- gate depth: `2*BS+DW/BS`
- max fanout: `BS+1` (each block select)

## Synthesis mapping

Pure combinational logic: no flip-flops, DSP or memory. ASIC flows map it to
standard cells; FPGA flows map it to LUTs rather than the dedicated carry
chain, because the adder is not written as `+`. Logic optimization (for
example ABC restructuring) is free to change the architecture; comparing the
synthesized depth with the numbers above shows whether it did.

## References

### Algorithm / architecture

- O. J. Bedrij, "Carry-Select Adder," *IRE Trans. Electronic Computers*,
  vol. EC-11, no. 3, pp. 340-346, 1962,
  doi:10.1109/IRETELC.1962.5407919. Duplicated block sums selected by
  the incoming block carry.

### Hardware implementation

Original implementation with uniform `BS`-bit blocks and ripple addition inside each block; not copied from any specific HDL source.

- N. H. E. Weste and D. M. Harris, *CMOS VLSI Design: A Circuits and
  Systems Perspective*, 4th ed., Pearson/Addison-Wesley, 2011,
  Sec. 11.2 (Addition/Subtraction). Carry-select
  adder with uniform blocks.

## Testbench

`testbench/test_addcarrysel_smoke.v` is a Verilog-2005 self-checking testbench that
applies every `a`, `b`, `cin` combination at `DW = 8`, compares `{cout, sum}`
against `a + b + cin`, and prints `PASSED` / `FAILED`. Wider widths are proven
equivalent to `a + b + cin` by `tests/test_adders.py`.
