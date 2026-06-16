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
METRICS = ["cells", "luts", "nets", "pins", "tasktime"]
ASIC_METRICS = ["cells", "cellarea", "fmax", "setupslack"]

_INDEX = "0"
_LBFLOW_ASIC_RECIPE = "asic/freepdk45"

# FPGA target names decoded by scripts/fpga/synthesis_fpga.tcl. A --target in
# this list (or no target) runs FPGA synthesis; anything else is an ASIC PDK.
FPGA_TARGETS = ["zeroasic", "microchip", "fabulous", "gatemate", "gowin",
                "ice40", "xilinx", "efinix", "achronix", "quicklogic", "intel"]
_DEFAULT_FPGA_TARGET = "zeroasic"


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
TARGETS = FPGA_TARGETS + list(_LBFLOW_PDKS) + list(_DEMO_TARGETS)
LBFLOW_TARGETS = FPGA_TARGETS + list(_LBFLOW_PDKS)

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
    here = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
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


def _base_project(design, builddir, metric_schema, quiet):
    """Base Project for the custom lbflow (attaches the metric schema)."""
    proj = Project(design)
    EditableSchema(proj).insert("metric", metric_schema, clobber=True)
    proj.set("option", "builddir", builddir)
    _quiet(proj, quiet)
    return proj


def read_metrics(name, metrics=ASIC_METRICS, builddir="build", jobname="job0"):
    """Read recorded metric values from a job manifest, without synthesizing.

    Scans the manifest for each metric at whichever node recorded it, so it
    works across flows (lbflow, asicflow). Returns {metric: value} or None.
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
        for idxs in nodes.values():
            for rec in idxs.values():
                val = rec.get("value")
                if val is not None:
                    out[metric] = val
    return out


def read_asic_metrics(name, builddir="build", jobname="job0"):
    """Read ASIC metrics from a prior run's manifest (no synthesis)."""
    return read_metrics(name, ASIC_METRICS, builddir, jobname)


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


def _run_fpga(design, target, options, builddir, quiet, start, stop):
    """lbflow FPGA synthesis; target picks the yosys synth command."""
    proj = _base_project(design, builddir, FPGAMetricsSchema(), quiet)
    proj.add_fileset("rtl")
    proj.set_flow(FPGASynthesis())
    proj.set("tool", "yosys", "task", "synthesis", "var", "mode", "fpga")
    proj.set("tool", "yosys", "task", "synthesis", "var", "target",
             target or _DEFAULT_FPGA_TARGET)
    proj.set("tool", "yosys", "task", "synthesis", "var", "options", options)
    _set_range(proj, start, stop)
    proj.run()


def _run_lbflow_asic(design, target, builddir, quiet, start, stop):
    """lbflow ASIC (Yosys synthesis + OpenSTA timing) for a single-liberty PDK."""
    liberty = _LBFLOW_PDKS[target]()
    proj = _base_project(design, builddir, ASICMetricsSchema(), quiet)
    proj.add_fileset("rtl")
    proj.set_flow(ASICSynthesis())
    proj.set("tool", "yosys", "task", "synthesis", "var", "mode", "asic")
    proj.set("tool", "yosys", "task", "synthesis", "var", "liberty", liberty)
    proj.set("tool", "opensta", "task", "timing", "var", "target", _LBFLOW_ASIC_RECIPE)
    proj.set("tool", "opensta", "task", "timing", "var", "liberty", liberty)
    proj.set("tool", "opensta", "task", "timing", "var", "sdc", default_sdc())
    _set_range(proj, start, stop)
    proj.run()


def _run_demo(design, target, builddir, quiet, start, stop):
    """Official SC demo target (PDK + libs + scenarios) run through asicflow."""
    proj = ASIC(design)
    proj.set("option", "builddir", builddir)
    _quiet(proj, quiet)
    _DEMO_TARGETS[target](proj)
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


def run_one(group, item, target=None, options="", builddir="build", quiet=True,
            start=None, stop=None):
    """Run a single benchmark; return (group, item, metrics, error).

    Dispatches on --target. Catches errors and returns them so a pool worker
    never crashes the parent. Module-level so it is picklable for the pool.
    """
    import logikbench
    design = getattr(getattr(logikbench, group), item)()
    name = item.lower()
    # fresh run by default (avoids SC build reuse); keep the prior build only
    # when resuming mid-flow with --start, which needs earlier steps' outputs.
    # --stop alone still runs from the beginning, so it wipes.
    if not start:
        shutil.rmtree(os.path.join(builddir, name), ignore_errors=True)
    try:
        if target in _DEMO_TARGETS:
            _run_demo(design, target, builddir, quiet, start, stop)
            metrics = read_metrics(name, ASIC_METRICS, builddir)
        elif target in _LBFLOW_PDKS:
            _run_lbflow_asic(design, target, builddir, quiet, start, stop)
            metrics = read_metrics(name, ASIC_METRICS, builddir)
        elif target is None or target in FPGA_TARGETS:
            _run_fpga(design, target, options, builddir, quiet, start, stop)
            metrics = read_metrics(name, METRICS, builddir)
        else:
            raise ValueError(
                f"target '{target}' is not supported by lbflow; "
                f"use its demo target (e.g. '{target}_demo')")
        return (group, item, metrics, None)
    except Exception as e:  # noqa: BLE001 - report to parent, keep the sweep going
        return (group, item, None, str(e))
