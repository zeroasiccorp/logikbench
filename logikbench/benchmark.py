"""Drive LogikBench benchmarks through SiliconCompiler.

Targets (--target) select what runs:
  * an FPGA target name (e.g. 'ice40', 'xilinx', 'zeroasic') or no target ->
    the custom 'lbflow' FPGA synthesis; the target picks the yosys synth
    command (see scripts/fpga/synthesis_fpga.tcl);
  * a lambdapdk PDK name (e.g. 'freepdk45') -> the custom 'lbflow' ASIC path
    (Yosys synthesis plus OpenSTA timing);
  * a '<pdk>_demo' name (e.g. 'asap7_demo') -> the official SC demo target
    (PDK + libraries + scenarios) run through SiliconCompiler's 'asicflow'.
"""

import json
import logging
import os
import shutil

from siliconcompiler import Project, ASIC
from siliconcompiler.metrics import FPGAMetricsSchema, ASICMetricsSchema
from siliconcompiler.schema import EditableSchema
from siliconcompiler.flows import asicflow
from siliconcompiler.targets import (
    freepdk45_demo, asap7_demo, skywater130_demo, gf180_demo, ihp130_demo)

from logikbench.flows.synth import FPGASynthesis, ASICSynthesis

# SC-standard metric names tracked per run mode.
FPGA_METRICS = ["luts", "logicdepth", "tasktime"]
ASIC_METRICS = ["cells", "cellarea", "fmax", "tasktime"]

_INDEX = "0"
_LBFLOW_ASIC_RECIPE = "asic/freepdk45"

# Vendored zeroasic FPGA architecture files (one subdir per part), fetched from
# siliconcompiler/logiklib releases by scripts/fetch_zeroasic_arch.py. Each part
# dir holds a '<part>_yosys_config.json' passed to wildebeest 'synth_fpga
# -config', which sets partname, lut size, and the flop/BRAM/DSP techmaps.
_ZEROASIC_ARCH_DIR = os.path.join(
    os.path.dirname(os.path.abspath(__file__)), "targets", "fpga", "zeroasic")


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

# all valid --target values, and the subset the custom lbflow supports
TARGETS = list(FPGA_TARGETS) + list(_LBFLOW_PDKS) + list(_DEMO_TARGETS)
LBFLOW_TARGETS = list(FPGA_TARGETS) + list(_LBFLOW_PDKS)

# Friendly stage names -> SC node names. A stage spans several SC nodes, so
# --start maps to its first node and --stop to its last.
STEPS = ["synthesis", "floorplan", "place", "cts", "route"]
_STEP_FROM = {
    "synthesis": "synthesis",
    "floorplan": "floorplan.init",
    "place": "place.global",
    "cts": "cts.clock_tree_synthesis",
    "route": "route.global",
}
_STEP_TO = {
    "synthesis": "synthesis",
    "floorplan": "floorplan.pin_placement",
    "place": "place.detailed",
    "cts": "cts.fillcell",
    "route": "route.detailed",
}


def default_sdc(recipe=_LBFLOW_ASIC_RECIPE):
    """Path to a generic clock-constraint SDC (create_clock on a 'clk' port)."""
    here = os.path.dirname(os.path.abspath(__file__))
    return os.path.join(here, "targets", *recipe.split("/"), "default.sdc")


def _set_range(proj, start, stop):
    """Restrict the run to a step range, mapping friendly names to SC nodes."""
    if start:
        proj.set("option", "from", [_STEP_FROM.get(start, start)])
    if stop:
        proj.set("option", "to", [_STEP_TO.get(stop, stop)])


def _quiet(proj, quiet):
    proj.set("option", "nodashboard", True)
    if quiet:
        proj.set("option", "quiet", True)
        proj.logger.setLevel(logging.ERROR)


def _base_project(design, builddir, metric_schema, quiet, timeout=None):
    """Base Project for the custom lbflow (attaches the metric schema)."""
    proj = Project(design)
    EditableSchema(proj).insert("metric", metric_schema, clobber=True)
    proj.set("option", "builddir", builddir)
    if timeout is not None:
        # per-step wall-clock cap (seconds); SC kills the tool tree on expiry
        proj.set("option", "timeout", timeout)
    _quiet(proj, quiet)
    return proj


def read_metrics(name, metrics=ASIC_METRICS, builddir="build", jobname="job0"):
    """Read recorded metric values from a job manifest, without synthesizing.

    Scans the manifest for each metric at whichever node recorded it, so it
    works across flows (lbflow, asicflow). 'tasktime' is read only from the
    'synthesis' node (the synthesis runtime SC records there), not the later
    place-and-route nodes; every other metric takes the last reported value.
    Returns {metric: value} or None.
    """
    manifest = os.path.join(builddir, name, jobname, f"{name}.pkg.json")
    if not os.path.isfile(manifest):
        return None
    with open(manifest) as f:
        data = json.load(f)
    out = {}
    for metric in metrics:
        out[metric] = None
        nodes = data.get("metric", {}).get(metric, {}).get("node", {})
        # synthesis-runtime metric: take it from the synthesis node only
        if metric == "tasktime":
            for rec in nodes.get("synthesis", {}).values():
                if rec.get("value") is not None:
                    out[metric] = rec.get("value")
            continue
        for idxs in nodes.values():
            for rec in idxs.values():
                val = rec.get("value")
                if val is not None:
                    out[metric] = val
    return out


