#!/usr/bin/env python3

import argparse
import os
import sys
import json
import csv

import logikbench as lb
from concurrent.futures import ProcessPoolExecutor, as_completed

from logikbench.benchmark import (
    METRICS, ASIC_METRICS, TARGETS, FPGA_TARGETS, DEFAULT_FPGA_TARGET, STEPS,
    run_one, read_metrics, read_asic_metrics, is_complete,
)

# benchmark groups available to both subcommands
ALL_GROUPS = ['basic', 'memory', 'arithmetic', 'epfl', 'blocks']

# metrics tracked are determined by the run mode (fpga vs asic synthesis)
FLOW_METRICS = {'fpga': METRICS, 'asic': ASIC_METRICS}


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


def write_results(output, results):
    """Write the results dict to a .json or .csv file (by extension)."""
    outdir = os.path.dirname(output)
    if outdir:
        os.makedirs(outdir, exist_ok=True)
    _, ext = os.path.splitext(output)
    if ext == ".json":
        with open(output, "w") as f:
            json.dump(results, f, indent=2)
    elif ext == ".csv":
        all_rows = set()
        for col in results.values():
            all_rows.update(col.keys())
        all_rows = sorted(all_rows)
        columns = sorted(results.keys())
        with open(output, "w", newline="") as f:
            writer = csv.writer(f)
            # Write header
            writer.writerow([""] + columns)
            # Write each row
            for row_key in all_rows:
                row = [row_key]
                for col_key in columns:
                    row.append(results.get(col_key, {}).get(row_key, ""))
                writer.writerow(row)


def run_target(target, args, worklist):
    """Synthesize every benchmark for a single target; return the failures.

    Pure build: metrics are not read or written here. Use the 'collect'
    subcommand afterwards to harvest results from the build tree.
    """
    builddir = target_builddir(args, target)

    # incremental: skip benchmarks whose build already completed successfully;
    # only the remaining benchmarks are (re-)synthesized.
    runlist = worklist
    if args.incremental:
        runlist = []
        for group, item in worklist:
            if is_complete(item.lower(), builddir):
                print(f"Skipping {item.lower()} benchmark ({group}): "
                      f"already complete.")
            else:
                runlist.append((group, item))

    # track failures so one bad benchmark does not abort the whole sweep
    failures = []

    # job-level parallelism: each benchmark is an independent SC run, so we
    # fan them out over a process pool (synthesis is the expensive part).
    quiet = not args.verbose
    if args.jobs > 1:
        with ProcessPoolExecutor(max_workers=args.jobs) as pool:
            futures = [pool.submit(run_one, group, item, target,
                                   args.options, builddir, quiet,
                                   args.start, args.stop)
                       for group, item in runlist]
            for future in as_completed(futures):
                group, item, _, error = future.result()
                name = item.lower()
                if error is not None:
                    print(f"Error synthesizing {name} ({group}): {error}",
                          file=sys.stderr)
                    failures.append(f"{target}/{group}/{name}")
                    continue
                print(f"Finished {name} benchmark ({group}).")
    else:
        for group, item in runlist:
            print(f"Running {item.lower()} benchmark ({group}).")
            _, _, _, error = run_one(group, item, target,
                                     args.options, builddir, quiet,
                                     args.start, args.stop)
            if error is not None:
                print(f"Error synthesizing {item.lower()} ({group}): {error}",
                      file=sys.stderr)
                failures.append(f"{target}/{group}/{item.lower()}")

    return failures


def collect_target(target, args, worklist):
    """Read metrics for the specified benchmarks from a single target's build
    tree and write them, aggregated, to <output_dir>/<target>.json. No
    synthesis. Returns the number of benchmarks collected."""
    mode = target_mode(target)
    builddir = target_builddir(args, target)
    metric_names = FLOW_METRICS[mode]
    # --output names a directory; one aggregated <target>.json lands inside it
    outdir = args.output or args.builddir
    output = os.path.join(outdir, f"{target}.json")

    results = {metric: {} for metric in metric_names}
    for group, item in worklist:
        name = item.lower()
        if mode == 'asic':
            metrics = read_asic_metrics(name, builddir=builddir)
        else:
            metrics = read_metrics(name, METRICS, builddir=builddir)
        if metrics is None:
            if args.name is not None:
                # only warn about benchmarks the user explicitly named
                print(f"No results for {name} benchmark ({group}).")
            continue
        for metric in metric_names:
            results[metric][name] = metrics.get(metric)

    write_results(output, results)

    # coverage summary (count, not a line per missing benchmark)
    collected = set()
    for col in results.values():
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

    parser.add_argument('-b', '--builddir',
                        default="build",
                        metavar="DIR",
                        help='Build directory root; per-benchmark work goes in '
                             '<builddir>/<target>/<name> (default root: build)')

    parser.add_argument('--target',
                        nargs='+',
                        choices=TARGETS,
                        default=None,
                        metavar="TARGET",
                        help=f"Synthesis target(s) (choices: {TARGETS}); an FPGA "
                             f"target (e.g. ice40, xilinx, zeroasic) picks the "
                             f"yosys synth command, a plain PDK name runs the "
                             f"lbflow ASIC path, and a '<pdk>_demo' name runs "
                             f"the SC demo target via asicflow. Pass several to "
                             f"sweep them in turn. Omit for default FPGA "
                             f"synthesis ({DEFAULT_FPGA_TARGET})")


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
    run_p.add_argument('-j', '--jobs',
                       type=int,
                       default=1,
                       metavar="N",
                       help='Number of benchmarks to synthesize in parallel '
                            '(default: 1)')
    run_p.add_argument('--options',
                       default="",
                       metavar="OPTS",
                       help="Extra options passed verbatim as arguments to "
                            "the FPGA synth command (e.g. --options "
                            "'-abc9 -nocarry')")
    run_p.add_argument('--start',
                       choices=STEPS,
                       default=None,
                       metavar="STEP",
                       help=f"First flow step to run (choices: {STEPS}; "
                            f"default: from the start)")
    run_p.add_argument('--stop',
                       choices=STEPS,
                       default=None,
                       metavar="STEP",
                       help=f"Last flow step to run (choices: {STEPS}; "
                            f"default: to the end)")
    run_p.add_argument('--incremental',
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

    # targets to sweep: no --target means default FPGA synthesis
    targets = args.target or [DEFAULT_FPGA_TARGET]

    worklist = make_worklist(args)

    #################################################
    # Dispatch
    #################################################

    if args.command == "run":
        failures = []
        for target in targets:
            if len(targets) > 1:
                print(f"=== target: {target} ===")
            failures.extend(run_target(target, args, worklist))
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
