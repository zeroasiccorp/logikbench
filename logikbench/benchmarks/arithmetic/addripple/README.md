# addripple

**Source:** [rtl/addripple.v](rtl/addripple.v)

Ripple-carry adder (structural): `{cout, sum} = a + b + cin`.

## What it is

`addripple` is a chain of `DW` full adders. The carry into bit `i+1` is `g[i] | (p[i] & c[i])`, so the carry path is `DW` stages long. It is the depth reference for the parallel prefix adders: a prefix adder whose synthesized depth approaches this one has lost its prefix structure.

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

## Structure

Measured on the elaborated netlist (2-input AND/OR/XOR gates, before any
optimization) for all benchmarked widths, and checked by
`tests/test_adders.py`:

- carry stages: `DW`
- gate depth: `2*DW+1`
- max fanout: 2

## Synthesis mapping

Pure combinational logic: no flip-flops, DSP or memory. ASIC flows map it to
standard cells; FPGA flows map it to LUTs rather than the dedicated carry
chain, because the adder is not written as `+`. Logic optimization (for
example ABC restructuring) is free to change the architecture; comparing the
synthesized depth with the numbers above shows whether it did.

## References

### Algorithm / architecture

- N. H. E. Weste and D. M. Harris, *CMOS VLSI Design: A Circuits and
  Systems Perspective*, 4th ed., Pearson/Addison-Wesley, 2011,
  Sec. 11.2 (Addition/Subtraction). Ripple-carry adder: the
  carry recurrence and full-adder bit cell used here.

### Hardware implementation

Original implementation of the ripple-carry recurrence above; not copied from any specific HDL source.

## Testbench

`testbench/test_addripple_smoke.v` is a Verilog-2005 self-checking testbench that
applies every `a`, `b`, `cin` combination at `DW = 8`, compares `{cout, sum}`
against `a + b + cin`, and prints `PASSED` / `FAILED`. Wider widths are proven
equivalent to `a + b + cin` by `tests/test_adders.py`.
