#!/usr/bin/env python3

import argparse
import os
import sys
import json

import logikbench as lb
from concurrent.futures import ProcessPoolExecutor, as_completed

from logikbench.runner import (
    FPGA_METRICS, ASIC_METRICS, FPGA_TARGETS,
    YOSYS_TARGETS, STEPS, run_one, run_task,
    read_metrics, read_asic_metrics, read_tool_var, read_flow_tools,
    is_complete, clean_build, write_netlist_cache,
)

# results file layout version (bump when the JSON structure changes)
SCHEMA_VERSION = 1

# benchmark groups available to both subcommands
ALL_GROUPS = ['basic', 'memory', 'arithmetic', 'epfl', 'blocks',
              'iscas85', 'iscas89']

# metrics tracked are determined by the run mode (fpga vs asic synthesis)
FLOW_METRICS = {'fpga': FPGA_METRICS, 'asic': ASIC_METRICS}

# `lb syn --target`: PDK stems (ASIC lbflow) + FPGA parts. --tool picks the ASIC
# mapper; the runner token is '<tool>_<pdk>' (FPGA parts run as-is, yosys only).
_SYN_PDKS = sorted({t.split('_', 1)[1] for t in YOSYS_TARGETS})
_SYN_TOOL_PREFIX = {'yosys': 'yosys', 'tardigrade': 'tg'}


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


def target_builddir(args, target):
    """Per-target build tree: <builddir>/<target>/<benchmark>/..."""
    return os.path.join(args.builddir, target)


def make_worklist(args):
    """(group, design-class, design-name) triples honoring the group/name filters.

    Shared across targets (the benchmark set is the same for every target). The
    class is resolved here (the app owns benchmark discovery) and passed on to
    run_one, so the runner never reflects over the package. The design name is
    the SC name (e.g. 'epfl_arbiter'), which may differ from the class name --
    it is what keys build dirs, metrics, and the -n filter.
    """
    namefilter = set(n.lower() for n in args.name) if args.name else None
    worklist = []
    for group in args.group:
        module = getattr(lb, group)
        for item in module.__all__:
            cls = getattr(module, item)
            name = cls().name
            if namefilter is None or name in namefilter:
                worklist.append((group, cls, name))
    return worklist


