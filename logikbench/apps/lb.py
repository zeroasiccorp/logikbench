#!/usr/bin/env python3

import argparse
import glob
import math
import os
import sys
import json
import threading
from collections import defaultdict

import psutil

import logikbench as lb
from concurrent.futures import (
    ProcessPoolExecutor, as_completed, wait, FIRST_COMPLETED)

from logikbench.runner import (
    FPGA_METRICS, ASIC_METRICS, FPGA_TARGETS,
    YOSYS_TARGETS, STEPS, run_one, run_task,
    read_metrics, read_asic_metrics, read_tool_var, read_flow_tools,
    read_metric_units, is_complete, clean_build, write_netlist_cache,
)

# results file layout version (bump when the JSON structure changes)
SCHEMA_VERSION = 1

# benchmark groups available to both subcommands
ALL_GROUPS = ['basic', 'memory', 'arithmetic', 'epfl', 'blocks', 'large',
              'iscas85', 'iscas89', 'koios']

# metrics tracked are determined by the run mode (fpga vs asic synthesis)
FLOW_METRICS = {'fpga': FPGA_METRICS, 'asic': ASIC_METRICS}

# Metrics whose raw SC unit reads badly at human scale are rescaled at collection
# time: metric -> (multiply raw value by, unit label recorded in meta['units']).
# fmax is Hz (a 4 GHz design prints as 4e9) and memory is bytes; everything else
# is already at a human scale (um^2, mw, ns, s) and stays in its raw SC unit.
METRIC_DISPLAY = {
    "fmax":   (1e-6, "MHz"),   # Hz -> MHz
    "memory": (1e-6, "MB"),    # B  -> MB (decimal, 1e6 bytes)
}
# significant figures kept for float metrics (strips IEEE-754 print noise like
# 4.461479999999998 -> 4.461); integer counts (cells, logicdepth) pass through.
METRIC_SIGFIGS = 4
# metrics rounded to a fixed number of decimal places instead of sig figs
# (tasktime s, cellarea um^2, fmax MHz read better as fixed 0.xx numbers).
METRIC_DECIMALS = {"tasktime": 2, "cellarea": 2, "fmax": 2}


def round_sig(value, sig=METRIC_SIGFIGS):
    """Round a float to `sig` significant figures. Non-floats and 0 pass through
    unchanged, so integer counts stay integers and there is no log10(0)."""
    if not isinstance(value, float) or value == 0:
        return value
    return round(value, sig - 1 - math.floor(math.log10(abs(value))))


def round_metric(metric, value):
    """Round a metric value for display: fixed decimals for the metrics in
    METRIC_DECIMALS, else sig figs. Non-floats (counts) pass through."""
    if not isinstance(value, float):
        return value
    decimals = METRIC_DECIMALS.get(metric)
    if decimals is not None:
        return round(value, decimals)
    return round_sig(value)


def present_value(metric, value):
    """Turn a raw SC metric value into the human-readable form stored in the
    results JSON: apply METRIC_DISPLAY scaling (e.g. fmax Hz->MHz), then round
    it (see round_metric)."""
    if value is None:
        return None
    scale = METRIC_DISPLAY.get(metric)
    if scale is not None:
        value = value * scale[0]
    return round_metric(metric, value)


# `lb syn --target`: PDK stems (ASIC lbflow) + FPGA parts. --tool picks the ASIC
# mapper; the runner token is '<tool>_<pdk>' (FPGA parts run as-is, yosys only).
_SYN_PDKS = sorted({t.split('_', 1)[1] for t in YOSYS_TARGETS})
_SYN_TOOL_PREFIX = {'yosys': 'yosys', 'tardigrade': 'tardigrade'}


class LbHelpFormatter(argparse.HelpFormatter):
    """Help formatter that keeps pre-wrapped (multi-line) help strings verbatim
    while still auto-wrapping plain single-line ones, and puts a blank line
    between arguments so long entries stay readable."""

    def _split_lines(self, text, width):
        # a help string with explicit newlines is already laid out by hand
        # (e.g. the --target format/choices block): keep it as authored.
        if "\n" in text:
            return text.splitlines()
        return super()._split_lines(text, width)

    def _format_action(self, action):
        return super()._format_action(action) + "\n"


def run_label(value):
    """argparse type for --label: a short variant tag suffixed onto the build
    dir and result filename. Restricted to letters/digits so it stays a clean
    path/filename component (the '_' is reserved as the target/label separator).
    """
    if value and value.isalnum():
        return value
    raise argparse.ArgumentTypeError(
        f"{value!r} is not a valid label: use letters/digits only "
        "(e.g. 'optdelay')")


def flow_step(value):
    """argparse type for --from/--to: a friendly stage name (STEPS, mapped to
    the stage's first/last node) or a raw SC node 'step' / 'step.task' passed
    through verbatim (e.g. 'floorplan.init' to stop at the first floorplan node).
    """
    if value in STEPS:
        return value
    # raw SC node: 'step' or 'step.task', each part a simple identifier
    parts = value.split(".")
    if 1 <= len(parts) <= 2 and all(p.isidentifier() for p in parts):
        return value
    raise argparse.ArgumentTypeError(
        f"{value!r} is not a flow step: use a stage name {STEPS} or a raw SC "
        f"node 'step'/'step.task' (e.g. 'floorplan.init')")


