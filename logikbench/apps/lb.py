#!/usr/bin/env python3

import argparse
import os
import sys
import json

import logikbench as lb
from concurrent.futures import ProcessPoolExecutor, as_completed

from logikbench.benchmark import (
    FPGA_METRICS, ASIC_METRICS, TARGETS, FPGA_TARGETS, STEPS,
    run_one, read_metrics, read_asic_metrics, read_tool_var, is_complete,
)

# benchmark groups available to both subcommands
ALL_GROUPS = ['basic', 'memory', 'arithmetic', 'epfl', 'blocks']

# metrics tracked are determined by the run mode (fpga vs asic synthesis)
FLOW_METRICS = {'fpga': FPGA_METRICS, 'asic': ASIC_METRICS}


def target_mode(target):
    """'fpga' for an FPGA target, 'asic' for a PDK/demo target."""
    return 'fpga' if target in FPGA_TARGETS else 'asic'


def target_builddir(args, target):
    """Per-target build tree: <builddir>/<target>/<benchmark>/..."""
    return os.path.join(args.builddir, target)


def make_worklist(args):
    """(group, class-name) pairs honoring the group/name filters; shared across
    targets (the benchmark set is the same for every target)."""
    benchmarks = {group: getattr(lb, group).__all__ for group in ALL_GROUPS}
    namefilter = set(n.lower() for n in args.name) if args.name else None
    return [(group, item)
            for group in args.group
            for item in benchmarks[group]
            if namefilter is None or item.lower() in namefilter]


def target_runlist(target, args, worklist):
    """(group, item) pairs to synthesize for a target, applying --resume
    (skip benchmarks whose build already completed successfully)."""
    if not args.resume:
        return list(worklist)
    builddir = target_builddir(args, target)
    runlist = []
    for group, item in worklist:
        if is_complete(item.lower(), builddir):
            print(f"Skipping {item.lower()} ({target}/{group}): "
                  f"already complete.")
        else:
            runlist.append((group, item))
    return runlist


def run_sweep(args, targets, worklist):
    """Synthesize the whole target x benchmark matrix; return the failures.

    Each (target, benchmark) is an independent SC run, so -j fans them out over
    a single process pool across the entire matrix -- it speeds up sweeps that
    are wide in benchmarks, wide in targets, or both. Pure build: metrics are
    not read or written here (use 'collect' afterwards).
    """
    # flat task list over all targets and their (post-resume-filter) benchmarks
    tasks = [(target, group, item)
             for target in targets
             for group, item in target_runlist(target, args, worklist)]

    quiet = not args.verbose
    failures = []

    def record(target, group, item, error):
        name = item.lower()
        if error is not None:
            print(f"Error synthesizing {name} ({target}/{group}): {error}",
                  file=sys.stderr)
            failures.append(f"{target}/{group}/{name}")
        else:
            print(f"Finished {name} benchmark ({target}/{group}).")

    if args.jobs > 1:
        with ProcessPoolExecutor(max_workers=args.jobs) as pool:
            futures = {}
            for target, group, item in tasks:
                builddir = target_builddir(args, target)
                future = pool.submit(run_one, group, item, target,
                                     args.options, builddir, quiet,
                                     args.start, args.stop)
                futures[future] = (target, group, item)
            for future in as_completed(futures):
                target, group, item = futures[future]
                _, _, _, error = future.result()
                record(target, group, item, error)
    else:
        for target, group, item in tasks:
            print(f"Running {item.lower()} benchmark ({target}/{group}).")
            builddir = target_builddir(args, target)
            _, _, _, error = run_one(group, item, target, args.options,
                                     builddir, quiet, args.start, args.stop)
            record(target, group, item, error)

    return failures


def collect_target(target, args, worklist):
    """Read metrics for the specified benchmarks from a single target's build
    tree and write a self-describing <output_dir>/<target>.json. No synthesis.

    The payload records the target, the synthesis 'options' the run was driven
    with (recovered from the manifest, since lb fed them in at run time), and
    the {metric: {benchmark: value}} matrix. Returns the count collected.
    """
    mode = target_mode(target)
    builddir = target_builddir(args, target)
    metric_names = FLOW_METRICS[mode]
    # --output names a directory; one aggregated <target>.json lands inside it
    outdir = args.output or args.builddir
    output = os.path.join(outdir, f"{target}.json")

    metrics_out = {metric: {} for metric in metric_names}
    options = None
    for group, item in worklist:
        name = item.lower()
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
            metrics_out[metric][name] = metrics.get(metric)
        # options are uniform across a target's sweep; read once from a built one
        if options is None:
            options = read_tool_var(name, "yosys", "synthesis", "options",
                                    builddir=builddir)

    payload = {"target": target, "options": options, "metrics": metrics_out}
    os.makedirs(outdir, exist_ok=True)
    with open(output, "w") as f:
        json.dump(payload, f, indent=2)

    # coverage summary (count, not a line per missing benchmark)
    collected = set()
    for col in metrics_out.values():
        collected.update(col.keys())
    print(f"Collected {len(collected)}/{len(worklist)} benchmark(s) "
          f"for {target}.")
    return len(collected)


