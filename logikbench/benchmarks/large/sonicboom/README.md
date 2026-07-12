# SonicBOOM (BOOM v3) out-of-order RISC-V core

**Source:** [rtl/sonicboom.sv](rtl/sonicboom.sv)

MegaBOOM configuration of SonicBOOM (the Berkeley Out-of-Order Machine, v3
"sonic" line): a superscalar, out-of-order RV64GC core generated from Chisel via
Chipyard.

- `MegaBoomV3Config`: 4-wide fetch/decode/issue, out-of-order execution
- L1I + L1D caches, TLBs, and a TAGE-based branch predictor (the many small
  SRAMs below are its cache arrays, BPD tables, and register files)
- Top module: `sonicboom_DigitalTop` (the digital system; the Chipyard
  `TestHarness` and simulation-only collateral are dropped)

## Sources

- Chipyard: https://github.com/ucb-bar/chipyard `1.13.0`
- riscv-boom: https://github.com/riscv-boom/riscv-boom `d2a64f7c`
  (= `git describe` `v3.0.0-379-gd2a64f7c`)

The newest riscv-boom release *tag* is `v3.0.0` (~2021), but that tag predates
the rocket-chip config-package migration and no longer compiles against modern
Chipyard. Chipyard 1.13.0 ships BOOM 379 commits past the tag (`d2a64f7c`) --
same v3 architecture line, but the head Chipyard validates. We pin that commit.

## Generation

Unlike the `rocket` benchmark, the full generation flow *is* included here and
is self-contained: it uses **stock upstream Chipyard with no patches** and
depends only on tools it installs itself (conda/morty/verible) -- nothing from
any private or deprecated repo. See [generation/](generation/):

1. `generation/presetup_boom.sh` -- one-time, root-free install of conda, morty
   and verible.
2. `generation/generate_boom.sh` -- clones Chipyard, pins the BOOM submodule,
   runs `make CONFIG=MegaBoomV3Config verilog`, and flattens the collateral
   (morty uniquify/flatten under `DigitalTop`, verible strip-comments) into
   `rtl/sonicboom.sv`. `generation/flatten_boom.sh` re-runs just the flatten.

## SRAMs (lambdalib)

The flattened core leaves every Chisel memory macro as an undefined `*_ext`
blackbox (we drop Chipyard's srammap patch). `generation/make_srams.py`
generates [rtl/sonicboom_srams.v](rtl/sonicboom_srams.v), wrapping each blackbox
around a lambdalib RAM primitive:

- single read/write port (`RW0_*`) -> `la_spram` (`Spram`)
- one-read one-write (`R0_*` + `W0_*`) -> `la_dpram` (`Dpram`)

Chisel's segmented write masks are expanded to full bit masks (`BYTEMASK=0`).
`plusarg_reader` is a simulation-only construct and is stubbed to its default.

## References

* J. Zhao, B. Korpan, A. Gonzalez, and K. Asanovic, "SonicBOOM: The 3rd
  Generation Berkeley Out-of-Order Machine," in Fourth Workshop on Computer
  Architecture Research with RISC-V (CARRV), May 2020.
* A. Amid et al., "Chipyard: Integrated Design, Simulation, and Implementation
  Framework for Custom SoCs," IEEE Micro, vol. 40, no. 4, pp. 10-21, 2020.
  DOI: 10.1109/MM.2020.2996616.

## License

Chipyard and riscv-boom are BSD-3-Clause.
