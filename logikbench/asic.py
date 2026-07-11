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
from logikbench.flows.pnr.asic import ASICPnR
from siliconcompiler.tools.yosys.syn_asic import ASICSynthesis as _YosysSyn
from lambdalib.ramlib import RAMTechLib

from logikbench.flows.syn import ASICSynthesis
from logikbench.common import _set_range, _quiet

# The default clock period is NOT overridden here: when 'lb --clk' is not given
# each PDK's tech.tcl provides LB_CLK_NS (and the ns->unit scaling), so the
# clock is derived from tech.tcl (see _abc_clk_period / _write_sc_wrapper).

# Shared ASIC constraint files under logikbench/targets. The per-PDK tech.tcl
# (timing knobs + ns->unit scaling) and the shared default.sdc are sourced by
# each benchmark's own SDC via LB_TECH_FILE / LB_DEFAULT_SDC.
_TARGETS_DIR = os.path.join(
    os.path.dirname(os.path.abspath(__file__)), "targets")

_DEFAULT_SDC = os.path.join(_TARGETS_DIR, "default.sdc")


def _tech_tcl(pdk):
    """Absolute path to a PDK's tech.tcl (timing knobs + ns->unit scaling)."""
    return os.path.join(_TARGETS_DIR, pdk, "tech.tcl")


# lb-facing renames: a few internal names get shorter target tokens. The SC
# target module (e.g. 'skywater130_demo') and the mapper Task ('tardigrade')
# keep their names; only the token shown in lb targets changes.
_PDK_RENAME = {"skywater130": "sky130"}       # SC pdk stem -> lb pdk token
_TOOL_RENAME = {"tardigrade": "tg"}           # mapper name -> lb tool token
_TOOL_UNRENAME = {v: k for k, v in _TOOL_RENAME.items()}


def _pdk_of(module):
    """lb-facing PDK name for an SC target module ('asap7_demo' -> 'asap7').
    A few are shortened for lb targets (e.g. 'skywater130_demo' -> 'sky130');
    this same name is used for the target token and the targets/<pdk> tech dir."""
    pdk = module[:-len("_demo")] if module.endswith("_demo") else module
    return _PDK_RENAME.get(pdk, pdk)


# Raw SC built-in target module names (e.g. 'asap7_demo'), discovered from
# siliconcompiler.targets so we track SC's set rather than mirroring it. These
# are the names passed to the SC setup function; lb exposes them as 'sc_<pdk>'.
# Real PDK targets are SC's '<pdk>_demo' modules; skip helper modules that are
# not standard-cell PDKs (e.g. '_utils', the 'dvflow_cocotb' DV flow), which
# would otherwise show up as bogus targets like 'sc__utils'. 'interposer' is a
# demo module but has no standard cells, so it is not a benchmark target either.
_SC_MODULES = sorted(m.name for m in pkgutil.iter_modules(sc_targets.__path__)
                     if m.name.endswith("_demo")
                     and m.name != "interposer_demo")

# pdk -> SC target module ('asap7' -> 'asap7_demo'): the name lookup that maps
# an lb ASIC target's pdk back to the SC setup module (SC names them '_demo').
_SC_MODULE = {_pdk_of(m): m for m in _SC_MODULES}

# All std-cell PDKs. Both the SC asicflow and the lbflow paths (yosys /
# tardigrade) run on the full set.
_SC_PDKS = sorted(_SC_MODULE)
_LBFLOW_PDKS = list(_SC_PDKS)

# lb-facing ASIC target names, all '<tool>_<pdk>' to match the FPGA
# '<vendor>_<part>' scheme (tool/company first, part/pdk second):
#   sc_<pdk>     -> SC 'asicflow' (PDK + libs + scenarios, through P&R)
#   yosys_<pdk>  -> lbflow: yosys synthesis + OpenSTA timing (no P&R)
#   tg_<pdk>     -> lbflow with tardigrade as the synthesis mapper
SC_TARGETS = [f"sc_{pdk}" for pdk in _SC_PDKS]
YOSYS_TARGETS = [f"yosys_{pdk}" for pdk in _LBFLOW_PDKS]
TARDIGRADE_TARGETS = [f"{_TOOL_RENAME['tardigrade']}_{pdk}"
                      for pdk in _LBFLOW_PDKS]


def _sc_target(name):
    """Return the SC built-in target setup function for 'name', or None.

    Resolves siliconcompiler.targets.<name> dynamically. Helper callables in
    the package (ASIC, asic_target) are defined in the package itself, so a
    real target is one whose function lives in its own '<name>' submodule."""
    if name not in _SC_MODULES:
        return None
    module = importlib.import_module(f"{sc_targets.__name__}.{name}")
    return getattr(module, name, None)