def target_mode(target):
    """'fpga' for an FPGA target, 'asic' for a PDK/demo target."""
    return 'fpga' if target in FPGA_TARGETS else 'asic'


def result_stem(target, label=None):
    """Filename stem for a target's collected/published metrics. ASIC runner
    tokens already carry the tool ('yosys_asap7', 'sc_sky130'); FPGA part tokens
    ('virtex7') are yosys-only, so prefix them for a uniform '<tool>_<target>'.
    A --label variant is suffixed as '<stem>_<label>' so it stays distinct."""
    stem = f"yosys_{target}" if target in FPGA_TARGETS else target
    return f"{stem}_{label}" if label else stem


def target_builddir(args, target):
    """Per-target build tree: <builddir>/<target>/<benchmark>/... A --label
    variant gets its own tree (<builddir>/<target>_<label>/...) so it never
    shares (or resumes from) the default run's artifacts."""
    label = getattr(args, "label", None)
    stem = f"{target}_{label}" if label else target
    return os.path.join(args.builddir, stem)


def make_worklist(args):
    """(group, design-class, design-name) triples honoring the group/name filters.

    Shared across targets (the benchmark set is the same for every target). The
    class is resolved here (the app owns benchmark discovery) and passed on to
    run_one, so the runner never reflects over the package. The design name is
    the SC name (e.g. 'arbiter'), bare and unique only within its group -- the
    (group, name) pair keys the per-group build dir, metrics, and -n filter.
    """
    namefilter = set(n.lower() for n in args.name) if args.name else None
    skipfilter = set(n.lower() for n in getattr(args, "skip", None) or [])
    worklist = []
    for group in args.group:
        module = getattr(lb, group)
        for item in module.__all__:
            cls = getattr(module, item)
            name = cls().name
            if name in skipfilter:            # --skip wins over -n/-g
                continue
            if namefilter is None or name in namefilter:
                worklist.append((group, cls, name))
    return worklist


def check_worklist(args, worklist):
    """Fail loudly (exit 2) when the selection resolves to no benchmarks, so a
    run/collect never silently does nothing. -n searches all groups (names are
    globally unique), so an unmatched name is simply not a known benchmark.
    """
    skip = getattr(args, "skip", None)
    if skip:
        # a typo'd --skip name would silently exclude nothing (the long job
        # then runs anyway), so validate against the selected groups' names.
        known = {getattr(mod, item)().name
                 for group in args.group
                 for mod in (getattr(lb, group),)
                 for item in mod.__all__}
        unknown = [n for n in skip if n.lower() not in known]
        if unknown:
            print("error: --skip: not a known benchmark: "
                  f"{', '.join(unknown)}", file=sys.stderr)
            sys.exit(2)
    if args.name:
        groups_by_name = defaultdict(set)
        for g, _, nm in worklist:
            groups_by_name[nm].add(g)
        unmatched = [n for n in args.name if n.lower() not in groups_by_name]
        if unmatched:
            print("error: not a known benchmark: "
                  f"{', '.join(unmatched)}", file=sys.stderr)
            sys.exit(2)
        # a bare name found in more than one selected group is ambiguous
        ambiguous = [(n.lower(), groups_by_name[n.lower()]) for n in args.name
                     if len(groups_by_name[n.lower()]) > 1]
        if ambiguous:
            for nm, gs in ambiguous:
                print(f"error: benchmark '{nm}' exists in multiple groups "
                      f"({', '.join(sorted(gs))}); narrow with -g",
                      file=sys.stderr)
            sys.exit(2)
    if not worklist:
        print("error: no benchmarks selected for group(s): "
              f"{', '.join(args.group)}", file=sys.stderr)
        sys.exit(2)


def target_runlist(target, args, worklist):
    """Worklist triples to synthesize for a target, applying --resume
    (skip benchmarks whose build already completed successfully)."""
    if not args.resume:
        return list(worklist)
    builddir = target_builddir(args, target)
    runlist = []
    for group, cls, name in worklist:
        gdir = os.path.join(builddir, group)
        if is_complete(name, gdir):
            loc = os.path.join(".", gdir, name)
            print(f"Skipping {name} ({loc}): already complete.")
        else:
            runlist.append((group, cls, name))
    return runlist