def check_worklist(args, worklist):
    """Fail loudly (exit 2) when the selection resolves to no benchmarks, so a
    run/collect never silently does nothing. -n searches all groups (names are
    globally unique), so an unmatched name is simply not a known benchmark.
    """
    if args.name:
        matched = {name for _, _, name in worklist}
        unmatched = [n for n in args.name if n.lower() not in matched]
        if unmatched:
            print("error: not a known benchmark: "
                  f"{', '.join(unmatched)}", file=sys.stderr)
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
        if is_complete(name, builddir):
            loc = os.path.join(".", builddir, name)
            print(f"Skipping {name} ({loc}): already complete.")
        else:
            runlist.append((group, cls, name))
    return runlist


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
    cls_by_name = {name: cls for _, _, cls, name in tasks}

    # Same completion message for every job, regardless of target (FPGA or
    # ASIC) or scheduling (-j sequential vs parallel).
    def record(target, group, name, error):
        nonlocal done
        done += 1
        prefix = f"[{done}/{total}]"
        # show the per-benchmark build directory (e.g. ./build/sc_gf180/muxcase)
        # so the message points at where the artifacts live
        loc = os.path.join(".", target_builddir(args, target), name)
        if error is not None:
            print(f"{prefix} Error synthesizing {name} ({loc}): "
                  f"{error}", file=sys.stderr)
            failures.append(f"{target}/{group}/{name}")
        else:
            print(f"{prefix} Finished {name} benchmark ({loc}).")
            # cache the mapped netlist (ASIC syn only) so the back-end verbs
            # (pnr/sta/lec) start from it instead of re-synthesizing
            if netlist_cache and target_mode(target) == "asic":
                src = os.path.join(target_builddir(args, target), name, "job0",
                                   "synthesis", "0", "outputs", f"{name}.vg")
                if os.path.isfile(src):
                    write_netlist_cache(args.builddir, target, name, src,
                                        cls_by_name[name]())
        # By default reclaim disk as we go (pass or fail), keeping only the
        # manifest --resume needs; --keep retains everything. Runs
        # in the parent for both the sequential and -j parallel paths, so
        # benchmarks never race on it.
        if not args.keep:
            clean_build(name, builddir=target_builddir(args, target))

    if args.jobs > 1:
        with ProcessPoolExecutor(max_workers=args.jobs) as pool:
            futures = {}
            for target, group, cls, name in tasks:
                builddir = target_builddir(args, target)
                future = pool.submit(run_one, cls, target,
                                     options, builddir, quiet,
                                     start, stop, timeout, args.clk,
                                     lintonly)
                futures[future] = (target, group, name)
            for future in as_completed(futures):
                target, group, name = futures[future]
                _, error = future.result()
                record(target, group, name, error)
    else:
        for target, group, cls, name in tasks:
            builddir = target_builddir(args, target)
            _, error = run_one(cls, target, options,
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

    metrics_out = {metric: {} for metric in metric_names}
    options = None
    for group, cls, name in worklist:
        if mode == 'asic':
            metrics = read_asic_metrics(name, builddir=builddir)
        else:
            metrics = read_metrics(name, FPGA_METRICS, builddir=builddir)
        if metrics is None:
            if args.name is not None:
                # only warn about benchmarks the user explicitly named
                print(f"No results for {name} benchmark ({group}).")
            continue
        for metric in metric_names:
            value = metrics.get(metric)
            # report runtime to 2 decimal places (0.xx)
            if metric == "tasktime" and value is not None:
                value = round(value, 2)
            metrics_out[metric][name] = value
        # options are uniform across a target's sweep; read once from a built one
        if options is None:
            options = read_tool_var(name, "yosys", "synthesis", "options",
                                    builddir=builddir)

    collected = set()
    for col in metrics_out.values():
        collected.update(col.keys())
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
    for metric, col in src.get("metrics", {}).items():
        metrics.setdefault(metric, {}).update(col)
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
    output = os.path.join(outdir, f"{target}.json")

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
    metrics = payload.get("metrics", {})
    for metric, col in metrics_out.items():
        metrics.setdefault(metric, {}).update(col)

    # provenance: what produced these numbers (git versions the rest). Tools are
    # discovered from the flow the target ran; refreshed each run.
    tools, scversion = {}, None
    for _, _, nm in worklist:
        tools, scversion = read_flow_tools(nm, builddir=target_builddir(args,
                                                                        target))
        if tools or scversion:
            break
    meta = payload.get("meta", {})
    meta["schema_version"] = SCHEMA_VERSION
    meta["target"] = target
    if options is not None:
        meta["options"] = options
    meta["logikbench"] = getattr(lb, "__version__", None)
    if scversion is not None:
        meta["siliconcompiler"] = scversion
    if tools:
        meta["tools"] = tools

    payload = {"meta": meta, "metrics": metrics}
    with open(output, "w") as f:
        json.dump(payload, f, indent=2, sort_keys=True)
    print(f"Collected {collected}/{len(worklist)} benchmark(s) -> {output}")
    return collected


def add_selection_args(parser):
    """Benchmark selection + build plumbing shared by every task subcommand.
    No --target: RTL-only tasks (sim/lint) take none; target tasks add it."""
    select = parser.add_mutually_exclusive_group()
    select.add_argument("-g", "--group", nargs='+', choices=ALL_GROUPS,
                        default=ALL_GROUPS, metavar="GROUP",
                        help=f"Benchmark group(s) (default: all: {ALL_GROUPS}). "
                             "Mutually exclusive with -n")
    select.add_argument("-n", "--name", nargs='+',
                        help="Specific benchmark(s) by name, searched across all "
                             "groups (globally unique). Mutually exclusive with -g")
    parser.add_argument('-b', dest='builddir', default="build", metavar="DIR",
                        help="Build directory root (default: build)")
    parser.add_argument('-j', dest='jobs', type=int, default=1, metavar="N",
                        help="Benchmarks to run in parallel (default: 1)")
    parser.add_argument('--timeout', type=float, default=3600, metavar="SEC",
                        help="Per-step wall-clock cap in seconds "
                             "(default: 3600; 0 disables)")
    parser.add_argument('--publish', action='store_true',
                        help="Merge results into the committed ./results tree "
                             "(git clone only; errors otherwise)")
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
    bench = payload.get("benchmarks", {})
    bench.update(results)
    payload = {"meta": {"task": task, "schema_version": SCHEMA_VERSION,
                        "logikbench": getattr(lb, "__version__", None)},
               "benchmarks": bench}
    with open(out, "w") as f:
        json.dump(payload, f, indent=2, sort_keys=True)
    print(f"Wrote {len(results)} benchmark(s) -> {out}")


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
    bench.update(src_data.get("benchmarks", {}))
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
    for _, cls, name in worklist:
        if args.resume and is_complete(name, args.builddir):
            loc = os.path.join(".", args.builddir, name)
            print(f"Skipping {name} ({loc}): already complete.")
            continue
        tasks.append((cls, name))
    total = len(tasks)
    done = 0
    results = {}
    failures = []

    def record(name, metrics, error):
        nonlocal done
        done += 1
        prefix = f"[{done}/{total}]"
        loc = os.path.join(".", args.builddir, name)
        if error is not None:
            print(f"{prefix} Error ({task}) {name} ({loc}): {error}",
                  file=sys.stderr)
            failures.append(name)
        else:
            results[name] = metrics
            status = (metrics or {}).get("status")
            tag = f" [{status}]" if status else ""
            print(f"{prefix} Finished ({task}) {name} ({loc}){tag}.")

    if args.jobs and args.jobs > 1:
        with ProcessPoolExecutor(max_workers=args.jobs) as pool:
            futs = {pool.submit(run_task, task, cls, args.tool, args.builddir,
                                quiet, timeout): name for cls, name in tasks}
            for fut in as_completed(futs):
                m, e = fut.result()
                record(futs[fut], m, e)
    else:
        for cls, name in tasks:
            m, e = run_task(task, cls, args.tool, args.builddir, quiet, timeout)
            record(name, m, e)

    save_task(task, args, results)
    if args.publish:
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
    for tok in tokens:
        src = os.path.join(src_dir, f"{tok}.json")
        if not os.path.isfile(src):
            print(f"--publish: no build metrics for '{tok}' at {src}, skipping",
                  file=sys.stderr)
            continue
        dstdir = os.path.join(tree, task, target_mode(tok))
        os.makedirs(dstdir, exist_ok=True)
        dst = os.path.join(dstdir, f"{tok}.json")
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
        if args.publish:
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
