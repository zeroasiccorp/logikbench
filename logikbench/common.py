"""Shared SiliconCompiler plumbing for LogikBench benchmark runs.

Flow-agnostic helpers used by both the FPGA and ASIC run paths: metric-name
lists, the friendly stage-name -> SC-node maps, project setup, and the
manifest readers that recover metrics/settings from a completed job.
"""

import json
import logging
import os

from siliconcompiler import Project
from siliconcompiler.schema import EditableSchema

# SC-standard metric names tracked per run mode.
FPGA_METRICS = ["luts", "logicdepth", "tasktime"]
ASIC_METRICS = ["cells", "cellarea", "fmax", "tasktime"]

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


def benchmark_name(group, item):
    """SC design name for a benchmark class. May differ from item.lower()
    (e.g. class EPFLArbiter -> design name 'epfl_arbiter'), so callers that key
    builds/metrics by name must use this, not the class name."""
    import logikbench
    return getattr(getattr(logikbench, group), item)().name
