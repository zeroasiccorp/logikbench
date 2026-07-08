#!/usr/bin/env python3

import argparse
import os
import sys
import json
import csv
import textwrap

import logikbench as lb
from concurrent.futures import ProcessPoolExecutor, as_completed

from logikbench.runner import (
    FPGA_METRICS, ASIC_METRICS, TARGETS, FPGA_TARGETS, SC_TARGETS,
    YOSYS_TARGETS, TARDIGRADE_TARGETS, STEPS, run_one,
    read_metrics, read_asic_metrics, read_tool_var, read_flow_tools,
    is_complete, clean_build,
)

# results file layout version (bump when the JSON structure changes)
SCHEMA_VERSION = 1

# benchmark groups available to both subcommands
ALL_GROUPS = ['basic', 'memory', 'arithmetic', 'epfl', 'blocks',
              'iscas85', 'iscas89']

# metrics tracked are determined by the run mode (fpga vs asic synthesis)
FLOW_METRICS = {'fpga': FPGA_METRICS, 'asic': ASIC_METRICS}


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


# --target help: a fixed format legend plus the (dynamic) list of valid choices,
# grouped by kind and wrapped so each list lines up under the help column. Every
# target is '<tool>_<part>': FPGA '<vendor>_<part>' targets, then the ASIC sets
# by tool (sc asicflow, yosys lbflow, tardigrade lbflow).
_FPGA_CHOICES = list(FPGA_TARGETS)
_ASIC_CHOICES = list(YOSYS_TARGETS)
_TOOL_CHOICES = list(TARDIGRADE_TARGETS)
_SC_CHOICES = list(SC_TARGETS)


def _choices_block(label, choices):
    return textwrap.fill(", ".join(choices), width=54,
                         initial_indent=label, subsequent_indent="")


_TARGET_HELP = (
    "Synthesis target(s). Pass several to sweep them in turn.\n"
    "Format '<tool>_<part>':\n"
    "  - '<vendor>_<partname>' -> FPGA target (e.g., xilinx_virtex7)\n"
    "  - 'sc_<pdk>'            -> SiliconCompiler asicflow (e.g., sc_asap7)\n"
    "  - 'yosys_<pdk>'         -> yosys synth + STA (e.g., yosys_freepdk45)\n"
    "  - 'tardigrade_<pdk>'    -> tardigrade synth + STA\n"
    + "\n" + _choices_block("FPGA: ", _FPGA_CHOICES)
    + "\n\n" + _choices_block("ASIC (SiliconCompiler): ", _SC_CHOICES)
    + "\n\n" + _choices_block("ASIC (yosys): ", _ASIC_CHOICES)
    + "\n\n" + _choices_block("ASIC (tardigrade): ", _TOOL_CHOICES)
)


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
            print(f"Skipping {name} ({target}/{group}): already complete.")
        else:
            runlist.append((group, cls, name))
    return runlist


def run_sweep(args, targets, worklist):
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
    failures = []
    total = len(tasks)
    done = 0  # completed-job counter; printed as [done/total] progress

    # Same completion message for every job, regardless of target (FPGA or
    # ASIC) or scheduling (-j sequential vs parallel).
    def record(target, group, name, error):
        nonlocal done
        done += 1
        prefix = f"[{done}/{total}]"
        if error is not None:
            print(f"{prefix} Error synthesizing {name} ({target}/{group}): "
                  f"{error}", file=sys.stderr)
            failures.append(f"{target}/{group}/{name}")
        else:
            print(f"{prefix} Finished {name} benchmark ({target}/{group}).")
        # By default reclaim disk as we go (pass or fail), keeping only the
        # manifest 'lb collect'/--resume need; --keep retains everything. Runs
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
                                     args.options, builddir, quiet,
                                     args.start, args.stop, timeout, args.clk,
                                     args.lintonly)
                futures[future] = (target, group, name)
            for future in as_completed(futures):
                target, group, name = futures[future]
                _, error = future.result()
                record(target, group, name, error)
    else:
        for target, group, cls, name in tasks:
            builddir = target_builddir(args, target)
            _, error = run_one(cls, target, args.options,
                               builddir, quiet, args.start, args.stop,
                               timeout, args.clk, args.lintonly)
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


