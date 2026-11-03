# addkoggestone

**Source:** [rtl/addkoggestone.v](rtl/addkoggestone.v)

Kogge-Stone parallel prefix adder (structural): `{cout, sum} = a + b + cin`.

## What it is

`addkoggestone` is a recursive-doubling prefix network. At level `l`, every bit `i >= 2^(l-1)` combines with bit `i-2^(l-1)`. Minimum depth and bounded fanout, paid for with the most prefix nodes and the most wiring of the log-depth networks.

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

- prefix levels: `log2(DW)`
- prefix nodes: `DW*log2(DW)-DW+1`
- gate depth: `2*log2(DW)+3`
- max fanout: `log2(DW)+1` (the bit-0 carry, used by every level)

## Synthesis mapping

Pure combinational logic: no flip-flops, DSP or memory. ASIC flows map it to
standard cells; FPGA flows map it to LUTs rather than the dedicated carry
chain, because the adder is not written as `+`. Logic optimization (for
example ABC restructuring) is free to change the architecture; comparing the
synthesized depth with the numbers above shows whether it did.

## References

### Algorithm / architecture

- P. M. Kogge and H. S. Stone, "A Parallel Algorithm for the Efficient
  Solution of a General Class of Recurrence Equations," *IEEE Trans.
  Computers*, vol. C-22, no. 8, pp. 786-793, 1973,
  doi:10.1109/TC.1973.5009159. Recursive doubling; the carry recurrence is
  the instance implemented here.

### Hardware implementation

Original implementation of the prefix network above; not copied from any
specific HDL source. It follows:

- D. Harris, "A Taxonomy of Parallel Prefix Networks," *Proc. 37th
  Asilomar Conf. on Signals, Systems and Computers*, vol. 2,
  pp. 2213-2217, 2003, doi:10.1109/ACSC.2003.1292373. Kogge-Stone
  network as the minimum-depth, minimum-fanout, maximum-wiring corner.
- N. H. E. Weste and D. M. Harris, *CMOS VLSI Design: A Circuits and
  Systems Perspective*, 4th ed., Pearson/Addison-Wesley, 2011,
  Sec. 11.2 (Addition/Subtraction). Bitwise generate/propagate, group (G, P) prefix cells, and
  sum = p XOR carry; `cin` folded into the bit-0 generate.

## Testbench

`testbench/test_addkoggestone_smoke.v` is a Verilog-2005 self-checking testbench that
applies every `a`, `b`, `cin` combination at `DW = 8`, compares `{cout, sum}`
against `a + b + cin`, and prints `PASSED` / `FAILED`. Wider widths are proven
equivalent to `a + b + cin` by `tests/test_adders.py`.
