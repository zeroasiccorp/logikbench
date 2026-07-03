"""ASIC synthesis paths for LogikBench.

Two flavors:
  * a lambdapdk PDK name (e.g. 'freepdk45') -> the custom 'lbflow' ASIC path
    (Yosys synthesis plus OpenSTA timing) for a single-liberty PDK;
  * a '<pdk>_demo' name (e.g. 'asap7_demo') -> the official SC demo target
    (PDK + libraries + scenarios) run through SiliconCompiler's 'asicflow'.

Timing constraints come from each benchmark's own SDC (its 'sdc' fileset),
which declares its signal lists and then sources the PDK tech.tcl (ns->unit
scaling plus knobs) and the shared default.sdc. lb --clk (always nanoseconds)
is injected as LB_CLK_NS. Benchmarks that ship no SDC run unconstrained.
"""

import importlib
import os
import pkgutil

import siliconcompiler.targets as sc_targets
from siliconcompiler import ASIC
from siliconcompiler.metrics import ASICMetricsSchema
from siliconcompiler.flows import asicflow

from logikbench.flows.synth import ASICSynthesis
from logikbench.common import _base_project, _set_range, _quiet

# Default clock period (ns) injected as LB_CLK_NS; overridable with --clk.
DEFAULT_CLK_NS = 1.0

# Shared ASIC constraint files under logikbench/targets/asic. The per-PDK
# tech.tcl (timing knobs + ns->unit scaling) and the shared default.sdc are
# sourced by each benchmark's own SDC via LB_TECH_FILE / LB_DEFAULT_SDC.
_ASIC_DIR = os.path.join(
    os.path.dirname(os.path.abspath(__file__)), "targets", "asic")
_DEFAULT_SDC = os.path.join(_ASIC_DIR, "default.sdc")


def _tech_tcl(pdk):
    """Absolute path to a PDK's tech.tcl (timing knobs + ns->unit scaling)."""
    return os.path.join(_ASIC_DIR, pdk, "tech.tcl")


def _pdk_of(target):
    """PDK directory name for a target ('asap7_demo' -> 'asap7')."""
    return target[:-len("_demo")] if target.endswith("_demo") else target


def _nangate45_liberty():
    """Resolve the nangate45 standard-cell liberty (auto-fetched by SC)."""
    from lambdapdk.freepdk45.libs.nangate45 import Nangate45
    return Nangate45().get_file(fileset="models.timing.nldm")[0]


# Plain PDK targets that the custom lbflow ASIC path supports (single liberty).
_LBFLOW_PDKS = {
    "freepdk45": _nangate45_liberty,
}

# SC built-in ASIC targets, discovered from siliconcompiler.targets (one setup
# function per submodule, e.g. 'asap7_demo') so we track SC's set rather than
# mirroring it in a hand-maintained list.
SC_TARGETS = sorted(m.name for m in pkgutil.iter_modules(sc_targets.__path__))


def _sc_target(name):
    """Return the SC built-in target setup function for 'name', or None.

    Resolves siliconcompiler.targets.<name> dynamically. Helper callables in
    the package (ASIC, asic_target) are defined in the package itself, so a
    real target is one whose function lives in its own '<name>' submodule."""
    if name not in SC_TARGETS:
        return None
    module = importlib.import_module(f"{sc_targets.__name__}.{name}")
    return getattr(module, name, None)


def _bench_sdc(design):
    """The benchmark's own SDC path from its 'sdc' fileset, or '' if none.

    The SDC (when a benchmark ships one) declares its signal lists and sources
    the tech.tcl and default.sdc handed to it via LB_TECH_FILE / LB_DEFAULT_SDC.
    """
    if not design.has_fileset("sdc"):
        return ""
    files = design.get_file(fileset="sdc")
    return files[0] if files else ""


def _run_lbflow_asic(design, target, builddir, quiet, start, stop, timeout,
                     clk_ns=DEFAULT_CLK_NS):
    """lbflow ASIC (Yosys synthesis + OpenSTA timing) for a single-liberty PDK."""
    liberty = _LBFLOW_PDKS[target]()
    proj = _base_project(design, builddir, ASICMetricsSchema(), quiet, timeout)
    proj.add_fileset("rtl")
    proj.set_flow(ASICSynthesis())
    proj.set("tool", "yosys", "task", "synthesis", "var", "mode", "asic")
    proj.set("tool", "yosys", "task", "synthesis", "var", "liberty", liberty)
    proj.set("tool", "opensta", "task", "timing", "var", "liberty", liberty)
    # Timing constraints: --clk (ns) plus the paths the benchmark SDC sources
    # (tech.tcl scales ns->unit; default.sdc is the shared body). A benchmark
    # that ships no SDC runs unconstrained.
    proj.set("tool", "opensta", "task", "timing", "var", "clk", str(clk_ns))
    proj.set("tool", "opensta", "task", "timing", "var", "techfile",
             _tech_tcl(_pdk_of(target)))
    proj.set("tool", "opensta", "task", "timing", "var", "defaultsdc",
             _DEFAULT_SDC)
    proj.set("tool", "opensta", "task", "timing", "var", "sdc",
             _bench_sdc(design))
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


def _write_sc_wrapper(builddir, name, target, clk_ns, bench_sdc):
    """Write the SC-path SDC wrapper and return its (absolute) path.

    OpenROAD reads the sdc fileset with no earlier hook to set variables, so a
    benchmark SDC cannot be read directly (it references LB_CLK_NS / LB_TECH_FILE
    / LB_DEFAULT_SDC). This wrapper injects those, then sources the benchmark
    SDC. Written to the build-dir root (the per-benchmark dir is wiped each run)
    with an absolute path so SC resolves it regardless of the design dataroot.
    """
    path = os.path.abspath(os.path.join(builddir, f"{name}_lbsdc.sdc"))
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path, "w") as f:
        f.write(
            "# Generated by logikbench (asic.py): SC-path SDC wrapper.\n"
            "# Injects lb --clk (ns) and the tech/default paths the benchmark\n"
            "# SDC sources, then sources the benchmark SDC.\n"
            f"set LB_CLK_NS {clk_ns}\n"
            f"set LB_TECH_FILE {{{_tech_tcl(_pdk_of(target))}}}\n"
            f"set LB_DEFAULT_SDC {{{_DEFAULT_SDC}}}\n"
            f"source {{{bench_sdc}}}\n")
    return path


def _run_demo(design, target, builddir, quiet, start, stop, timeout,
              clk_ns=DEFAULT_CLK_NS):
    """Official SC demo target (PDK + libs + scenarios) run through asicflow."""
    proj = ASIC(design)
    proj.set("option", "builddir", builddir)
    if timeout is not None:
        proj.set("option", "timeout", timeout)
    _quiet(proj, quiet)
    _sc_target(target)(proj)
    # one library / one corner: avoid reading every Vt x corner liberty on each
    # STA node (see _single_corner); LogikBench needs only single-corner QoR.
    _single_corner(proj)
    proj.add_fileset("rtl")
    # A benchmark that ships an SDC is read through a generated wrapper (it
    # injects LB_CLK_NS and the tech/default paths, then sources the benchmark
    # SDC). Kept in its own 'lbsdc' fileset so the raw benchmark SDC is not read
    # standalone. Benchmarks with no SDC run unconstrained.
    bench_sdc = _bench_sdc(design)
    if bench_sdc:
        wrapper = _write_sc_wrapper(builddir, design.name, target, clk_ns,
                                    bench_sdc)
        design.add_file(wrapper, fileset="lbsdc")
        proj.add_fileset("lbsdc")
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
