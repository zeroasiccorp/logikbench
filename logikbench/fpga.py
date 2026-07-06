"""FPGA synthesis path for LogikBench (the custom 'lbflow' FPGA flow).

A '--target' of the form '<vendor>_<partname>' selects a yosys synth command
(see FPGA_TARGETS), which is passed verbatim to scripts/fpga/synthesis_fpga.tcl.
"""

import os

from siliconcompiler.metrics import FPGAMetricsSchema

from logikbench.flows.synth import FPGASynthesis
from logikbench.common import _base_project, _set_range

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


# FPGA targets, named "<vendor>_<partname>", mapped to the yosys synth command
# (with family/tech/partname/config args) that implements them. The command is
# passed verbatim to scripts/fpga/synthesis_fpga.tcl, which runs it (a ';'
# separates a plugin load from the synth command, as the zeroasic parts need
# wildebeest) and appends -top plus the user's --options.
# 'intel' is intentionally absent: yosys' synth_intel is experimental and reads
# a per-family techmap (intel/<family>/dsp_map.v) the yosys build does not ship.
FPGA_TARGETS = {
    "xilinx_virtex7":      "synth_xilinx -family xc7",
    "quicklogic_polarpro": "synth_quicklogic -family pp3",
    "microchip_polarfire": "synth_microchip -family polarfire",
    "lattice_ice40":       "synth_ice40",
    "lattice_ecp5":        "synth_lattice -family ecp5",
    "gowin_gw5a":          "synth_gowin -family gw5a",
    "achronix_speedster":  "synth_achronix",
    "adi_flex16ffc":       "synth_analogdevices -tech t16ffc",
    "efinix_trion":        "synth_efinix",
    "fabulous_generic":    "synth_fabulous",
    "gatemate_cologne":    "synth_gatemate",
    "zeroasic_z1015":      _zeroasic_command("z1015"),
    "zeroasic_z1060":      _zeroasic_command("z1060"),
}


def _run_fpga(design, target, options, builddir, quiet, start, stop, timeout,
              lintonly=False):
    """lbflow FPGA synthesis; the target name maps to a yosys synth command."""
    proj = _base_project(design, builddir, FPGAMetricsSchema(), quiet, timeout)
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