def read_asic_metrics(name, builddir="build", jobname="job0"):
    """Read ASIC metrics from a prior run's manifest (no synthesis)."""
    return read_metrics(name, ASIC_METRICS, builddir, jobname)


def read_tool_var(name, tool, task, var, builddir="build", jobname="job0"):
    """Read a tool/task variable value recorded in a benchmark's manifest.

    Used to recover the settings a run was driven with (e.g. the FPGA synth
    'options' string that lb passed through). Returns the value, or None if the
    manifest or variable is absent.
    """
    manifest = os.path.join(builddir, name, jobname, f"{name}.pkg.json")
    if not os.path.isfile(manifest):
        return None
    with open(manifest) as f:
        data = json.load(f)
    nodes = (data.get("tool", {}).get(tool, {}).get("task", {}).get(task, {})
             .get("var", {}).get(var, {}).get("node", {}))
    for idxs in nodes.values():
        for rec in idxs.values():
            val = rec.get("value")
            if val is not None:
                return val
    return None


def is_complete(name, builddir="build", jobname="job0"):
    """True if a prior run finished with every node in 'success' status."""
    manifest = os.path.join(builddir, name, jobname, f"{name}.pkg.json")
    if not os.path.isfile(manifest):
        return False
    with open(manifest) as f:
        data = json.load(f)
    nodes = data.get("record", {}).get("status", {}).get("node", {})
    statuses = [rec.get("value")
                for idxs in nodes.values() for rec in idxs.values()
                if rec.get("value") is not None]
    return bool(statuses) and all(s == "success" for s in statuses)


def _run_fpga(design, target, options, builddir, quiet, start, stop, timeout):
    """lbflow FPGA synthesis; the target name maps to a yosys synth command."""
    proj = _base_project(design, builddir, FPGAMetricsSchema(), quiet, timeout)
    proj.add_fileset("rtl")
    proj.set_flow(FPGASynthesis())
    proj.set("tool", "yosys", "task", "synthesis", "var", "mode", "fpga")
    proj.set("tool", "yosys", "task", "synthesis", "var", "command",
             FPGA_TARGETS[target])
    proj.set("tool", "yosys", "task", "synthesis", "var", "options", options)
    _set_range(proj, start, stop)
    proj.run()


def _run_lbflow_asic(design, target, builddir, quiet, start, stop, timeout):
    """lbflow ASIC (Yosys synthesis + OpenSTA timing) for a single-liberty PDK."""
    liberty = _LBFLOW_PDKS[target]()
    proj = _base_project(design, builddir, ASICMetricsSchema(), quiet, timeout)
    proj.add_fileset("rtl")
    proj.set_flow(ASICSynthesis())
    proj.set("tool", "yosys", "task", "synthesis", "var", "mode", "asic")
    proj.set("tool", "yosys", "task", "synthesis", "var", "liberty", liberty)
    proj.set("tool", "opensta", "task", "timing", "var", "target", _LBFLOW_ASIC_RECIPE)
    proj.set("tool", "opensta", "task", "timing", "var", "liberty", liberty)
    proj.set("tool", "opensta", "task", "timing", "var", "sdc", default_sdc())
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


def _run_demo(design, target, builddir, quiet, start, stop, timeout):
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
    # benchmarks ship no SDC; attach a generic clock so STA can constrain
    design.add_file(default_sdc(), fileset="sdc")
    proj.add_fileset("rtl")
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


def benchmark_name(group, item):
    """SC design name for a benchmark class. May differ from item.lower()
    (e.g. class EPFLArbiter -> design name 'epfl_arbiter'), so callers that key
    builds/metrics by name must use this, not the class name."""
    import logikbench
    return getattr(getattr(logikbench, group), item)().name


def run_one(group, item, target=None, options="", builddir="build", quiet=True,
            start=None, stop=None, timeout=None):
    """Run a single benchmark; return (group, item, metrics, error).

    Dispatches on --target. Catches errors and returns them so a pool worker
    never crashes the parent. Module-level so it is picklable for the pool.
    'timeout' (seconds, or None) caps each step's wall clock; SC kills the tool
    tree on expiry and the step fails, so one hung synth cannot stall a sweep.
    """
    import logikbench
    design = getattr(getattr(logikbench, group), item)()
    # key off the SC design name, not the class name: a class like EPFLArbiter
    # has design name 'epfl_arbiter', so item.lower() would not match its build
    # dir or recorded metrics.
    name = design.name
    # fresh run by default (avoids SC build reuse); keep the prior build only
    # when resuming mid-flow with --start, which needs earlier steps' outputs.
    # --stop alone still runs from the beginning, so it wipes.
    if not start:
        shutil.rmtree(os.path.join(builddir, name), ignore_errors=True)
    try:
        if target in _DEMO_TARGETS:
            _run_demo(design, target, builddir, quiet, start, stop, timeout)
            metrics = read_metrics(name, ASIC_METRICS, builddir)
        elif target in _LBFLOW_PDKS:
            _run_lbflow_asic(design, target, builddir, quiet, start, stop, timeout)
            metrics = read_metrics(name, ASIC_METRICS, builddir)
        elif target in FPGA_TARGETS:
            _run_fpga(design, target, options, builddir, quiet, start, stop, timeout)
            metrics = read_metrics(name, FPGA_METRICS, builddir)
        else:
            raise ValueError(
                f"target '{target}' is not supported by lbflow; "
                f"use its demo target (e.g. '{target}_demo')")
        return (group, item, metrics, None)
    except Exception as e:  # noqa: BLE001 - report to parent, keep the sweep going
        return (group, item, None, str(e))
