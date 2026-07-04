"""ASIC synthesis paths for LogikBench.

Targets are named '<tool>_<pdk>', matching the FPGA '<vendor>_<part>' scheme.
Three flavors:
  * 'yosys_<pdk>' (e.g. 'yosys_freepdk45') -> the custom 'lbflow' ASIC path
    (Yosys synthesis plus OpenSTA timing) for a single-liberty PDK;
  * 'tardigrade_<pdk>' (e.g. 'tardigrade_freepdk45') -> the same lbflow path
    with tardigrade as the synthesis mapper instead of yosys;
  * 'sc_<pdk>' (e.g. 'sc_asap7') -> the official SC target (PDK + libraries +
    scenarios) run through SiliconCompiler's 'asicflow'. SC names its setup
    modules '<pdk>_demo', so a pdk->module lookup maps 'sc_asap7'->'asap7_demo'.

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
from siliconcompiler.flows import asicflow

from logikbench.flows.synth import ASICSynthesis
from logikbench.common import _set_range, _quiet

# Default clock period (ns) injected as LB_CLK_NS; overridable with --clk.
DEFAULT_CLK_NS = 1.0

# Shared ASIC constraint files under logikbench/targets. The per-PDK tech.tcl
# (timing knobs + ns->unit scaling) and the shared default.sdc are sourced by
# each benchmark's own SDC via LB_TECH_FILE / LB_DEFAULT_SDC.
_TARGETS_DIR = os.path.join(
    os.path.dirname(os.path.abspath(__file__)), "targets")

_DEFAULT_SDC = os.path.join(_TARGETS_DIR, "default.sdc")


def _tech_tcl(pdk):
    """Absolute path to a PDK's tech.tcl (timing knobs + ns->unit scaling)."""
    return os.path.join(_TARGETS_DIR, pdk, "tech.tcl")


def _pdk_of(module):
    """PDK name for an SC target module ('asap7_demo' -> 'asap7')."""
    return module[:-len("_demo")] if module.endswith("_demo") else module


# Raw SC built-in target module names (e.g. 'asap7_demo'), discovered from
# siliconcompiler.targets so we track SC's set rather than mirroring it. These
# are the names passed to the SC setup function; lb exposes them as 'sc_<pdk>'.
_SC_MODULES = sorted(m.name for m in pkgutil.iter_modules(sc_targets.__path__))

# pdk -> SC target module ('asap7' -> 'asap7_demo'): the name lookup that maps
# an lb ASIC target's pdk back to the SC setup module (SC names them '_demo').
_SC_MODULE = {_pdk_of(m): m for m in _SC_MODULES}

# All SC PDKs, and the std-cell subset used by the lbflow paths (yosys /
# tardigrade). Interposer has no standard cells, so it has no lbflow variant.
_SC_PDKS = sorted(_SC_MODULE)
_LBFLOW_PDKS = sorted(set(_SC_PDKS) - {"interposer"})

# lb-facing ASIC target names, all '<tool>_<pdk>' to match the FPGA
# '<vendor>_<part>' scheme (tool/company first, part/pdk second):
#   sc_<pdk>          -> SC 'asicflow' (PDK + libs + scenarios, through P&R)
#   yosys_<pdk>       -> lbflow: yosys synthesis + OpenSTA timing (no P&R)
#   tardigrade_<pdk>  -> lbflow with tardigrade as the synthesis mapper
SC_TARGETS = [f"sc_{pdk}" for pdk in _SC_PDKS]
YOSYS_TARGETS = [f"yosys_{pdk}" for pdk in _LBFLOW_PDKS]
TARDIGRADE_TARGETS = [f"tardigrade_{pdk}" for pdk in _LBFLOW_PDKS]


def _sc_target(name):
    """Return the SC built-in target setup function for 'name', or None.

    Resolves siliconcompiler.targets.<name> dynamically. Helper callables in
    the package (ASIC, asic_target) are defined in the package itself, so a
    real target is one whose function lives in its own '<name>' submodule."""
    if name not in _SC_MODULES:
        return None
    module = importlib.import_module(f"{sc_targets.__name__}.{name}")
    return getattr(module, name, None)


def _mainlib_liberties(proj):
    """Typical-corner timing liberties of the project's main std-cell library.

    Feeds the yosys ASIC synthesis 'liberty' var on the lbflow path. The mainlib
    is registered by the SC target setup; we grab its object back and gather its
    nominal-corner NLDM liberty files. Most PDKs have one file in a single
    'models.timing.nldm' (nangate45) or 'models.timing.typical.nldm' fileset;
    some (e.g. asap7) split the library by cell group into several files, so we
    return all of them and yosys maps against each (dfflibmap/abc take repeated
    -liberty flags).
    """
    mainlib = proj.get("asic", "mainlib")
    lib = proj.get("library", mainlib, field="schema")
    libs = []
    for fs in lib.getkeys("fileset"):
        if "timing" not in fs:
            continue
        if fs == "models.timing.nldm" or "typical" in fs:
            for f in (lib.get_file(fileset=fs) or []):
                s = str(f)
                if s.endswith((".lib", ".lib.gz")):
                    libs.append(s)
    return sorted(set(libs))


