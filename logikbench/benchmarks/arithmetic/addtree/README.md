## What it is

`addtree` reduces a packed vector of `N` operands to their sum through a
balanced binary tree of two-input adders (`N-1` adders, depth `clog2(N)`). It is
built with nested `generate` (one adder per tree node) rather than a procedural
accumulate, so the synthesizer sees the explicit tree structure. The word width
grows by one bit per level to hold the running sum without overflow.

Parameters: `N` (number of inputs, a power of two, default 64), `DW` (per-input
width, default 16). The output is `DW + clog2(N)` bits.

This is the tree-structured, carry-propagate counterpart to the flat `sum`
block: same function, but expressed as an explicit balanced tree of ripple
adders. It differs from the carry-save compressors (`csa32`/`csa42`), which
avoid carry propagation; here every node is a full carry-propagate add, so the
block deliberately stresses carry logic.

## Synthesis mapping / what it stresses

- **Parallel carry chains:** `N-1` carry-propagate adders arranged as a tree
  exercise how the FPGA maps and packs many short carry chains (`CARRY`/`ALU`
  primitives), and how well the tool balances the tree depth.
- **Bit growth:** each level widens by one bit, so carry chains lengthen toward
  the root, testing carry-chain cascading across logic blocks.
- **Low LUT / high depth:** on architectures with dedicated carry logic the tree
  maps mostly to carry cells rather than LUTs, so it primarily exercises the
  logic-depth and FMAX metrics rather than the LUT count.
