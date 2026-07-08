# fsm

**Source:** [rtl/fsm.v](rtl/fsm.v)

Syntheticfinite state machine with pseudo-random ("chaotic") state
transitions, sized by `STATES`. Module: `parametric_fsm_benchmark`.

## What it is

A synchronous FSM whose next-state and output functions are deliberately
irregular: instead of an incrementing/linear transition (which a tool would map
onto a counter and a dedicated carry chain), each transition mixes the current
state index, the input vector, and a `SEED` using XOR, shift, and add
operations (the bit-mixing style of LCGs / Galois LFSRs). A few specific states
are given arbitrary "bridge" transitions via a `case`, on top of a mixed
default. Async active-low `nreset`.

Parameters: `STATES` (number of states, e.g. 8..256), `DW` (input/output
bit width), `SEED` (alters the transition matrix). The state register is
`clog2(STATES)` bits, so the reachable-state graph and next-state logic scale
with `STATES` -- sweep it to stress the tool at different sizes.

## Interface

| Signal   | Dir | Width         | Description                       |
|----------|-----|---------------|-----------------------------------|
| `clk`    | in  | 1             | clock                             |
| `nreset` | in  | 1             | async reset, active low           |
| `in`     | in  | `DW`          | input driving transitions/output  |
| `out`    | out | `DW`          | registered state/input hash       |

## Synthesis mapping / what it stresses

- **Defeats counter/carry-chain shortcuts:** mixing XOR/shift with `+ in`
  prevents the tool from routing the state update through dedicated carry logic,
   forcing general LUT logic instead.
- **Wide LUT / XOR trees:** the avalanche-style bit mixing makes each next-state
  bit depend on many state and input bits.
- **State-encoding stress:** the irregular `case` transitions emulate the
  messy, arbitrary structure of classic MCNC FSM benchmarks, while remaining
  parametrically scalable via `STATES`.

## References

### Algorithm / architecture

- S. Yang, *Logic Synthesis and Optimization Benchmarks User Guide, Version
  3.0*, MCNC, 1991. The classic (static) FSM benchmark suite whose irregular
  transition structure this design emulates in a scalable form.
- S. W. Golomb, *Shift Register Sequences*, Holden-Day, 1967. The
  LFSR/bit-mixing principles the pseudo-random transitions are adapted from.

### Provenance

The pseudo-random transition/output pattern was generated with the assistance
of Google Gemini (adapting LCG / Galois-LFSR bit-mixing into the FSM's
transition logic); the interface, integration into LogikBench, testbench, and
review were done by the author. It is not copied from any specific HDL source.

## Testbench

`testbench/test_fsm_smoke.v` is a Verilog-2005 self-checking testbench. As the
chaotic transition function has no external golden model, it mirrors the RTL's
next-state and output equations, drives random input, checks `out` every cycle
(and that no X propagates), and prints `PASSED` / `FAILED`.