def save_target(target, args, worklist):
    """Write one target's metrics as <output>/<target>.json (default
    build/results) and print the path. To publish into the committed results
    tree, run with -o results.
    """
    metrics_out, options, collected = gather_target_metrics(target, args,
                                                            worklist)
    outdir = args.output
    os.makedirs(outdir, exist_ok=True)
    output = os.path.join(outdir, f"{target}.json")

    # incremental read-modify-write: update only the benchmarks in this run and
    # preserve metrics already recorded for others (so a subset run/publish does
    # not clobber the rest of the target's results).
    payload = {"target": target, "options": options, "metrics": {}}
    if os.path.isfile(output):
        try:
            with open(output) as f:
                payload = json.load(f)
        except (ValueError, OSError):
            payload = {"target": target, "options": options, "metrics": {}}
    payload["target"] = target
    if options is not None:
        payload["options"] = options
    payload.setdefault("metrics", {})
    for metric, col in metrics_out.items():
        payload["metrics"].setdefault(metric, {}).update(col)

    # provenance: what produced these numbers (git versions the rest). Tools are
    # discovered from the flow the target ran; refreshed each run.
    tools, scversion = {}, None
    for _, _, nm in worklist:
        tools, scversion = read_flow_tools(nm, builddir=target_builddir(args,
                                                                        target))
        if tools or scversion:
            break
    meta = {"logikbench": getattr(lb, "__version__", None)}
    if scversion is not None:
        meta["siliconcompiler"] = scversion
    if tools:
        meta["tools"] = tools
    payload["schema_version"] = SCHEMA_VERSION
    payload["meta"] = meta

    with open(output, "w") as f:
        json.dump(payload, f, indent=2, sort_keys=True)
    print(f"Wrote {collected}/{len(worklist)} benchmark(s) -> {output}")
    return collected


def _load_metrics_file(path):
    """Load a <target>.json metrics file, returning (label, {metric: {bench:
    value}}). label is the file's recorded target (or the filename stem)."""
    if not os.path.isfile(path):
        print(f"error: no such metrics file: {path}", file=sys.stderr)
        sys.exit(2)
    with open(path) as f:
        data = json.load(f)
    label = data.get("target") or os.path.splitext(os.path.basename(path))[0]
    return label, data.get("metrics", {})


def compare_files(paths, args):
    """Tabulate one metric across two or more metrics files into a CSV: rows are
    benchmarks, one column per file (labeled by its target). No deltas. The
    output path (-o, default ./compare_<metric>.csv) is printed.
    """
    if len(paths) < 2:
        print("error: compare needs at least two files", file=sys.stderr)
        sys.exit(2)
    metric = args.metric

    loaded = [_load_metrics_file(p) for p in paths]     # [(label, metrics), ...]
    labels = [label for label, _ in loaded]
    if len(set(labels)) != len(labels):
        labels = list(paths)     # disambiguate duplicate target names by path

    benches = set()
    for _, metrics in loaded:
        benches.update(metrics.get(metric, {}))

    output = args.output or f"compare_{metric}.csv"
    parent = os.path.dirname(output)
    if parent:
        os.makedirs(parent, exist_ok=True)

    rows = sorted(benches)
    if output.lower().endswith(".json"):
        # machine-readable: {metric, targets, data:{bench:{target:value}}}
        data = {}
        for name in rows:
            data[name] = {lab: metrics.get(metric, {}).get(name)
                          for lab, (_, metrics) in zip(labels, loaded)}
        payload = {"metric": metric, "targets": labels, "data": data}
        with open(output, "w") as f:
            json.dump(payload, f, indent=2, sort_keys=True)
    else:
        with open(output, "w", newline="") as f:
            w = csv.writer(f)
            w.writerow(["benchmark"] + labels)
            for name in rows:
                row = [name] + [metrics.get(metric, {}).get(name)
                                for _, metrics in loaded]
                w.writerow(row)
    print(f"Wrote {metric} comparison of {len(paths)} files -> {output}")


def add_common_args(parser):
    """Arguments shared by the 'run' and 'collect' subcommands."""
    parser.add_argument('-t', '--target',
                        nargs='+',
                        choices=TARGETS,
                        required=True,
                        metavar="TARGET",
                        help=_TARGET_HELP)

    # -g and -n are two ways to pick benchmarks and are mutually exclusive:
    # -g runs whole group(s); -n names specific benchmarks. Benchmark names are
    # globally unique, so -n needs no group and searches all of them.
    select = parser.add_mutually_exclusive_group()
    select.add_argument("-g", "--group",
                        nargs='+',
                        choices=ALL_GROUPS,
                        default=ALL_GROUPS,
                        metavar="GROUP",
                        help=f"Benchmark group(s) to run (choices: {ALL_GROUPS}; "
                             f"default: all). Mutually exclusive with -n")

    select.add_argument("-n", "--name",
                        nargs='+',
                        help="Run specific benchmark(s) by name, searched across "
                             "all groups (names are globally unique). Mutually "
                             "exclusive with -g")

    parser.add_argument('-b',
                        dest='builddir',
                        default="build",
                        metavar="DIR",
                        help='Build directory root. Per-benchmark artifacts go '
                             'to: <builddir>/<target>/<name> (default: build)')


