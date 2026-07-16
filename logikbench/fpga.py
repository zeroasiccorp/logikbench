"""FPGA synthesis path for LogikBench (the custom 'lbflow' FPGA flow).

A '--target' names an FPGA part (e.g. 'virtex7'), which the FPGA_TARGETS lookup
maps to a yosys synth command; that command is passed verbatim to
scripts/fpga/synthesis_fpga.tcl. Mirrors the ASIC split: --target is the part,
--tool (default yosys) is the synthesizer.
"""

import os

from siliconcompiler.metrics import FPGAMetricsSchema
from siliconcompiler.schema import EditableSchema, Parameter, Scope, PerNode

from logikbench.flows.syn import FPGASynthesis
from logikbench.common import _base_project, _set_range


class LbFpgaMetricsSchema(FPGAMetricsSchema):
    """SC FPGA metrics plus counts the base schema does not break out --
    'muxes', 'carrycells', 'latches', and 'lutram' -- each recorded separately
    from 'luts' so the LUT metric stays a pure logic-LUT count. ('registers'
    already exists in the base schema.)"""

    def __init__(self):
        super().__init__()
        schema = EditableSchema(self)
        for metric, desc in [
                ("muxes", "dedicated mux-fabric primitives (wide muxes that "
                          "combine or replace LUT logic)"),
                ("carrycells", "dedicated carry-chain / arithmetic cells "
                               "(carry, ALU adders)"),
                ("latches", "level-sensitive latch primitives"),
                ("lutram", "distributed (LUT-based) RAM primitives")]:
            schema.insert(
                metric,
                Parameter(
                    "int<0..>",
                    scope=Scope.JOB,
                    pernode=PerNode.REQUIRED,
                    shorthelp=f"Metric: FPGA {metric} used",
                    switch=f"-metric_{metric} 'step index <int>'",
                    example=[
                        f"cli: -metric_{metric} 'place 0 100'",
                        f"api: fpga.set('metric', '{metric}', 100, "
                        "step='place', index=0)"],
                    help=f"Count of {desc}, recorded separately from LUTs."))


# Vendored zeroasic FPGA architecture files (one subdir per part), fetched from
# siliconcompiler/logiklib releases by scripts/fetch_zeroasic_arch.py. Each part
# dir holds a '<part>_yosys_config.json' passed to wildebeest 'synth_fpga
# -config', which sets partname, lut size, and the flop/BRAM/DSP techmaps.
_ZEROASIC_ARCH_DIR = os.path.join(
    os.path.dirname(os.path.abspath(__file__)), "targets", "zeroasic")


def _zeroasic_command(part):
    """Yosys command for a zeroasic part: load wildebeest, then run synth_fpga
    against the vendored architecture config for that part."""
    config = os.path.join(_ZEROASIC_ARCH_DIR, part, f"{part}_yosys_config.json")
    return f"plugin -i wildebeest; synth_fpga -config {config}"


# FPGA targets, keyed by product/part name (the vendor prefix is dropped, e.g.
# 'virtex7' not 'xilinx_virtex7'), mapped to the yosys synth command (with the
# family/tech/partname/config args) that implements them. The command is passed
# verbatim to scripts/fpga/synthesis_fpga.tcl, which runs it (a ';' separates a
# plugin load from the synth command, as the zeroasic parts need wildebeest) and
# appends -top plus the user's --options. The part name is intentionally
# independent of the -family/-tech flag inside the command (virtex7 -> xc7,
# polarpro -> pp3, flex16ffc -> t16ffc).
# 'intel' is intentionally absent: yosys' synth_intel is experimental and reads
# a per-family techmap (intel/<family>/dsp_map.v) the yosys build does not ship.
FPGA_TARGETS = {
    "virtex7":   "synth_xilinx -family xc7",
    "polarpro":  "synth_quicklogic -family pp3",
    "polarfire": "synth_microchip -family polarfire",
    "ice40":     "synth_ice40",
    "ecp5":      "synth_lattice -family ecp5",
    "gw5a":      "synth_gowin -family gw5a",
    "speedster": "synth_achronix",
    "flex16ffc": "synth_analogdevices -tech t16ffc",
    "trion":     "synth_efinix",
    "fabulous":  "synth_fabulous",
    "cologne":   "synth_gatemate",
    "z1015":     _zeroasic_command("z1015"),
    "z1060":     _zeroasic_command("z1060"),
}


def _run_fpga(design, target, options, builddir, quiet, start, stop, timeout,
              lintonly=False):
    """lbflow FPGA synthesis; the target name maps to a yosys synth command."""
    proj = _base_project(design, builddir, LbFpgaMetricsSchema(), quiet, timeout)
    proj.add_fileset("rtl")
    proj.set_flow(FPGASynthesis())
    proj.set("tool", "yosys", "task", "synthesis", "var", "mode", "fpga")
    proj.set("tool", "yosys", "task", "synthesis", "var", "command",
             FPGA_TARGETS[target])
    proj.set("tool", "yosys", "task", "synthesis", "var", "options", options)
    proj.set("tool", "yosys", "task", "synthesis", "var", "ignore_initial",
             bool(getattr(design, "ignore_initial", False)))
    # lint-only: elaborate (read_slang) then stop before the FPGA synth core.
    proj.set("tool", "yosys", "task", "synthesis", "var", "lintonly",
             bool(lintonly))
    _set_range(proj, start, stop)
    proj.run()
    if not quiet:
        proj.summary()