def _bench_sdc(design):
    """The benchmark's own SDC path from its 'sdc' fileset, or '' if none.

    The SDC (when a benchmark ships one) declares its signal lists and sources
    the tech.tcl and default.sdc handed to it via LB_TECH_FILE / LB_DEFAULT_SDC.
    """
    if not design.has_fileset("sdc"):
        return ""
    files = design.get_file(fileset="sdc")
    return files[0] if files else ""


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
    """Write the SDC wrapper (always) and return its (absolute) path.

    The flow reads only this wrapper: SC's STA has no earlier hook to set the
    LB_* variables. It injects LB_CLK_NS and the tech/default paths, then sources
    the benchmark's own SDC when it ships one (bench_sdc), otherwise the shared
    default.sdc (which guardbands sensible defaults). Written to the build-dir
    root with an absolute path so SC resolves it regardless of design dataroot.
    """
    path = os.path.abspath(os.path.join(builddir, f"{name}_lbsdc.sdc"))
    os.makedirs(os.path.dirname(path), exist_ok=True)
    src = bench_sdc if bench_sdc else _DEFAULT_SDC
    with open(path, "w") as f:
        f.write(
            "# Generated by logikbench (asic.py): SDC wrapper. Injects lb --clk\n"
            "# (ns) + tech/default paths, then sources the benchmark SDC if it\n"
            "# ships one, else the shared default.sdc.\n"
            f"set LB_CLK_NS {clk_ns}\n"
            f"set LB_TECH_FILE {{{_tech_tcl(_pdk_of(target))}}}\n"
            f"set LB_DEFAULT_SDC {{{_DEFAULT_SDC}}}\n"
            f"source {{{src}}}\n")
    return path


def _setup_asic_project(design, setup_target, builddir, quiet, timeout, clk_ns):
    """Build the ASIC project shared by both ASIC paths (caller sets the flow).

    Configures the PDK, standard-cell library, and timing scenarios via the SC
    built-in target 'setup_target', trims to a single corner, and attaches the
    benchmark SDC (through the LB_* wrapper) to a dedicated 'lbsdc' fileset so
    SC's STA reads it. A benchmark with no SDC runs unconstrained.
    """
    proj = ASIC(design)
    proj.set("option", "builddir", builddir)
    if timeout is not None:
        proj.set("option", "timeout", timeout)
    _quiet(proj, quiet)
    _sc_target(setup_target)(proj)
    # one library / one corner: avoid reading every Vt x corner liberty on each
    # STA node (see _single_corner); LogikBench needs only single-corner QoR.
    _single_corner(proj)
    proj.add_fileset("rtl")
    # Always attach the generated SDC wrapper (in its own 'lbsdc' fileset): it
    # injects the LB_* vars and sources the benchmark SDC if present, else the
    # shared default.sdc. So every benchmark is constrained even with no own SDC.
    wrapper = _write_sc_wrapper(builddir, design.name, setup_target, clk_ns,
                                _bench_sdc(design))
    design.add_file(wrapper, fileset="lbsdc")
    proj.add_fileset("lbsdc")
    return proj


def _run_lbflow(design, target, options, builddir, quiet, start, stop, timeout,
                clk_ns=DEFAULT_CLK_NS):
    """ASIC flow: Synthesis + SC OpenSTA timing (synth + STA, no P&R).

    The target '<tool>_<pdk>' selects the mapper: 'yosys_<pdk>' runs yosys,
    'tardigrade_<pdk>' runs tardigrade. Both reuse the matching SC target
    (via the pdk->module lookup) for PDK/library/single-corner setup, then run
    the two-node synth+timing flow. SC's TimingTask records the full metric set
    (fmax, cells, cellarea, nets, pins, registers, slacks, power, ...) from the
    mapped netlist, so the two mappers are directly comparable. 'options' pass
    through to the active mapper verbatim.
    """
    tool, pdk = target.split("_", 1)
    proj = _setup_asic_project(design, _SC_MODULE[pdk], builddir, quiet,
                               timeout, clk_ns)
    proj.set_flow(ASICSynthesis(tool=tool))

    def synvar(key, value):
        proj.set("tool", tool, "task", "synthesis", "var", key, value)

    synvar("liberty", _mainlib_liberties(proj))
    if tool == "yosys":
        synvar("mode", "asic")
        synvar("ignore_initial",
               bool(getattr(design, "ignore_initial", False)))
    if options:
        synvar("options", options.split())
    _set_range(proj, start, stop)
    proj.run()
    if not quiet:
        proj.summary()


def _run_scflow(design, target, builddir, quiet, start, stop, timeout,
                clk_ns=DEFAULT_CLK_NS):
    """SC built-in target (PDK + libs + scenarios) run through asicflow.

    'target' is 'sc_<pdk>'; the pdk->module lookup resolves it to the SC setup
    module ('sc_asap7' -> 'asap7_demo')."""
    pdk = target.split("_", 1)[1]
    proj = _setup_asic_project(design, _SC_MODULE[pdk], builddir, quiet,
                               timeout, clk_ns)
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
    if not quiet:
        proj.summary()