def _setup_libcorners(proj):
    """Libcorners of the scenario STA checks setup on.

    These are the corners yosys should map against so lbflow synthesis matches
    sign-off (mirrors SC's ASICSynthesis._determine_synthesis_corner on the
    asicflow path). Prefer a scenario whose 'check' includes 'setup'; fall back
    to the first scenario that names a libcorner. Empty if no scenario defines a
    libcorner (unconstrained run)."""
    scenarios = proj.getkeys("constraint", "timing", "scenario")

    def libcorner(s):
        return proj.get("constraint", "timing", "scenario", s, "libcorner") or []

    for s in scenarios:
        checks = proj.get("constraint", "timing", "scenario", s, "check") or []
        if "setup" in checks and libcorner(s):
            return list(libcorner(s))
    for s in scenarios:
        if libcorner(s):
            return list(libcorner(s))
    return []


def _mapping_liberties(proj):
    """Setup-corner timing liberties of the full standard-cell library set.

    Feeds the yosys ASIC synthesis 'liberty' var on the lbflow path: the mainlib
    PLUS the extra Vt std-cell asiclib variants (RVT/LVT/SLVT for asap7), so the
    mapper can pick cells across all Vt flavors, matching the SC asicflow. Macro
    libraries (RAMTechLib, e.g. SRAM) are NOT mapping targets -- they are read
    as blackboxes instead (see _macro_liberties) -- so they are skipped here.

    yosys maps against the corner(s) the setup scenario names (see
    _setup_libcorners), the same corner SC's own synthesis uses, so lbflow
    synthesis tracks the corner STA signs off setup/fmax on and the two stay
    correlated. asap7 also splits each library by cell group into several files,
    so we return all of them and yosys maps against each (dfflibmap/abc take
    repeated -liberty flags).
    """
    delaymodel = proj.get("asic", "delaymodel")
    corners = _setup_libcorners(proj)
    names = [proj.get("asic", "mainlib")] + list(proj.get("asic", "asiclib"))
    libs = []
    for name in names:
        lib = proj.get("library", name, field="schema")
        if isinstance(lib, RAMTechLib):
            continue
        for corner in corners:
            if not lib.valid("asic", "libcornerfileset", corner, delaymodel):
                continue
            for fs in lib.get("asic", "libcornerfileset", corner, delaymodel):
                for f in (lib.get_file(fileset=fs) or []):
                    s = str(f)
                    if s.endswith((".lib", ".lib.gz")):
                        libs.append(s)
    return sorted(set(libs))


def _macro_liberties(proj):
    """Setup-corner NLDM liberties of the ASIC macro libraries (e.g. SRAM).

    A hard macro (like the SRAM the lambdalib memory alias binds) ships as a
    liberty + LEF blackbox, no synthesizable RTL. The lbflow yosys synth reads
    these as '-lib' blackboxes BEFORE the design so an instantiated macro stays
    a blackbox instead of being synthesized to flip-flops (matching the SC
    asicflow). Only RAMTechLib libraries are macros; the extra Vt std-cell
    asiclibs are mapping cells, not macros, so they are skipped.
    """
    delaymodel = proj.get("asic", "delaymodel")
    corners = _setup_libcorners(proj)
    libs = []
    for name in proj.get("asic", "asiclib"):
        lib = proj.get("library", name, field="schema")
        if not isinstance(lib, RAMTechLib):
            continue
        for corner in corners:
            if not lib.valid("asic", "libcornerfileset", corner, delaymodel):
                continue
            for fs in lib.get("asic", "libcornerfileset", corner, delaymodel):
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


def _write_sc_wrapper(builddir, name, target, clk_ns, bench_sdc):
    """Write the SDC wrapper (always) and return its (absolute) path.

    The flow reads only this wrapper: SC's STA has no earlier hook to set the
    LB_* variables. It sets the tech/default paths, then sources the benchmark's
    own SDC when it ships one (bench_sdc), otherwise the shared default.sdc
    (which guardbands sensible defaults). LB_CLK_NS is injected only when 'lb
    --clk' (clk_ns) is given; otherwise the PDK's tech.tcl supplies its default.
    Written to the build-dir root with an absolute path so SC resolves it
    regardless of design dataroot.
    """
    path = os.path.abspath(os.path.join(builddir, f"{name}_lbsdc.sdc"))
    os.makedirs(os.path.dirname(path), exist_ok=True)
    src = bench_sdc if bench_sdc else _DEFAULT_SDC
    clk_line = f"set LB_CLK_NS {clk_ns}\n" if clk_ns is not None else ""
    with open(path, "w") as f:
        f.write(
            "# Generated by logikbench (asic.py): SDC wrapper. Injects lb --clk\n"
            "# (ns, only when given) + tech/default paths, then sources the\n"
            "# benchmark SDC if it ships one, else the shared default.sdc.\n"
            f"{clk_line}"
            f"set LB_TECH_FILE {{{_tech_tcl(_pdk_of(target))}}}\n"
            f"set LB_DEFAULT_SDC {{{_DEFAULT_SDC}}}\n"
            f"source {{{src}}}\n")
    return path


