"""ASIC synthesis paths for LogikBench.

Two flavors:
  * a lambdapdk PDK name (e.g. 'freepdk45') -> the custom 'lbflow' ASIC path
    (Yosys synthesis plus OpenSTA timing) for a single-liberty PDK;
  * a '<pdk>_demo' name (e.g. 'asap7_demo') -> the official SC demo target
    (PDK + libraries + scenarios) run through SiliconCompiler's 'asicflow'.

Benchmarks ship no timing constraints, so a generic clock SDC is generated per
run (see logikbench/sdc.py) and attached to the flow.
"""

import os

from siliconcompiler import ASIC
from siliconcompiler.metrics import ASICMetricsSchema
from siliconcompiler.flows import asicflow
from siliconcompiler.targets import (
    freepdk45_demo, asap7_demo, skywater130_demo, gf180_demo, ihp130_demo)

from logikbench.flows.synth import ASICSynthesis
from logikbench import sdc
from logikbench.common import _base_project, _set_range, _quiet

# Default clock period (ns) for the generic ASIC SDC; overridable with --clk.
DEFAULT_CLK_NS = 1.0

_LBFLOW_ASIC_RECIPE = "asic/freepdk45"

# SDC command time unit (ns) per ASIC target. 'create_clock -period' is read in
# the unit OpenROAD/OpenSTA derive from the liberty, so the requested ns period
# is scaled into this unit (see logikbench/sdc.py). Values are each PDK
# liberty's 'time_unit' (ASAP7 is 1 ps; the other PDKs are 1 ns).
ASIC_TIME_UNIT_NS = {
    "freepdk45": 1.0,
    "freepdk45_demo": 1.0,
    "asap7_demo": 0.001,
    "skywater130_demo": 1.0,
    "gf180_demo": 1.0,
    "ihp130_demo": 1.0,
}


def _nangate45_liberty():
    """Resolve the nangate45 standard-cell liberty (auto-fetched by SC)."""
    from lambdapdk.freepdk45.libs.nangate45 import Nangate45
    return Nangate45().get_file(fileset="models.timing.nldm")[0]


# Plain PDK targets that the custom lbflow ASIC path supports (single liberty).
_LBFLOW_PDKS = {
    "freepdk45": _nangate45_liberty,
}

# '<pdk>_demo' targets -> official SC demo target setup function (run asicflow).
_DEMO_TARGETS = {
    "freepdk45_demo": freepdk45_demo,
    "asap7_demo": asap7_demo,
    "skywater130_demo": skywater130_demo,
    "gf180_demo": gf180_demo,
    "ihp130_demo": ihp130_demo,
}


def _clock_sdc(target, name, builddir, clk_ns):
    """Write the generic clock SDC for a target and return its path.

    The requested period (ns) is emitted in the target's native SDC time unit
    (ASIC_TIME_UNIT_NS). The file is written to the build-dir root, not the
    per-benchmark dir (which is wiped before each run), so parallel benchmarks
    do not collide.
    """
    unit = ASIC_TIME_UNIT_NS.get(target, 1.0)
    path = os.path.join(builddir, f"{name}.clock.sdc")
    return sdc.write_sdc(path, clk_ns, unit)


def _run_lbflow_asic(design, target, builddir, quiet, start, stop, timeout,
                     clk_ns=DEFAULT_CLK_NS):
    """lbflow ASIC (Yosys synthesis + OpenSTA timing) for a single-liberty PDK."""
    liberty = _LBFLOW_PDKS[target]()
    proj = _base_project(design, builddir, ASICMetricsSchema(), quiet, timeout)
    proj.add_fileset("rtl")
    proj.set_flow(ASICSynthesis())
    proj.set("tool", "yosys", "task", "synthesis", "var", "mode", "asic")
    proj.set("tool", "yosys", "task", "synthesis", "var", "liberty", liberty)
    proj.set("tool", "opensta", "task", "timing", "var", "target", _LBFLOW_ASIC_RECIPE)
    proj.set("tool", "opensta", "task", "timing", "var", "liberty", liberty)
    proj.set("tool", "opensta", "task", "timing", "var", "sdc",
             _clock_sdc(target, design.name, builddir, clk_ns))
    _set_range(proj, start, stop)
    proj.run()


def _single_corner(proj):
    """Trim a demo target to one library and one STA corner.

    Demo targets (e.g. asap7_demo) load several Vt libraries (RVT/LVT/SLVT) and
    several timing corners (slow/typical/fast); every STA-running node then reads
    each Vt x corner liberty (~45 .lib.gz for asap7) for every benchmark, which
    dominates runtime. LogikBench only needs cells/area/fmax from one consistent
    corner, so keep the main library (drop the extra Vt 'asiclib' variants) and
    the single setup-check scenario (fmax/setupslack come from setup), dropping
    the power/hold corners. Reduces asap7 liberty reads ~9x (45 -> 5)."""
    # one library: keep the main lib, drop the extra Vt standard-cell libraries
    proj.set("asic", "asiclib", [])
    # one corner: keep a single setup-check scenario, remove the rest
    timing = proj.constraint.timing
    scenarios = list(proj.getkeys("constraint", "timing", "scenario"))

    def checks(s):
        return proj.get("constraint", "timing", "scenario", s, "check") or []

    setup = [s for s in scenarios if "setup" in checks(s)]
    keep = (setup or scenarios)[:1]
    for s in scenarios:
        if s not in keep:
            timing.remove_scenario(s)


def _run_demo(design, target, builddir, quiet, start, stop, timeout,
              clk_ns=DEFAULT_CLK_NS):
    """Official SC demo target (PDK + libs + scenarios) run through asicflow."""
    proj = ASIC(design)
    proj.set("option", "builddir", builddir)
    if timeout is not None:
        proj.set("option", "timeout", timeout)
    _quiet(proj, quiet)
    _DEMO_TARGETS[target](proj)
    # one library / one corner: avoid reading every Vt x corner liberty on each
    # STA node (see _single_corner); LogikBench needs only single-corner QoR.
    _single_corner(proj)
    # benchmarks ship no SDC; attach a generic clock so STA can constrain.
    # Only wire up the sdc fileset if the file is actually on disk, so a
    # failed/skipped SDC write cannot leave an unresolvable fileset entry.
    sdc_path = _clock_sdc(target, design.name, builddir, clk_ns)
    proj.add_fileset("rtl")
    if os.path.isfile(sdc_path):
        design.add_file(sdc_path, fileset="sdc")
        proj.add_fileset("sdc")
    proj.set_flow(asicflow.ASICFlow())
    # LogikBench designs are IO-dominated (wide buses, tiny logic), so the
    # demo's 40%-utilization die can't fit the pins on its perimeter. Grow the
    # die with a low utilization and halve the default 2-track pin spacing; the
    # two together give enough perimeter slots for these pin-heavy designs.
    proj.constraint.area.set_density(10)
    proj.set("tool", "openroad", "task", "pin_placement", "var",
             "ppl_arguments", ["-min_distance", "1", "-min_distance_in_tracks"])
    _set_range(proj, start, stop)
    proj.run()