def main():

    #################################################
    # Commandline Interface
    #################################################

    parser = argparse.ArgumentParser(description="""\
LogikBench commandline runner.
""", formatter_class=argparse.RawDescriptionHelpFormatter)

    sub = parser.add_subparsers(dest="command", required=True,
                                metavar="{run,compare}")

    # ---- run: synthesize benchmarks (no metric collection) ----
    run_p = sub.add_parser("run", help="Synthesize benchmarks",
                           formatter_class=LbHelpFormatter)
    add_common_args(run_p)
    run_p.add_argument('-j',
                       dest='jobs',
                       type=int,
                       default=1,
                       metavar="N",
                       help='Number of benchmarks to synthesize in parallel '
                            '(default: 1)')
    run_p.add_argument('--options',
                       default="",
                       metavar="OPTS",
                       help="Extra options passed verbatim to the synthesis "
                            "tool: appended to the FPGA yosys synth command, or "
                            "handed to tardigrade as '-option <opt>' on ASIC "
                            "tardigrade targets (yosys/SC ASIC paths ignore "
                            "them). NOTE: Use the '=' form to prevent leading "
                            "dashes from being parsed as flags (e.g., "
                            "--options=-abc9 or --options='-abc9 -nocarry')")
    # 'from' is a Python keyword, so keep the dest names start/stop
    run_p.add_argument('--from',
                       dest='start',
                       type=flow_step,
                       default=None,
                       metavar="STEP",
                       help=f"First flow step to run. Can be a stage name "
                            f"{STEPS} or a raw SC node 'step.task' "
                            f"(default: from the start)")
    run_p.add_argument('--to',
                       dest='stop',
                       type=flow_step,
                       default=None,
                       metavar="STEP",
                       help=f"Last flow step to run. Can be a stage name "
                            f"{STEPS} or a raw SC node 'step.task' like "
                            f"'floorplan.init' (default: to the end)")
    run_p.add_argument('--clk',
                       type=float,
                       default=None,
                       metavar="PERIOD",
                       help='ASIC clock period in nanoseconds for the generic '
                            'SDC (create_clock); scaled into each PDK time '
                            'unit. Ignored for FPGA targets (default: each '
                            "PDK's tech.tcl clock)")
    run_p.add_argument('--lintonly',
                       action='store_true',
                       help='Elaborate the RTL (parse + hierarchy check) and '
                            'stop before the heavy synthesis/optimization, then '
                            'report success. Fast check that a target or '
                            'benchmark builds without a full run.')
    run_p.add_argument('--resume',
                       action='store_true',
                       help='Skip benchmarks whose build already completed '
                            'successfully; only synthesize the rest')
    run_p.add_argument('--keep',
                       action='store_true',
                       help='Keep the full synthesis artifacts (logs, netlists, '
                            'reports) for each benchmark. By default they are '
                            'deleted as each benchmark finishes, leaving only '
                            'the manifest that collect and --resume need, so '
                            'peak disk stays bounded by the in-flight jobs '
                            'instead of the whole sweep. Use --keep to retain '
                            'everything (needed for a later --from mid-flow '
                            'resume, at the cost of disk)')
    run_p.add_argument('--timeout',
                       type=float,
                       default=3600,
                       metavar="SEC",
                       help='Per-step wall-clock cap in seconds. Steps '
                            'exceeding this are killed and marked failed to '
                            'prevent stalls (default: 3600; 0 to disable)')
    run_p.add_argument('-v', '--verbose',
                       action='store_true',
                       help='Show full SiliconCompiler tool/scheduler logs '
                            '(quieted by default)')
    run_p.add_argument('-o', '--output',
                       default='build/results',
                       metavar="DIR",
                       help='Directory for the per-target metrics file '
                            '<DIR>/<target>.json (default: build/results). '
                            'Use -o results to publish into the committed '
                            'results tree.')

    # ---- compare: write a CSV diffing two explicit metrics files ----
    compare_p = sub.add_parser("compare",
                               help="Compare two metrics files (CSV)")
    compare_p.add_argument('files', nargs='+', metavar="FILE",
                           help="two or more <target>.json metrics files to "
                                "compare (e.g. build/results/xilinx_virtex7.json "
                                "results/lattice_ice40.json)")
    compare_p.add_argument('-m', '--metric',
                           required=True,
                           metavar="METRIC",
                           help="metric to tabulate, one column per file "
                                "(e.g. luts, logicdepth, cellarea, fmax, cells, "
                                "tasktime)")
    compare_p.add_argument('-o', '--output',
                           default=None,
                           metavar="FILE",
                           help='output file; format is chosen by extension '
                                '(.json -> JSON, else CSV) '
                                '(default: ./compare_<metric>.csv)')

    args = parser.parse_args()

    #################################################
    # Dispatch
    #################################################

    if args.command == "compare":
        compare_files(args.files, args)
        return 0

    # run: build the target x benchmark matrix, then write/publish metrics
    targets = args.target
    worklist = make_worklist(args)
    check_worklist(args, worklist)

    if args.command == "run":
        failures = run_sweep(args, targets, worklist)
        # write each target's metrics to -o; lint-only has no metrics
        if not args.lintonly:
            for target in targets:
                save_target(target, args, worklist)
        # signal failure to the caller (e.g. CI) without losing partial results
        if failures:
            print(f"\n{len(failures)} benchmark(s) failed: "
                  f"{', '.join(failures)}")
            return 1
        return 0
    return 0


if __name__ == "__main__":
    sys.exit(main())
