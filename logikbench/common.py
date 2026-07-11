"""Shared SiliconCompiler plumbing for LogikBench benchmark runs.

Flow-agnostic helpers used by both the FPGA and ASIC run paths: metric-name
lists, the friendly stage-name -> SC-node maps, project setup, and the
manifest readers that recover metrics/settings from a completed job.
"""

import hashlib
import json
import logging
import os
import shutil

from siliconcompiler import Project
from siliconcompiler.schema import EditableSchema

# SC-standard metric names tracked per run mode.
FPGA_METRICS = ["luts", "logicdepth", "tasktime"]
ASIC_METRICS = ["cells", "cellarea", "fmax", "tasktime"]
# sim (`lb sim`): pass/fail status + SC's 'tasktime' recorded at each of the
# two nodes (compile, simulate)
SIM_METRICS = ["status", "tasktime"]
# lint (`lb lint`): static-analysis error/warning counts
LINT_METRICS = ["errors", "warnings"]


# --- Netlist cache ---------------------------------------------------------
# `lb syn` produces a mapped gate netlist; the back-end verbs (pnr, sta, lec,
# power) start from it rather than re-synthesizing. The netlist is cached under
# <builddir>/netlists/<token>/<group>/<name>.vg (the token, e.g.
# 'yosys_freepdk45', encodes tool+PDK so yosys/tardigrade netlists never
# collide; <group> namespaces the benchmark name, which is only unique within
# its group), with a '<name>.key' sidecar hashing the RTL contents so a stale
# netlist (RTL edited since synthesis) is detected. Cache miss/stale -> the
# consumer errors with a 'run lb syn first' hint (no hidden re-synthesis).

def netlist_cache_path(builddir, token, group, name):
    """Cache path for a benchmark's synthesized netlist under a synth token."""
    return os.path.join(builddir, "netlists", token, group, f"{name}.vg")


def netlist_key(design):
    """Content hash identifying a benchmark's RTL (its 'rtl' fileset file
    contents), used to detect a cached netlist gone stale after an RTL edit."""
    h = hashlib.sha256()
    for f in sorted(str(x) for x in (design.get_file(fileset="rtl") or [])):
        h.update(b"\n" + os.path.basename(f).encode() + b"\n")
        try:
            with open(f, "rb") as fh:
                h.update(fh.read())
        except OSError:
            pass
    return h.hexdigest()


def write_netlist_cache(builddir, token, group, name, src_vg, design):
    """Copy a freshly synthesized netlist into the cache and write its key."""
    dst = netlist_cache_path(builddir, token, group, name)
    os.makedirs(os.path.dirname(dst), exist_ok=True)
    shutil.copyfile(src_vg, dst)
    with open(dst[:-len(".vg")] + ".key", "w") as f:
        f.write(netlist_key(design))
    return dst


def read_netlist_cache(builddir, token, group, name, design):
    """Return the cached netlist path if present and current, else None (a miss
    or a stale netlist whose RTL changed since synthesis)."""
    vg = netlist_cache_path(builddir, token, group, name)
    keyf = vg[:-len(".vg")] + ".key"
    if not (os.path.isfile(vg) and os.path.isfile(keyf)):
        return None
    with open(keyf) as f:
        if f.read().strip() != netlist_key(design):
            return None
    return vg


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
        # Silence SC's per-node log echo (it dumps the whole failing tool log
        # at ERROR level). For mass runs we want exactly one greppable line per
        # benchmark -- lb's own '[N/M] Error synthesizing ...' print -- so lift
        # the SC logger above ERROR. Details remain in each job's job.log.
        proj.logger.setLevel(logging.CRITICAL)


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


