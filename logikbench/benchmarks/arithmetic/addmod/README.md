## What it is

`addmod` implements modular addition by the textbook "add, then conditionally
subtract the modulus" method. It forms `sum = a + b` and `diff = sum - m` in
`WIDTH+1`-bit arithmetic, then selects `diff` when `sum >= m` (no borrow) and
`sum` otherwise. With reduced inputs (`a, b < m`) the sum is below `2m`, so a
single conditional subtract is sufficient to return the result to `[0, m)`.

Parameter: `WIDTH` (operand and modulus width, default 256). Setting `WIDTH`
large (e.g. 512, 1024) makes each operation a very long carry chain, which is
the intent of this benchmark.

Unlike the carry-save compressors (`csa32`/`csa42`), which avoid carry
propagation, `addmod` uses two full carry-propagate chains (the add and the
subtract) so it deliberately stresses long carry logic.

## Synthesis mapping / what it stresses

- **Deep carry chains:** the add and the subtract are each `WIDTH`-bit
  carry-propagate operations, so the design maps to one (or two) long cascaded
  carry chains, testing how the fabric cascades carry logic across logic blocks.
- **Wide select fan-out:** the final `WIDTH`-bit 2:1 mux, driven by a single
  borrow bit, stresses high-fan-out control routing.
- **Low LUT / high depth:** on fabrics with dedicated carry logic the adders map
  mostly to carry primitives rather than LUTs, so the block primarily exercises
  the logic-depth and FMAX metrics rather than the LUT count.
