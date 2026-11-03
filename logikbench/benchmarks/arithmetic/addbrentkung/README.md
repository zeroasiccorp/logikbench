# addbrentkung

**Source:** [rtl/addbrentkung.v](rtl/addbrentkung.v)

Brent-Kung parallel prefix adder (structural): `{cout, sum} = a + b + cin`.

## What it is

`addbrentkung` is an up-sweep binary tree that builds the prefixes of bits `2^k-1`, followed by a down-sweep inverse tree that fills in the remaining bits. The fewest prefix nodes of the log-depth networks, paid for with roughly twice the depth.

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

- prefix levels: `2*log2(DW)-1`
- prefix nodes: `2*DW-2-log2(DW)`
- gate depth: `4*log2(DW)` (no path uses both the top up-sweep level and the down-sweep)
- max fanout: `log2(DW)+1`

## Synthesis mapping

Pure combinational logic: no flip-flops, DSP or memory. ASIC flows map it to
standard cells; FPGA flows map it to LUTs rather than the dedicated carry
chain, because the adder is not written as `+`. Logic optimization (for
example ABC restructuring) is free to change the architecture; comparing the
synthesized depth with the numbers above shows whether it did.

## References

### Algorithm / architecture

- R. P. Brent and H. T. Kung, "A Regular Layout for Parallel Adders,"
  *IEEE Trans. Computers*, vol. C-31, no. 3, pp. 260-264, 1982,
  doi:10.1109/TC.1982.1675982. The up-sweep and down-sweep prefix trees.

### Hardware implementation

Original implementation of the prefix network above; not copied from any
specific HDL source. It follows:

- D. Harris, "A Taxonomy of Parallel Prefix Networks," *Proc. 37th
  Asilomar Conf. on Signals, Systems and Computers*, vol. 2,
  pp. 2213-2217, 2003, doi:10.1109/ACSC.2003.1292373. Brent-Kung
  network as the maximum-depth, minimum-fanout, minimum-wiring corner.
- N. H. E. Weste and D. M. Harris, *CMOS VLSI Design: A Circuits and
  Systems Perspective*, 4th ed., Pearson/Addison-Wesley, 2011,
  Sec. 11.2 (Addition/Subtraction). Bitwise generate/propagate, group (G, P) prefix cells, and
  sum = p XOR carry; `cin` folded into the bit-0 generate.

## Testbench

`testbench/test_addbrentkung_smoke.v` is a Verilog-2005 self-checking testbench that
applies every `a`, `b`, `cin` combination at `DW = 8`, compares `{cout, sum}`
against `a + b + cin`, and prints `PASSED` / `FAILED`. Wider widths are proven
equivalent to `a + b + cin` by `tests/test_adders.py`.
