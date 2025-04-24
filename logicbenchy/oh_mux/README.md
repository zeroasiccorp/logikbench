Parametrized Datapath Mux
============================================

## Description

Muxes together M vectors of width N to produce a single vector of width N.

This benchmark checks:
- mux tree synthesis
- technology mapping
- wiring rats nest
- fanout buffering on selects
- critical path timing optimization
- datapath placement

## Original Sources

- Author: Andreas Olofsson
- Repo: https://github.com/aolofsson/oh
- Commit: 7edfcb5f0506fb854449fbe09598a7ec88bb2067

## License

MIT. See LICENSE for more details.

## Modifications

- Removed ASIC mapping and deprecated parameters