def read_sim_metrics(name, builddir="build", jobname="job0"):
    """Read `lb sim` metrics from a completed job (no re-simulation).

    'status' is the self-checking testbench verdict, scraped from each simulate
    node's log (the testbench prints PASSED/FAILED): 'fail' if any replica
    failed, 'unknown' if any printed no verdict, else 'pass'. 'tasktime' is SC's
    per-node runtime, reported for both the 'compile' and 'simulate' nodes.
    Returns {"status": ..., "tasktime": {node: seconds}} or None if the job did
    not run.
    """
    jobdir = os.path.join(builddir, name, jobname)
    manifest = os.path.join(jobdir, f"{name}.pkg.json")
    if not os.path.isfile(manifest):
        return None
    with open(manifest) as f:
        data = json.load(f)

    def node_tasktime(step):
        recs = data.get("metric", {}).get("tasktime", {}).get(
            "node", {}).get(step, {})
        for rec in recs.values():
            if rec.get("value") is not None:
                return rec.get("value")
        return None

    # status: scan each simulate replica's log for the testbench verdict
    verdicts = []
    simdir = os.path.join(jobdir, "simulate")
    if os.path.isdir(simdir):
        for idx in sorted(os.listdir(simdir)):
            log = os.path.join(simdir, idx, "simulate.log")
            if not os.path.isfile(log):
                continue
            with open(log, errors="replace") as f:
                text = f.read()
            if "FAILED" in text:
                verdicts.append("fail")
            elif "PASSED" in text:
                verdicts.append("pass")
            else:
                verdicts.append("unknown")
    if not verdicts:
        status = None
    elif "fail" in verdicts:
        status = "fail"
    elif "unknown" in verdicts:
        status = "unknown"
    else:
        status = "pass"

    return {"status": status,
            "tasktime": {"compile": node_tasktime("compile"),
                         "simulate": node_tasktime("simulate")}}


def read_lint_metrics(name, builddir="build", jobname="job0"):
    """Read `lb lint` metrics (static-analysis error/warning counts) from a
    completed job's manifest. Returns {metric: value} or None."""
    return read_metrics(name, LINT_METRICS, builddir, jobname)


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


def _first_node_value(nodes):
    """First non-None 'value' in a pernode dict {step: {index: {'value':...}}}."""
    for idxs in nodes.values():
        if not isinstance(idxs, dict):
            continue
        for rec in idxs.values():
            if isinstance(rec, dict) and rec.get("value") is not None:
                return rec["value"]
    return None


def read_flow_tools(name, builddir="build", jobname="job0"):
    """Return ({tool: version}, scversion) for the tools the flow actually ran,
    recovered from a benchmark's manifest. Only the steps that ran (recorded
    tool versions) are considered, and each step's tool name is looked up in the
    flow that ran -- so the result lists exactly the tools this target used, with
    no hard-coded tool list. Returns ({}, None) if the manifest is absent.
    """
    manifest = os.path.join(builddir, name, jobname, f"{name}.pkg.json")
    if not os.path.isfile(manifest):
        return {}, None
    with open(manifest) as f:
        data = json.load(f)

    flow = _first_node_value(data.get("option", {}).get("flow", {}).get("node", {}))
    fg = data.get("flowgraph", {}).get(flow, {})
    rec = data.get("record", {})

    tools = {}
    for step, idxs in rec.get("toolversion", {}).get("node", {}).items():
        if step == "default":
            continue
        for idx, r in idxs.items():
            ver = r.get("value")
            if ver is None:
                continue
            toolnode = (fg.get(step, {}).get(idx, {})
                        .get("tool", {}).get("node", {}))
            tool = _first_node_value(toolnode)
            if tool:
                tools[tool] = ver

    scversion = _first_node_value(rec.get("scversion", {}).get("node", {}))
    return tools, scversion


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


def clean_build(name, builddir="build", jobname="job0"):
    """Delete a benchmark's synthesis artifacts, keeping only the manifest.

    --resume and the metric readers read a single file per benchmark -- the job
    manifest '<builddir>/<name>/<jobname>/<name>.pkg.json'. Everything else in
    the build tree (synthesis logs, netlists, reports, tool working dirs) is
    disposable and is what fills the disk (multi-GB logs on large designs). This
    removes all of it and prunes the now-empty directories, leaving just the
    manifest so a later collect (and skip-completed --resume) still works.

    No-op when the manifest is absent (nothing built, or already cleaned). Note
    that removing the intermediate node outputs makes a later mid-flow '--from'
    resume impossible for this benchmark; skip-completed '--resume' is fine.
    """
    benchdir = os.path.join(builddir, name)
    manifest = os.path.join(benchdir, jobname, f"{name}.pkg.json")
    if not os.path.isfile(manifest):
        return
    keep = os.path.abspath(manifest)
    # bottom-up so a directory is visited after its contents are removed
    for root, dirs, files in os.walk(benchdir, topdown=False):
        for fname in files:
            path = os.path.join(root, fname)
            if os.path.abspath(path) != keep:
                os.remove(path)
        for dname in dirs:
            dpath = os.path.join(root, dname)
            if not os.listdir(dpath):
                os.rmdir(dpath)
