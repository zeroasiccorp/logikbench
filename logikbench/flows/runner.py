"""Drive the LogikBench synthesis flow through SiliconCompiler.

These helpers wrap the boilerplate of running a benchmark Design through
FpgaSynthFlow on a base SiliconCompiler Project and reading back metrics, so
the 'lb' app (and a future sweep) can stay small.
"""

import json
import logging
import os
import shutil

from siliconcompiler import Project
from siliconcompiler.metrics import FPGAMetricsSchema, ASICMetricsSchema
from siliconcompiler.schema import EditableSchema

from logikbench.flows.synth import FPGASynthesis, ASICSynthesis

# SC-standard metric names the FPGA flow produces (single 'synthesis' node).
METRICS = ["cells", "luts", "nets", "pins", "tasktime"]

# ASIC flow metrics, with the flow step each is read from.
ASIC_METRIC_STEP = {
    "cells": "synthesis",
    "cellarea": "synthesis",
    "fmax": "timing",
    "setupslack": "timing",
}
ASIC_METRICS = list(ASIC_METRIC_STEP.keys())

# The FPGA flow has a single synthesis node at index 0.
_STEP = "synthesis"
_INDEX = "0"

# FPGA recipe directory under logikbench/targets (ASIC targets: see _ASIC_PDKS).
_FPGA_TARGET = "fpga/zeroasic"


def _nangate45_liberty():
    """Resolve the nangate45 standard-cell liberty (auto-fetched by SC)."""
    from lambdapdk.freepdk45.libs.nangate45 import Nangate45
    return Nangate45().get_file(fileset="models.timing.nldm")[0]


# ASIC PDKs: name -> recipe target dir + liberty resolver. Add entries here as
# more standard-cell libraries are supported.
_ASIC_PDKS = {
    "nangate45": {"target": "asic/nangate45", "liberty": _nangate45_liberty},
}
ASIC_PDKS = list(_ASIC_PDKS.keys())


def default_sdc(target):
    """Path to a target's generic ASIC timing constraints (default.sdc)."""
    here = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    return os.path.join(here, "targets", *target.split("/"), "default.sdc")


def _project(design, builddir, metric_schema, quiet=True):
    """Build a base Project for a benchmark Design.

    A base Project does not register the design metrics (cells, luts, fmax,
    ...), so we attach the relevant SC metric schema (FPGA or ASIC); that is
    the only thing needed beyond base classes to record/read SC-standard
    metrics without an FPGA/ASIC project (and its device/PDK requirements).

    When quiet (the default), SiliconCompiler's tool output and scheduler
    logging are suppressed; pass quiet=False for full SC logs.
    """
    proj = Project(design)
    EditableSchema(proj).insert("metric", metric_schema, clobber=True)
    proj.set("option", "builddir", builddir)
    # batch synthesis: no interactive CLI dashboard
    proj.set("option", "nodashboard", True)
    if quiet:
        proj.set("option", "quiet", True)
        proj.logger.setLevel(logging.ERROR)
    return proj


def _read_manifest_metrics(name, builddir, jobname, metric_step):
    """Read recorded metric values from a job manifest JSON.

    metric_step maps each metric to the flow step it was recorded at. Reading
    the JSON directly avoids losing metric keys on a base Project reload.
    Returns a {metric: value} dict, or None if no manifest exists.
    """
    manifest = os.path.join(builddir, name, jobname, f"{name}.pkg.json")
    if not os.path.isfile(manifest):
        return None
    with open(manifest) as f:
        data = json.load(f)
    out = {}
    for metric, step in metric_step.items():
        try:
            out[metric] = data["metric"][metric]["node"][step][_INDEX]["value"]
        except (KeyError, TypeError):
            out[metric] = None
    return out


def run_design(design, builddir="build", quiet=True):
    """Synthesize one benchmark Design (FPGA flow); return {metric: value}.

    Raises on run failure so the caller can record it and continue.
    """
    proj = _project(design, builddir, FPGAMetricsSchema(), quiet=quiet)
    proj.add_fileset("rtl")
    proj.set_flow(FPGASynthesis())
    # configure the task via the project (persists through node reconstruction)
    proj.set("tool", "yosys", "task", "synth", "var", "target", _FPGA_TARGET)
    result = proj.run()
    return {m: result.get("metric", m, step=_STEP, index=_INDEX) for m in METRICS}


def read_metrics(name, builddir="build", jobname="job0"):
    """Read FPGA-flow metrics from a prior run's manifest (no synthesis)."""
    return _read_manifest_metrics(
        name, builddir, jobname, {m: _STEP for m in METRICS})


def run_asic_design(design, builddir="build", pdk="nangate45",
                    sdc=None, quiet=True):
    """Run the 2-node ASIC flow (Yosys synthesis + OpenSTA); return metrics.

    pdk selects the standard-cell library/recipe (see ASIC_PDKS). Raises on run
    failure so the caller can record it and continue.
    """
    cfg = _ASIC_PDKS[pdk]
    target = cfg["target"]
    liberty = cfg["liberty"]()
    sdc = sdc if sdc is not None else default_sdc(target)

    proj = _project(design, builddir, ASICMetricsSchema(), quiet=quiet)
    proj.add_fileset("rtl")
    proj.set_flow(ASICSynthesis())

    # configure the tasks via the project (persists through node reconstruction)
    proj.set("tool", "yosys", "task", "synth", "var", "target", target)
    proj.set("tool", "yosys", "task", "synth", "var", "liberty", liberty)
    proj.set("tool", "opensta", "task", "timing", "var", "target", target)
    proj.set("tool", "opensta", "task", "timing", "var", "liberty", liberty)
    proj.set("tool", "opensta", "task", "timing", "var", "sdc", sdc)

    result = proj.run()
    return {m: result.get("metric", m, step=step, index=_INDEX)
            for m, step in ASIC_METRIC_STEP.items()}


def read_asic_metrics(name, builddir="build", jobname="job0"):
    """Read ASIC-flow metrics from a prior run's manifest (no synthesis)."""
    return _read_manifest_metrics(name, builddir, jobname, ASIC_METRIC_STEP)


def run_one(group, item, flow="fpga", builddir="build", pdk="nangate45", quiet=True):
    """Run a single benchmark (by group + class name); return a result tuple.

    Returns (group, item, metrics, error). Catches errors and returns them so a
    pool worker never crashes the parent. Defined at module level so it is
    picklable for ProcessPoolExecutor (the job-level parallelism in lb).
    """
    import logikbench
    design = getattr(getattr(logikbench, group), item)()
    # remove the prior job directory so SiliconCompiler always runs fresh
    # (avoids SC's incremental build reuse)
    shutil.rmtree(os.path.join(builddir, item.lower()), ignore_errors=True)
    try:
        if flow == "asic":
            metrics = run_asic_design(design, builddir=builddir, pdk=pdk, quiet=quiet)
        else:
            metrics = run_design(design, builddir=builddir, quiet=quiet)
        return (group, item, metrics, None)
    except Exception as e:  # noqa: BLE001 - report to parent, keep the sweep going
        return (group, item, None, str(e))