def add_common_args(parser):
    """Arguments shared by the 'run' and 'collect' subcommands."""
    parser.add_argument("-g", "--group",
                        nargs='+',
                        choices=ALL_GROUPS,
                        metavar="GROUP",
                        required=True,
                        help=f"Benchmark group(s) (choices: {ALL_GROUPS})")

    parser.add_argument("-n", "--name",
                        nargs='+',
                        help="Only act on benchmark(s) with these name(s); "
                             "names are matched against the benchmarks in the "
                             "selected group(s), so each runs in whichever "
                             "group defines it (default: all of them)")

    parser.add_argument('-b',
                        dest='builddir',
                        default="build",
                        metavar="DIR",
                        help='Build directory root; per-benchmark work goes in '
                             '<builddir>/<target>/<name> (default root: build)')

    parser.add_argument('-t', '--target',
                        nargs='+',
                        choices=TARGETS,
                        required=True,
                        metavar="TARGET",
                        help=f"Synthesis target(s) (choices: {TARGETS}). An FPGA "
                             f"target is named '<vendor>_<partname>' (e.g. "
                             f"xilinx_virtex7, zeroasic_z1010) and picks the "
                             f"yosys synth command; a plain PDK name runs the "
                             f"lbflow ASIC path, and a '<pdk>_demo' name runs "
                             f"the SC demo target via asicflow. Pass several to "
                             f"sweep them in turn.")


def main():

    #################################################
    # Commandline Interface
    #################################################

    parser = argparse.ArgumentParser(description="""\
LogikBench commandline runner.
""", formatter_class=argparse.RawDescriptionHelpFormatter)

    sub = parser.add_subparsers(dest="command", required=True,
                                metavar="{run,collect}")

    # ---- run: synthesize benchmarks (no metric collection) ----
    run_p = sub.add_parser("run", help="Synthesize benchmarks")
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
                       help="Extra options passed verbatim as arguments to the "
                            "FPGA synth command. Use the '=' form so leading "
                            "dashes are not parsed as flags: --options=-abc9 "
                            "(quote multiple: --options='-abc9 -nocarry')")
    # 'from' is a Python keyword, so keep the dest names start/stop
    run_p.add_argument('--from',
                       dest='start',
                       choices=STEPS,
                       default=None,
                       metavar="STEP",
                       help=f"First flow step to run (choices: {STEPS}; "
                            f"default: from the start)")
    run_p.add_argument('--to',
                       dest='stop',
                       choices=STEPS,
                       default=None,
                       metavar="STEP",
                       help=f"Last flow step to run (choices: {STEPS}; "
                            f"default: to the end)")
    run_p.add_argument('--resume',
                       action='store_true',
                       help='Skip benchmarks whose build already completed '
                            'successfully; only synthesize the rest')
    run_p.add_argument('-v', '--verbose',
                       action='store_true',
                       help='Show full SiliconCompiler tool/scheduler logs '
                            '(quieted by default)')

    # ---- collect: harvest metrics from existing build results ----
    collect_p = sub.add_parser("collect",
                               help="Collect metrics from build results")
    add_common_args(collect_p)
    collect_p.add_argument('-o', '--output',
                           default=None,
                           metavar="DIR",
                           help='Output directory; collect writes one '
                                'aggregated <target>.json per target into it '
                                '(default: the build dir root, -b)')

    args = parser.parse_args()

    #################################################
    # Setup
    #################################################

    # targets to sweep (--target is required)
    targets = args.target

    worklist = make_worklist(args)

    #################################################
    # Dispatch
    #################################################

    if args.command == "run":
        failures = run_sweep(args, targets, worklist)
        # signal failure to the caller (e.g. CI) without losing partial results
        if failures:
            print(f"\n{len(failures)} benchmark(s) failed: "
                  f"{', '.join(failures)}")
            return 1
        return 0

    # collect: each target writes its own <output_dir>/<target>.json
    for target in targets:
        if len(targets) > 1:
            print(f"=== target: {target} ===")
        collect_target(target, args, worklist)
    return 0


if __name__ == "__main__":
    sys.exit(main())
