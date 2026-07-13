## What it is

A generic, technology-independent GPIO padring used to assess the area/footprint
of a minimal chip I/O ring. It is a thin wrapper around lambdalib's `la_padring`,
configured as a **square, uniform** ring: four identical sides, each with
`NPINS = 16` bidirectional GPIO cells plus a small set of supply cells, in a
single power section.

The functional payload of each pin is just a bidirectional I/O buffer:

- **output mode** (`oe=1`): the pad follows the core input `a`
- **input mode** (`ie=1`): the core output `z` follows the pad

On an FPGA the generic buffers collapse to wires, so the design optimizes away
to nothing. On an ASIC each cell maps to a fixed I/O pad macro from the PDK
I/O library, so the "area" is the pad macros themselves rather than random
logic (see Mapping).

## Interface

Top module `padring`. Parameters (all sides share the same values):

| Param       | Default | Meaning                                   |
|-------------|---------|-------------------------------------------|
| `NPINS`     | 16      | GPIO pads per side (multiple of 8, <= 32) |
| `NSECTIONS` | 1       | power sections per side                   |
| `RINGW`     | 8       | I/O ring bus width                        |
| `CFGW`      | 8       | generic config bus width                  |

Per side `X` in `{no, ea, so, we}`:

| Signal        | Dir   | Width         | Meaning                       |
|---------------|-------|---------------|-------------------------------|
| `X_pad`       | inout | `NPINS`       | package pad                   |
| `X_a`         | in    | `NPINS`       | core -> pad data (output)     |
| `X_z`         | out   | `NPINS`       | pad -> core data (input)      |
| `X_oe`        | in    | `NPINS`       | output enable                 |
| `X_ie`        | in    | `NPINS`       | input enable                  |
| `X_pe`/`X_ps` | in    | `NPINS`       | pull enable / pull select     |
| `X_schmitt`   | in    | `NPINS`       | schmitt-trigger enable         |
| `X_fast`      | in    | `NPINS`       | fast slew-rate select         |
| `X_ds`        | in    | `NPINS*2`     | drive strength                |
| `X_cfg`       | in    | `NPINS*CFGW`  | generic config                |
| `X_vdd/vddio/vssio` | inout | `NSECTIONS` | supplies                 |
| `X_ioring`    | inout | `NSECTIONS*RINGW` | generic I/O ring          |

`vss` is a single continuous ground shared by all sides.

## Cellmap

`la_padring` builds each side from a static `CELLMAP` (one 80-bit entry per
cell, `{PROP, SECTION, CELL, COMP, PIN}`). The shared per-side map in
`include/padring.vh` is a repeating **8-GPIO unit** -- 8 `LA_BIDIR` cells
followed by a `{LA_VDD, LA_VSS, LA_VDDIO, LA_VSSIO}` power block -- preceded by
an `LA_POC` and an `LA_VSSIO` guard, all in power section 0:

| Count per unit | Cell       | Notes                    |
|----------------|------------|--------------------------|
| 8              | `LA_BIDIR` | GPIO, 8 consecutive pins |
| 1              | `LA_VDD`   | core supply              |
| 1              | `LA_VSS`   | core ground              |
| 1              | `LA_VDDIO` | I/O supply               |
| 1              | `LA_VSSIO` | I/O ground               |

Plus one `LA_POC` + one `LA_VSSIO` guard shared per side. The array stores all
four units (up to 32 GPIO, `MAX = 50` cells); `NCELLS = 2 + 12*(NPINS/8)` is the
active count, and `la_padring` reads only the low `NCELLS` cells, so a smaller
`NPINS` simply uses the first `NPINS/8` units. The map is deliberately minimal
(GPIO + minimum viable supply set); it has no analog, differential, crystal,
clamp, or cut cells.

## Mapping

- **FPGA:** the generic bidirectional buffer is a pass-through; the whole ring
  optimizes to interconnect (0 LUT / 0 FF).
- **ASIC:** each cell resolves to a fixed I/O pad macro from the target PDK's
  I/O library (e.g. lambdapdk `asap7` `fakeio7`). Area is therefore dominated
  by the GPIO pad macros (4 x `NPINS`, i.e. 64 at the default) plus the per-side
  supply/POC cells. These pad macros ship as Verilog blackboxes with no liberty,
  so synthesis reads them as blackboxes and keeps them as instances in the
  netlist (they are placed from LEF during P&R). `lb syn` emits a real
  gate-level netlist for both FPGA and ASIC targets.

## Files

- `rtl/padring.v` -- wrapper (original; instance connections maintained by
  Emacs verilog-mode AUTOINST).
- `include/padring.vh` -- single-array cellmap + sizing localparams (original).
- `testbench/test_padring_smoke.v` -- self-checking smoke test (original).
- `padring.py` -- SiliconCompiler `Design` registration.

Simulate: `lb sim -g blocks -n padring`. The smoke test drives one north GPIO
through output and input mode and checks `pad`/`z` behavior.

## References

This block implements no algorithm or protocol standard -- a GPIO padring is a
structural I/O ring, so there is no algorithm reference to cite. The RTL in
this directory (`padring.v`, `padring.vh`, testbench) is an **original**
implementation written for LogikBench.

**Hardware implementation (architecture followed).**

- Lambdalib, `la_padring` / `la_padside` padring generator and `iolib` generic
  I/O cell library (open-source project, MIT). The `CELLMAP`-driven ring
  structure and the bidirectional-cell interface (`a/z/ie/oe/pe/ps/...`)
  instantiated by this block come directly from lambdalib.
  <https://github.com/siliconcompiler/lambdalib> (v0.13.1).

**Provenance.**

- `la_padring`, `la_padside`, and the `la_io*` cells are **not** copied into
  this block; they are pulled in as a build dependency
  (`lambdalib.padring.la_padring.Padring`), which also brings the `iolib` cells.
- Technology mapping of the generic cells to real pad macros is provided by
  Lambdapdk (MIT). <https://github.com/siliconcompiler/lambdapdk>.
