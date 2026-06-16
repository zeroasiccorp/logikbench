#!/usr/bin/env python3

import argparse
import os
import sys
import json
import csv

import logikbench as lb
from concurrent.futures import ProcessPoolExecutor, as_completed

from logikbench.flows.runner import (
    METRICS, ASIC_METRICS, ASIC_PDKS,
    run_one, read_metrics, read_asic_metrics, is_complete,
)


def main():

    #################################################
    # Scope
    #################################################

    all_groups = ['basic',
                  'memory',
                  'arithmetic',
                  'epfl',
                  'blocks']

    all_flows = ['fpga', 'asic']

    # metrics tracked are determined by the selected flow
    flow_metrics = {'fpga': METRICS, 'asic': ASIC_METRICS}

    #################################################
    # Commandline Interface
    #################################################

    parser = argparse.ArgumentParser(description="""\
LogikBench commandline runner.
""", formatter_class=argparse.RawDescriptionHelpFormatter)

    parser.add_argument("-g", "--group",
                        nargs='+',
                        choices=all_groups,
                        metavar="GROUP",
                        required=True,
                        help=f"Benchmark group(s) to run "
                             f"(choices: {all_groups})")

    parser.add_argument("-n", "--name",
                        nargs='+',
                        help="Only run benchmark(s) with these name(s); names "
                             "are matched against the benchmarks in the "
                             "selected group(s), so each runs in whichever "
                             "group defines it (default: all of them)")

    parser.add_argument("-f", "--flow",
                        choices=all_flows,
                        default="fpga",
                        metavar="FLOW",
                        help=f"Synthesis flow (default: fpga; "
                             f"choices: {all_flows})")

    parser.add_argument('-b', '--builddir',
                        default="build",
                        metavar="DIR",
                        help='Build directory root; per-benchmark work goes in '
                             '<builddir>/<name> (default: build)')

    parser.add_argument('-o', '--output',
                        default=None,
                        help='Output file name (default: '
                             '<builddir>/results.json)')

    parser.add_argument('-j', '--jobs',
                        type=int,
                        default=1,
                        metavar="N",
                        help='Number of benchmarks to synthesize in parallel '
                             '(default: 1)')

    parser.add_argument('--pdk',
                        choices=ASIC_PDKS,
                        default=ASIC_PDKS[0],
                        metavar="PDK",
                        help=f"Standard-cell library for the asic flow "
                             f"(default: {ASIC_PDKS[0]}; choices: {ASIC_PDKS}); "
                             f"ignored for the fpga flow")

    parser.add_argument('--collect_only',
                        action='store_true',
                        help='Collect metrics from existing build results '
                             'without synthesizing')

    parser.add_argument('--incremental',
                        action='store_true',
                        help='Skip benchmarks whose build already completed '
                             'successfully; only synthesize the rest')

    parser.add_argument('-v', '--verbose',
                        action='store_true',
                        help='Show full SiliconCompiler tool/scheduler logs '
                             '(quieted by default)')

    args = parser.parse_args()

    #################################################
    # Setup
    #################################################

    # default the results file into the build directory
    if args.output is None:
        args.output = os.path.join(args.builddir, "results.json")

    # metrics tracked are the full set produced by the selected flow
    metric_names = flow_metrics[args.flow]

    # get list of benchmarks (keyed by group, value is list of class names)
    benchmarks = {group: getattr(lb, group).__all__ for group in all_groups}

    # optional filter by benchmark name
    namefilter = set(n.lower() for n in args.name) if args.name else None

    # global analysis
    results = {metric: {} for metric in metric_names}

    # track failures so one bad benchmark does not abort the whole sweep
    failures = []

    # work list of (group, class-name) honoring the group/name filters
    worklist = [(group, item)
                for group in args.group
                for item in benchmarks[group]
                if namefilter is None or item.lower() in namefilter]

    def store(group, item, metrics):
        name = item.lower()
        for metric in metric_names:
            results[metric][name] = metrics.get(metric)

    #################################################
    # Loop
    #################################################

    if args.collect_only:
        # read existing metrics only, no synthesis (fast, serial)
        for group, item in worklist:
            name = item.lower()
            if args.flow == 'asic':
                metrics = read_asic_metrics(name, builddir=args.builddir)
            else:
                metrics = read_metrics(name, builddir=args.builddir)
            if metrics is None:
                if namefilter is not None:
                    # only warn about benchmarks the user explicitly named
                    print(f"No results for {name} benchmark ({group}).")
                continue
            store(group, item, metrics)

        # coverage summary (count, not a line per missing benchmark)
        collected = set()
        for col in results.values():
            collected.update(col.keys())
        expected = sum(1 for g in args.group for it in benchmarks[g]
                       if namefilter is None or it.lower() in namefilter)
        print(f"Collected {len(collected)}/{expected} benchmark(s).")
    else:
        # incremental: skip benchmarks already completed, reusing their metrics;
        # only the remaining benchmarks are (re-)synthesized.
        runlist = worklist
        if args.incremental:
            runlist = []
            for group, item in worklist:
                name = item.lower()
                if is_complete(name, args.flow, args.builddir):
                    if args.flow == 'asic':
                        metrics = read_asic_metrics(name, builddir=args.builddir)
                    else:
                        metrics = read_metrics(name, builddir=args.builddir)
                    print(f"Skipping {name} benchmark ({group}): already complete.")
                    store(group, item, metrics)
                else:
                    runlist.append((group, item))

        # job-level parallelism: each benchmark is an independent SC run, so we
        # fan them out over a process pool (synthesis is the expensive part).
        quiet = not args.verbose
        if args.jobs > 1:
            with ProcessPoolExecutor(max_workers=args.jobs) as pool:
                futures = [pool.submit(run_one, group, item, args.flow,
                                       args.builddir, args.pdk, quiet)
                           for group, item in runlist]
                for future in as_completed(futures):
                    group, item, metrics, error = future.result()
                    name = item.lower()
                    if error is not None:
                        print(f"Error synthesizing {name} ({group}): {error}",
                              file=sys.stderr)
                        failures.append(f"{group}/{name}")
                        continue
                    print(f"Finished {name} benchmark ({group}).")
                    store(group, item, metrics)
        else:
            for group, item in runlist:
                print(f"Running {item.lower()} benchmark ({group}).")
                _, _, metrics, error = run_one(group, item, args.flow,
                                               args.builddir, args.pdk, quiet)
                if error is not None:
                    print(f"Error synthesizing {item.lower()} ({group}): {error}",
                          file=sys.stderr)
                    failures.append(f"{group}/{item.lower()}")
                    continue
                store(group, item, metrics)

    #################################################
    # Output
    #################################################

    # writing results to file
    outdir = os.path.dirname(args.output)
    if outdir:
        os.makedirs(outdir, exist_ok=True)
    _, ext = os.path.splitext(args.output)
    if ext == ".json":
        with open(args.output, "w") as f:
            json.dump(results, f, indent=2)
    elif ext == ".csv":
        all_rows = set()
        for col in results.values():
            all_rows.update(col.keys())
        all_rows = sorted(all_rows)
        columns = sorted(results.keys())
        with open(args.output, "w", newline="") as f:
            writer = csv.writer(f)
            # Write header
            writer.writerow([""] + columns)
            # Write each row
            for row_key in all_rows:
                row = [row_key]
                for col_key in columns:
                    row.append(results.get(col_key, {}).get(row_key, ""))
                writer.writerow(row)

    # signal failure to the caller (e.g. CI) without losing partial results
    if failures:
        print(f"\n{len(failures)} benchmark(s) failed: {', '.join(failures)}")
        return 1

    return 0


if __name__ == "__main__":
    sys.exit(main())