def _load_estimates(targets):
    """Historical per-(target, group, name) runtime and peak-memory estimates
    from the committed results (metrics 'tasktime' in seconds, 'memory' in MB),
    for longest-first ordering and memory-aware admission. Returns (runtime_est,
    memory_est, have_runtime): the two callables take (target, group, name);
    runtime_est falls back to the per-benchmark median across targets (0 if
    unseen), memory_est to the per-benchmark max (None if unseen, so the caller
    treats it conservatively). have_runtime is False when no tasktime data
    exists at all, so the caller leaves ordering unchanged."""
    tree = find_results_tree()
    runtime, memory = {}, {}
    rt_peers, mem_peers = defaultdict(list), defaultdict(list)
    for target in set(targets):
        if not tree:
            break
        path = os.path.join(tree, "syn", target_mode(target),
                            f"{result_stem(target)}.json")
        if not os.path.isfile(path):
            continue
        try:
            with open(path) as f:
                metrics = json.load(f).get("metrics", {})
        except (ValueError, OSError):
            continue
        for metric, store, peers in (("tasktime", runtime, rt_peers),
                                     ("memory", memory, mem_peers)):
            for group, names in metrics.get(metric, {}).items():
                if not isinstance(names, dict):
                    continue
                for name, val in names.items():
                    if isinstance(val, (int, float)):
                        store[(target, group, name)] = val
                        peers[(group, name)].append(val)

    def _median(vals):
        return sorted(vals)[len(vals) // 2]

    def runtime_est(target, group, name):
        val = runtime.get((target, group, name))
        if val is not None:
            return val
        peer = rt_peers.get((group, name))
        return _median(peer) if peer else 0.0

    def memory_est(target, group, name):
        val = memory.get((target, group, name))
        if val is not None:
            return val
        peer = mem_peers.get((group, name))
        return max(peer) if peer else None

    return runtime_est, memory_est, bool(runtime)


def _memory_watchdog(stop_event, floor_bytes, interval=5.0):
    """Background monitor for a parallel sweep: every 'interval' seconds check
    total SYSTEM available memory (via psutil, so it accounts for every process
    on the machine -- other apps and leaked/orphaned tool processes from prior
    runs, not just this sweep's own children) and print a WARNING when it drops
    below 'floor_bytes', the regime where the machine starts thrashing swap or
    OOM-kills a synth job. Warns once per crossing and re-arms only after
    available climbs back above 2x the floor, so it never spams. Runs as a
    daemon thread and exits when stop_event is set."""
    armed = True
    while not stop_event.wait(interval):
        vm = psutil.virtual_memory()
        if vm.available < floor_bytes and armed:
            sw = psutil.swap_memory()
            print(f"WARNING: only ~{vm.available / 2**30:.1f}GB RAM free "
                  f"(swap {sw.percent:.0f}% used); the system may thrash or "
                  "OOM-kill a job. Reduce -j, set --mem, or check for leaked "
                  "processes (e.g. stray 'sta'/'yosys').", file=sys.stderr)
            armed = False
        elif vm.available > 2 * floor_bytes:
            armed = True         # re-arm once memory pressure recedes


def run_sweep(args, targets, worklist, netlist_cache=False):
    """Synthesize the whole target x benchmark matrix; return the failures.

    Each (target, benchmark) is an independent SC run, so -j fans them out over
    a single process pool across the entire matrix -- it speeds up sweeps that
    are wide in benchmarks, wide in targets, or both. Pure build: metrics are
    not read or written here (use 'collect' afterwards).
    """
    # flat task list over all targets and their (post-resume-filter) benchmarks
    tasks = [(target, group, cls, name)
             for target in targets
             for group, cls, name in target_runlist(target, args, worklist)]

    # Longest-processing-time-first: submit the slowest benchmarks earliest so a
    # long job never becomes an end straggler running alone while workers idle.
    # No-op (current order preserved) when there is no historical runtime data.
    runtime_est, memory_est, have_runtime = _load_estimates(targets)
    if have_runtime:
        tasks.sort(key=lambda t: runtime_est(t[0], t[1], t[3]), reverse=True)
    # --mem: cap concurrency so summed historical peak memory (MB) of running
    # jobs stays under budget, on top of -j. Unset -> pure -j behavior.
    budget_mb = args.mem * 1024 if getattr(args, "mem", None) else None

    timeout = args.timeout or None   # --timeout 0 disables the cap
    quiet = not args.verbose
    # --from/--to only exist on subcommands that expose them (run, and later
    # pnr); other target tasks (syn) omit them and run the whole flow.
    start = getattr(args, "start", None)
    stop = getattr(args, "stop", None)
    lintonly = getattr(args, "lintonly", False)  # syn has it; pnr does not
    options = getattr(args, "options", "")       # syn has it; pnr does not
    failures = []
    total = len(tasks)
    done = 0  # completed-job counter; printed as [done/total] progress
    cls_by_name = {(group, name): cls for _, group, cls, name in tasks}

    # Same completion message for every job, regardless of target (FPGA or
    # ASIC) or scheduling (-j sequential vs parallel).
    def record(target, group, name, error):
        nonlocal done
        done += 1
        prefix = f"[{done}/{total}]"
        # per-benchmark build dir is namespaced by group (bare names are only
        # unique within a group): ./<builddir>/<target>/<group>/<name>
        gdir = os.path.join(target_builddir(args, target), group)
        loc = os.path.join(".", gdir, name)
        if error is not None:
            print(f"{prefix} Error synthesizing {name} ({loc}): "
                  f"{error}", file=sys.stderr)
            failures.append(f"{target}/{group}/{name}")
        else:
            print(f"{prefix} Finished {name} benchmark ({loc}).")
            # cache the mapped netlist (ASIC syn only) so the back-end verbs
            # (pnr/sta/lec) start from it instead of re-synthesizing
            if netlist_cache and target_mode(target) == "asic":
                # the synthesis output netlist is named after the top module,
                # which no longer always equals the (bare) design name, so glob
                # the single .vg rather than assuming '<name>.vg'.
                odir = os.path.join(gdir, name, "job0", "synthesis", "0",
                                    "outputs")
                vgs = glob.glob(os.path.join(odir, "*.vg"))
                if vgs:
                    write_netlist_cache(args.builddir, target, group, name,
                                        vgs[0], cls_by_name[(group, name)]())
        # By default reclaim disk as we go (pass or fail), keeping only the
        # manifest --resume needs; --keep retains everything. Runs
        # in the parent for both the sequential and -j parallel paths, so
        # benchmarks never race on it.
        if not args.keep:
            clean_build(name, builddir=gdir)

    if args.jobs > 1:
        # Watch system available memory and warn when it drops near empty;
        # a daemon thread so it never blocks sweep teardown. Floor: 10% of
        # installed RAM, but at least 2GB.
        stop_event = threading.Event()
        floor = max(2 * 2**30, int(0.10 * psutil.virtual_memory().total))
        watcher = threading.Thread(
            target=_memory_watchdog, daemon=True, args=(stop_event, floor))
        watcher.start()
        try:
            with ProcessPoolExecutor(max_workers=args.jobs) as pool:
                running = {}      # future -> (target, group, name, est_mem_mb)
                running_mem = 0.0
                idx = 0
                while idx < len(tasks) or running:
                    # admit tasks (longest-first) up to the worker count and the
                    # memory budget; a lone over-budget job runs anyway.
                    while idx < len(tasks) and len(running) < args.jobs:
                        target, group, cls, name = tasks[idx]
                        est = memory_est(target, group, name)
                        if budget_mb is not None and est is None:
                            est = budget_mb    # unknown footprint -> run alone
                        est = est or 0.0
                        if (budget_mb is not None and running
                                and running_mem + est > budget_mb):
                            break              # wait for memory to free up
                        if (budget_mb is not None and not running
                                and est > budget_mb):
                            print(f"warning: {target}/{group}/{name} needs "
                                  f"~{est / 1024:.1f}GB > --mem {args.mem}GB; "
                                  "running it alone", file=sys.stderr)
                        future = pool.submit(
                            run_one, cls, target, group, options,
                            target_builddir(args, target), quiet,
                            start, stop, timeout, args.clk, lintonly)
                        running[future] = (target, group, name, est)
                        running_mem += est
                        idx += 1
                    finished, _ = wait(running, return_when=FIRST_COMPLETED)
                    for future in finished:
                        target, group, name, est = running.pop(future)
                        running_mem -= est
                        _, error = future.result()
                        record(target, group, name, error)
        finally:
            stop_event.set()      # tell the watchdog to exit
            watcher.join(timeout=2)
    else:
        for target, group, cls, name in tasks:
            builddir = target_builddir(args, target)
            _, error = run_one(cls, target, group, options,
                               builddir, quiet, start, stop,
                               timeout, args.clk, lintonly)
            record(target, group, name, error)

    return failures


def gather_target_metrics(target, args, worklist):
    """Read the {metric: {benchmark: value}} matrix for one target from its build
    tree, plus the synthesis 'options' the run used. Returns (metrics_out,
    options, collected_count). No files are written.
    """
    mode = target_mode(target)
    builddir = target_builddir(args, target)
    metric_names = FLOW_METRICS[mode]

    # metrics are nested by group (metrics[<metric>][<group>][<name>]) because a
    # bare benchmark name is only unique within its group.
    metrics_out = {metric: {} for metric in metric_names}
    options = None
    for group, cls, name in worklist:
        gdir = os.path.join(builddir, group)
        if mode == 'asic':
            metrics = read_asic_metrics(name, builddir=gdir)
        else:
            metrics = read_metrics(name, FPGA_METRICS, builddir=gdir)
        if metrics is None:
            if args.name is not None:
                # only warn about benchmarks the user explicitly named
                print(f"No results for {name} benchmark ({group}).")
            continue
        for metric in metric_names:
            # rescale to a human unit (fmax->MHz, memory->MB) and round off
            # float print-noise before storing; see present_value/METRIC_DISPLAY
            value = present_value(metric, metrics.get(metric))
            metrics_out[metric].setdefault(group, {})[name] = value
        # options are uniform across a target's sweep; read once from a built one
        if options is None:
            options = read_tool_var(name, "yosys", "synthesis", "options",
                                    builddir=gdir)

    collected = set()
    for col in metrics_out.values():
        for gname, names in col.items():
            collected.update((gname, n) for n in names)
    return metrics_out, options, len(collected)


def results_builddir(args):
    """Directory the run writes per-target metrics into: <builddir>/results."""
    return os.path.join(args.builddir, "results")


def find_results_tree():
    """Locate the committed 'results' tree by searching up from the CWD for a
    git checkout that contains it. Returns the path, or None when not run from a
    clone (e.g. a PyPI install), where that tree does not exist."""
    here = os.path.abspath(os.getcwd())
    while True:
        if (os.path.isdir(os.path.join(here, ".git"))
                and os.path.isdir(os.path.join(here, "results"))):
            return os.path.join(here, "results")
        parent = os.path.dirname(here)
        if parent == here:
            return None
        here = parent


def should_publish(args):
    """Whether to promote results into the committed 'results' tree.

    An explicit --publish/--no-publish always wins. When neither is given
    (args.publish is None) we autodetect: publish when run from a git clone that
    has the tree, and skip on a PyPI install where that tree does not exist.
    """
    if args.publish is not None:
        return args.publish
    return find_results_tree() is not None


def _merge_metrics_into(src_path, dst_path):
    """Incrementally merge one <target>.json into another: benchmark values in
    src update dst per metric; benchmarks/metrics only in dst are preserved.
    Meta/provenance is refreshed from src."""
    with open(src_path) as f:
        src = json.load(f)
    dst = {}
    if os.path.isfile(dst_path):
        try:
            with open(dst_path) as f:
                dst = json.load(f)
        except (ValueError, OSError):
            dst = {}
    metrics = dst.get("metrics", {})
    for metric, groups in src.get("metrics", {}).items():
        dstm = metrics.setdefault(metric, {})
        for grp, names in groups.items():
            dstm.setdefault(grp, {}).update(names)
    payload = {"meta": src.get("meta", dst.get("meta", {})), "metrics": metrics}
    with open(dst_path, "w") as f:
        json.dump(payload, f, indent=2, sort_keys=True)


def save_target(target, args, worklist):
    """Write one target's metrics as <builddir>/results/<target>.json and print
    the path. Metrics always land in the build directory; use 'run --publish' to
    promote them into the committed results tree."""
    metrics_out, options, collected = gather_target_metrics(target, args,
                                                            worklist)
    outdir = results_builddir(args)
    os.makedirs(outdir, exist_ok=True)
    label = getattr(args, "label", None)
    output = os.path.join(outdir, f"{result_stem(target, label)}.json")

    # incremental read-modify-write: update only the benchmarks in this run and
    # preserve metrics already recorded for others (so a subset run/publish does
    # not clobber the rest of the target's results).
    payload = {}
    if os.path.isfile(output):
        try:
            with open(output) as f:
                payload = json.load(f)
        except (ValueError, OSError):
            payload = {}
    # deep merge by group: metrics[<metric>][<group>][<name>], preserving names
    # from prior runs that this run did not touch.
    metrics = payload.get("metrics", {})
    for metric, groups in metrics_out.items():
        dst = metrics.setdefault(metric, {})
        for grp, names in groups.items():
            dst.setdefault(grp, {}).update(names)

    # provenance: what produced these numbers (git versions the rest). Tools are
    # discovered from the flow the target ran; refreshed each run. The per-metric
    # units come from SC's metric schema in the same benchmark's manifest, so
    # values in 'metrics' stay raw and self-describing via meta['units'].
    tools, scversion, units = {}, None, {}
    tbd = target_builddir(args, target)
    metric_names = FLOW_METRICS[target_mode(target)]
    for grp, _, nm in worklist:
        gdir = os.path.join(tbd, grp)
        tools, scversion = read_flow_tools(nm, builddir=gdir)
        if tools or scversion:
            units = read_metric_units(nm, metric_names, builddir=gdir) or {}
            break
    # record the display unit for any metric we rescaled (e.g. fmax Hz->MHz),
    # so meta['units'] stays authoritative for the values written above.
    for metric, (_, unit) in METRIC_DISPLAY.items():
        if metric in units:
            units[metric] = unit
    meta = payload.get("meta", {})
    meta["schema_version"] = SCHEMA_VERSION
    meta["target"] = target
    if label:
        meta["label"] = label
    if options is not None:
        meta["options"] = options
    meta["logikbench"] = getattr(lb, "__version__", None)
    if scversion is not None:
        meta["siliconcompiler"] = scversion
    if tools:
        meta["tools"] = tools
    if units:
        meta["units"] = units

    payload = {"meta": meta, "metrics": metrics}
    with open(output, "w") as f:
        json.dump(payload, f, indent=2, sort_keys=True)
    print(f"Collected {collected}/{len(worklist)} benchmark(s) -> {output}")
    return collected


def add_selection_args(parser):
    """Benchmark selection + build plumbing shared by every task subcommand.
    No --target: RTL-only tasks (sim/lint) take none; target tasks add it."""
    parser.add_argument("-g", "--group", nargs='+', choices=ALL_GROUPS,
                        default=ALL_GROUPS, metavar="GROUP",
                        help=f"Benchmark group(s) (default: all: {ALL_GROUPS}). "
                             "Also narrows -n when a bare name lives in several "
                             "groups")
    parser.add_argument("-n", "--name", nargs='+',
                        help="Specific benchmark(s) by bare name, looked up "
                             "within the selected group(s); a name found in more "
                             "than one group requires -g to disambiguate")
    parser.add_argument("--skip", nargs='+', metavar="NAME",
                        help="Benchmark(s) to exclude by bare name (applied "
                             "after -g/-n). Skip long-pole benchmarks here and "
                             "run them separately with -n.")
    parser.add_argument('-b', dest='builddir', default="build", metavar="DIR",
                        help="Build directory root (default: build)")
    parser.add_argument('-j', dest='jobs', type=int, default=1, metavar="N",
                        help="Benchmarks to run in parallel (default: 1)")
    parser.add_argument('--mem', type=float, default=None, metavar="GB",
                        help="Memory budget in GB: throttle concurrency so the "
                             "summed historical peak memory of running "
                             "benchmarks stays under this, on top of -j "
                             "(default: bounded by -j only)")
    parser.add_argument('--timeout', type=float, default=7200, metavar="SEC",
                        help="Per-step wall-clock cap in seconds "
                             "(default: 7200; 0 disables)")
    parser.add_argument('--publish', action=argparse.BooleanOptionalAction,
                        default=None,
                        help="Merge results into the committed ./results tree. "
                             "Default: autodetect -- on when run from a git "
                             "clone, off on a PyPI install. Use --no-publish to "
                             "keep results in the build tree only.")
    parser.add_argument('-v', '--verbose', action='store_true',
                        help="Show full tool logs (quieted by default)")
    parser.add_argument('--resume', action='store_true',
                        help="Skip benchmarks whose build already completed")
    parser.add_argument('--keep', action='store_true',
                        help="Keep full per-benchmark artifacts (default: "
                             "reclaim as each finishes)")


def save_task(task, args, results):
    """Write an RTL-only task's results to <builddir>/results/<task>.json as a
    per-benchmark record {name: metrics}, incrementally (a subset run updates
    only those benchmarks and preserves the rest). Prints the path."""
    outdir = results_builddir(args)
    os.makedirs(outdir, exist_ok=True)
    out = os.path.join(outdir, f"{task}.json")
    payload = {}
    if os.path.isfile(out):
        try:
            with open(out) as f:
                payload = json.load(f)
        except (ValueError, OSError):
            payload = {}
    # benchmarks nested by group ({group: {name: metrics}}); deep-merge so a
    # subset run updates only its benchmarks and preserves the rest.
    bench = payload.get("benchmarks", {})
    for group, names in results.items():
        bench.setdefault(group, {}).update(names)
    payload = {"meta": {"task": task, "schema_version": SCHEMA_VERSION,
                        "logikbench": getattr(lb, "__version__", None)},
               "benchmarks": bench}
    with open(out, "w") as f:
        json.dump(payload, f, indent=2, sort_keys=True)
    n = sum(len(v) for v in results.values())
    print(f"Wrote {n} benchmark(s) -> {out}")


def publish_task(task, args):
    """Merge an RTL-only task's build results into the committed
    results/<task>/<task>.json, incrementally. Dev-only: requires a git clone."""
    tree = find_results_tree()
    if tree is None:
        sys.exit("--publish requires a git clone of the logikbench repo "
                 "(the committed 'results' tree only exists there).")
    src = os.path.join(results_builddir(args), f"{task}.json")
    if not os.path.isfile(src):
        print(f"--publish: no build results at {src}", file=sys.stderr)
        return
    dstdir = os.path.join(tree, task)
    os.makedirs(dstdir, exist_ok=True)
    dst = os.path.join(dstdir, f"{task}.json")
    with open(src) as f:
        src_data = json.load(f)
    dst_data = {}
    if os.path.isfile(dst):
        try:
            with open(dst) as f:
                dst_data = json.load(f)
        except (ValueError, OSError):
            dst_data = {}
    bench = dst_data.get("benchmarks", {})
    for group, names in src_data.get("benchmarks", {}).items():
        bench.setdefault(group, {}).update(names)
    payload = {"meta": src_data.get("meta", dst_data.get("meta", {})),
               "benchmarks": bench}
    with open(dst, "w") as f:
        json.dump(payload, f, indent=2, sort_keys=True)
    print(f"Published {task} -> {dst}")


def run_rtl_task(args):
    """Dispatch for the RTL-only task subcommands (sim, lint): run each selected
    benchmark through run_task, write results, optionally publish. Returns an
    exit code (nonzero if any benchmark failed)."""
    task = args.command
    worklist = make_worklist(args)
    check_worklist(args, worklist)
    timeout = args.timeout or None
    quiet = not args.verbose
    tasks = []
    for group, cls, name in worklist:
        gdir = os.path.join(args.builddir, group)
        if args.resume and is_complete(name, gdir):
            loc = os.path.join(".", gdir, name)
            print(f"Skipping {name} ({loc}): already complete.")
            continue
        tasks.append((group, cls, name))
    total = len(tasks)
    done = 0
    results = {}       # nested by group: {group: {name: metrics}}
    failures = []

    def record(group, name, metrics, error):
        nonlocal done
        done += 1
        prefix = f"[{done}/{total}]"
        loc = os.path.join(".", args.builddir, group, name)
        if error is not None:
            print(f"{prefix} Error ({task}) {name} ({loc}): {error}",
                  file=sys.stderr)
            failures.append(f"{group}/{name}")
        else:
            results.setdefault(group, {})[name] = metrics
            status = (metrics or {}).get("status")
            tag = f" [{status}]" if status else ""
            print(f"{prefix} Finished ({task}) {name} ({loc}){tag}.")

    if args.jobs and args.jobs > 1:
        with ProcessPoolExecutor(max_workers=args.jobs) as pool:
            futs = {pool.submit(run_task, task, cls, args.tool,
                                os.path.join(args.builddir, group),
                                quiet, timeout): (group, name)
                    for group, cls, name in tasks}
            for fut in as_completed(futs):
                m, e = fut.result()
                g, n = futs[fut]
                record(g, n, m, e)
    else:
        for group, cls, name in tasks:
            m, e = run_task(task, cls, args.tool,
                            os.path.join(args.builddir, group), quiet, timeout)
            record(group, name, m, e)

    save_task(task, args, results)
    if should_publish(args):
        publish_task(task, args)
    if failures:
        print(f"\n{len(failures)} benchmark(s) failed: {', '.join(failures)}")
        return 1
    return 0


def resolve_syn_tokens(args):
    """Map `lb syn --target <t> [--tool]` to the runner's '<tool>_<part>' tokens.
    FPGA parts run yosys synth_fpga (tool must be yosys); PDK stems run the ASIC
    lbflow with the chosen mapper (yosys|tardigrade). Exits on an invalid combo.
    """
    fpga_parts = list(FPGA_TARGETS)
    tokens = []
    for t in args.target:
        if t in fpga_parts:
            if args.tool != "yosys":
                sys.exit(f"error: --tool {args.tool} is ASIC-only; FPGA target "
                         f"'{t}' uses yosys")
            tokens.append(t)
        elif t in _SYN_PDKS:
            tokens.append(f"{_SYN_TOOL_PREFIX[args.tool]}_{t}")
        else:
            sys.exit(f"error: unknown --target '{t}' (PDKs: {_SYN_PDKS}; "
                     f"FPGA parts: {fpga_parts})")
    return tokens


def publish_target_task(task, tokens, args):
    """Publish a target task's metrics into results/<task>/<class>/<token>.json,
    incrementally. Dev-only: requires a git clone."""
    tree = find_results_tree()
    if tree is None:
        sys.exit("--publish requires a git clone of the logikbench repo "
                 "(the committed 'results' tree only exists there).")
    src_dir = results_builddir(args)
    label = getattr(args, "label", None)
    for tok in tokens:
        stem = result_stem(tok, label)
        src = os.path.join(src_dir, f"{stem}.json")
        if not os.path.isfile(src):
            print(f"--publish: no build metrics for '{tok}' at {src}, skipping",
                  file=sys.stderr)
            continue
        dstdir = os.path.join(tree, task, target_mode(tok))
        os.makedirs(dstdir, exist_ok=True)
        dst = os.path.join(dstdir, f"{stem}.json")
        _merge_metrics_into(src, dst)
        print(f"Published {tok} -> {dst}")


def run_target_task(task, tokens, args):
    """Shared dispatch for target task subcommands (syn, pnr): sweep the given
    runner tokens x benchmarks, write per-token metrics, optionally publish.
    Returns an exit code."""
    worklist = make_worklist(args)
    check_worklist(args, worklist)
    failures = run_sweep(args, tokens, worklist, netlist_cache=(task == "syn"))
    if not getattr(args, "lintonly", False):
        for tok in tokens:
            save_target(tok, args, worklist)
        if should_publish(args):
            publish_target_task(task, tokens, args)
    elif args.publish:
        print("--publish ignored: lint-only runs produce no metrics",
              file=sys.stderr)
    if failures:
        print(f"\n{len(failures)} benchmark(s) failed: {', '.join(failures)}")
        return 1
    return 0


def resolve_pnr_tokens(args):
    """Map `lb pnr --target <t>` to runner tokens. ASIC PDK stems run the SC
    asicflow (token 'sc_<pdk>', through route). FPGA place-and-route (Logik) is
    not wired yet -- it needs the optional 'logik'/'logiklib' packages."""
    fpga_parts = list(FPGA_TARGETS)
    tokens = []
    for t in args.target:
        if t in _SYN_PDKS:
            tokens.append(f"sc_{t}")
        elif t in fpga_parts:
            sys.exit(f"error: FPGA place-and-route for '{t}' is not wired yet "
                     "(needs the Logik flow: pip install logik logiklib)")
        else:
            sys.exit(f"error: unknown --target '{t}' (PDKs: {_SYN_PDKS})")
    return tokens


def resolve_sta_tokens(args):
    """Map `lb sta --target <pdk>` to 'sta_<pdk>' tokens (ASIC PDK stems only).
    STA runs OpenSTA on `lb syn`'s cached netlist."""
    tokens = []
    for t in args.target:
        if t in _SYN_PDKS:
            tokens.append(f"sta_{t}")
        else:
            sys.exit(f"error: unknown --target '{t}' (PDKs: {_SYN_PDKS})")
    return tokens


def main():

    #################################################
    # Commandline Interface
    #################################################

    parser = argparse.ArgumentParser(description="""\
LogikBench commandline runner.
""", formatter_class=argparse.RawDescriptionHelpFormatter)

    sub = parser.add_subparsers(dest="command", required=False,
                                metavar="{lint,sim,syn,pnr,sta}")

    # ---- lint: static-analyze benchmark RTL, RTL-only ----
    lint_p = sub.add_parser("lint", help="Lint benchmarks",
                            formatter_class=LbHelpFormatter)
    add_selection_args(lint_p)
    lint_p.add_argument('--tool', default="slang",
                        choices=["slang", "verilator"],
                        help="Linter (default: slang)")

    # ---- sim: simulate benchmarks (self-checking testbench), RTL-only ----
    sim_p = sub.add_parser("sim", help="Simulate benchmarks",
                           formatter_class=LbHelpFormatter)
    add_selection_args(sim_p)
    sim_p.add_argument('--tool', default="icarus",
                       choices=["icarus", "verilator"],
                       help="Simulator (default: icarus)")

    # ---- syn: synthesize benchmarks (target task) ----
    syn_p = sub.add_parser("syn", help="Synthesize benchmarks",
                           formatter_class=LbHelpFormatter)
    syn_p.add_argument('-t', '--target', nargs='+', required=True,
                       metavar="TARGET",
                       help=f"PDK stem for ASIC ({_SYN_PDKS}) or an FPGA part "
                            "(e.g. virtex7). Sweeps several in turn.")
    add_selection_args(syn_p)
    syn_p.add_argument('--tool', default="yosys",
                       choices=["yosys", "tardigrade"],
                       help="ASIC synthesis mapper (default: yosys; FPGA parts "
                            "always use yosys)")
    syn_p.add_argument('--clk', type=float, default=None, metavar="PERIOD",
                       help="ASIC clock period in ns (FPGA ignores it; default: "
                            "each PDK's tech.tcl clock)")
    syn_p.add_argument('--options', default="", metavar="OPTS",
                       help="Extra options passed verbatim to the mapper (use "
                            "the =form so leading dashes parse: --options=-abc9)")
    syn_p.add_argument('--label', default=None, metavar="LABEL", type=run_label,
                       help="Name this run variant (letters/digits). Isolates "
                            "its build tree (build/<target>_<label>) and result "
                            "file (<tool>_<target>_<label>.json), so an options "
                            "sweep does not clobber the default run.")
    syn_p.add_argument('--lintonly', action='store_true',
                       help="Elaborate (parse + hierarchy check) then stop "
                            "before synthesis")

    # ---- pnr: place-and-route benchmarks (target task) ----
    pnr_p = sub.add_parser("pnr", help="Place-and-route benchmarks",
                           formatter_class=LbHelpFormatter)
    pnr_p.add_argument('-t', '--target', nargs='+', required=True,
                       metavar="TARGET",
                       help=f"ASIC PDK stem ({_SYN_PDKS}). Place-and-routes the "
                            "netlist from `lb syn --target <pdk>` (run that "
                            "first). FPGA P&R (Logik) is not wired yet.")
    add_selection_args(pnr_p)
    pnr_p.add_argument('--tool', default="openroad", choices=["openroad"],
                       help="Place-and-route engine (default: openroad)")
    pnr_p.add_argument('--clk', type=float, default=None, metavar="PERIOD",
                       help="Clock period in ns for P&R timing (default: each "
                            "PDK's tech.tcl)")
    # --from/--to are pnr-only: the P&R backend is the one multi-stage flow
    # where a step range is meaningful (e.g. --to place to skip cts/route).
    pnr_p.add_argument('--from', dest='start', type=flow_step, default=None,
                       metavar="STEP",
                       help="First P&R step: floorplan, place, cts, route "
                            "(default: floorplan)")
    pnr_p.add_argument('--to', dest='stop', type=flow_step, default=None,
                       metavar="STEP",
                       help="Last P&R step: floorplan, place, cts, route "
                            "(default: route -- through detailed route)")

    # ---- sta: static timing analysis on a cached netlist (target task) ----
    sta_p = sub.add_parser("sta", help="STA benchmarks",
                           formatter_class=LbHelpFormatter)
    sta_p.add_argument('-t', '--target', nargs='+', required=True,
                       metavar="TARGET",
                       help=f"ASIC PDK stem ({_SYN_PDKS}). Runs OpenSTA on the "
                            "netlist from `lb syn --target <pdk>` (run first).")
    add_selection_args(sta_p)
    sta_p.add_argument('--tool', default="opensta", choices=["opensta"],
                       help="STA engine being benchmarked (default: opensta)")
    sta_p.add_argument('--clk', type=float, default=None, metavar="PERIOD",
                       help="Clock period in ns (default: each PDK's tech.tcl)")

    args = parser.parse_args()

    #################################################
    # Dispatch
    #################################################

    # bare `lb` (no subcommand): print help, like pip/git
    if args.command is None:
        parser.print_help()
        return 1

    # RTL-only task subcommands (no target): sim, lint
    if args.command in ("sim", "lint"):
        return run_rtl_task(args)

    # target task subcommands: map --target/--tool to runner tokens, then sweep
    if args.command == "syn":
        return run_target_task("syn", resolve_syn_tokens(args), args)
    if args.command == "pnr":
        return run_target_task("pnr", resolve_pnr_tokens(args), args)
    if args.command == "sta":
        return run_target_task("sta", resolve_sta_tokens(args), args)

    return 0


if __name__ == "__main__":
    sys.exit(main())