def _setup_asic_project(design, setup_target, builddir, quiet, timeout, clk_ns):
    """Build the ASIC project shared by both ASIC paths (caller sets the flow).

    Configures the PDK, standard-cell library, and timing scenarios via the SC
    built-in target 'setup_target', and attaches the benchmark SDC (through the
    LB_* wrapper) to a dedicated 'lbsdc' fileset so SC's STA reads it. A
    benchmark with no SDC runs unconstrained.
    """
    proj = ASIC(design)
    proj.set("option", "builddir", builddir)
    if timeout is not None:
        proj.set("option", "timeout", timeout)
    _quiet(proj, quiet)
    # Load the design (and its lambdalib memory deps, e.g. la_spram) BEFORE the
    # PDK target: the target (e.g. asap7_demo) registers the PDK's lambdalib
    # aliases (fakeram etc.), and alias() only binds memories already present.
    proj.add_fileset("rtl")
    _sc_target(setup_target)(proj)
    # Per-target design setup (scgallery-style), if the benchmark registered one.
    if hasattr(design, "process_setups"):
        design.process_setups(_pdk_of(setup_target), proj)
    # Always attach the generated SDC wrapper (in its own 'lbsdc' fileset): it
    # injects the LB_* vars and sources the benchmark SDC if present, else the
    # shared default.sdc. So every benchmark is constrained even with no own SDC.
    wrapper = _write_sc_wrapper(builddir, design.name, setup_target, clk_ns,
                                _bench_sdc(design))
    design.add_file(wrapper, fileset="lbsdc")
    proj.add_fileset("lbsdc")
    return proj


def _run_lbflow(design, target, options, builddir, quiet, start, stop, timeout,
                clk_ns=None, lintonly=False):
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
    tool = _TOOL_UNRENAME.get(tool, tool)   # lb token 'tg' -> mapper 'tardigrade'
    proj = _setup_asic_project(design, _SC_MODULE[pdk], builddir, quiet,
                               timeout, clk_ns)
    proj.set_flow(ASICSynthesis(tool=tool))

    def synvar(key, value):
        proj.set("tool", tool, "task", "synthesis", "var", key, value)

    synvar("liberty", _mapping_liberties(proj))
    if tool == "yosys":
        synvar("mode", "asic")
        synvar("ignore_initial",
               bool(getattr(design, "ignore_initial", False)))
        # hard-macro liberties read as blackboxes so an instantiated SRAM (via
        # the lambdalib memory alias) stays a macro instead of mapping to flops.
        synvar("macrolib", _macro_liberties(proj))
    elif tool == "tardigrade":
        synvar("pdk", pdk)
    if options:
        synvar("options", options.split())
    if lintonly:
        # elaborate-only: the mapper parses the RTL then stops before synth;
        # stop after the synthesis node so the timing node (no netlist) is
        # skipped.
        synvar("lintonly", True)
        stop = "synthesis"
    _set_range(proj, start, stop)
    proj.run()
    if not quiet:
        proj.summary()


def _run_scflow(design, target, builddir, quiet, start, stop, timeout,
                clk_ns=None, lintonly=False):
    """SC built-in target (PDK + libs + scenarios) run through asicflow.

    'target' is 'sc_<pdk>'; the pdk->module lookup resolves it to the SC setup
    module ('sc_asap7' -> 'asap7_demo')."""
    pdk = target.split("_", 1)[1]
    proj = _setup_asic_project(design, _SC_MODULE[pdk], builddir, quiet,
                               timeout, clk_ns)
    proj.set_flow(ASICPnR())
    # read RTL via slang in synthesis (read_verilog fails on package SV)
    _YosysSyn.find_task(proj).set_yosys_useslang(True)
    # LogikBench designs are IO-dominated (wide buses, tiny logic), so the
    # demo's 40%-utilization die can't fit the pins on its perimeter. Grow the
    # die with a low utilization and halve the default 2-track pin spacing; the
    # two together give enough perimeter slots for these pin-heavy designs.
    proj.constraint.area.set_density(10)
    proj.set("tool", "openroad", "task", "pin_placement", "var",
             "ppl_arguments", ["-min_distance", "1", "-min_distance_in_tracks"])
    # lint-only: the asicflow has a dedicated slang 'elaborate' node, so stop
    # after it (before synthesis) rather than via a tool var.
    if lintonly:
        stop = "elaborate"
    elif stop is None:
        # Default to ending at synthesis timing (no P&R), matching the lbflow
        # (yosys/tardigrade) paths so every ASIC flow reports comparable
        # synthesis-stage metrics by default. Pass --to explicitly (e.g.
        # --to route) to run the full asicflow through place-and-route.
        stop = "synthesis.timing"
    _set_range(proj, start, stop)
    proj.run()
    if not quiet:
        proj.summary()
