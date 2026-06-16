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
    run_one, read_metrics, read_asic_metrics,
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

    # metrics depend on the flow; the union is the set of valid -m choices
    flow_metrics = {'fpga': METRICS, 'asic': ASIC_METRICS}
    all_metrics = list(dict.fromkeys(METRICS + ASIC_METRICS))

    #################################################
    # Commandline Interface
    #################################################

    # Arguments shared by all sub-commands.
    common = argparse.ArgumentParser(add_help=False)

    common.add_argument("-g", "--group",
                        nargs='+',
                        choices=all_groups,
                        metavar="GROUP",
                        default=all_groups,
                        help=f"Benchmark group(s); defaults to all "
                             f"(choices: {all_groups})")

    common.add_argument("-n", "--name",
                        nargs='+',
                        help="Benchmark name(s); defaults to all in the group")

    common.add_argument("-f", "--flow",
                        choices=all_flows,
                        default="fpga",
                        metavar="FLOW",
                        help=f"Synthesis flow (default: fpga; "
                             f"choices: {all_flows})")

    common.add_argument("-m", "--metric",
                        nargs='+',
                        default=None,
                        choices=all_metrics,
                        metavar="METRIC",
                        help="Metrics to track (default: all metrics for the "
                             f"selected flow; choices: {all_metrics})")

    common.add_argument('-b', '--builddir',
                        default="build",
                        metavar="DIR",
                        help='Build directory root; per-benchmark work goes in '
                             '<builddir>/<name> (default: build)')

    common.add_argument('-o', '--output',
                        default=None,
                        help='Output file name (default: '
                             '<builddir>/results.json)')

    parser = argparse.ArgumentParser(description="""\
Simple LogikBench runner.
""", formatter_class=argparse.RawDescriptionHelpFormatter)

    sub = parser.add_subparsers(dest="command",
                                required=True,
                                metavar="{run,collect}",
                                help="Sub-command to execute")

    # 'run' sub-command: synthesize benchmarks and collect metrics.
    prun = sub.add_parser("run",
                          parents=[common],
                          help="Synthesize benchmarks and collect metrics")

    prun.add_argument('-j', '--jobs',
                      type=int,
                      default=1,
                      metavar="N",
                      help='Number of benchmarks to synthesize in parallel '
                           '(default: 1)')

    prun.add_argument('--clean',
                      action='store_true',
                      help='Force a fresh synthesis (do not reuse prior runs)')

    prun.add_argument('--pdk',
                      choices=ASIC_PDKS,
                      default=ASIC_PDKS[0],
                      metavar="PDK",
                      help=f"Standard-cell library for the asic flow "
                           f"(default: {ASIC_PDKS[0]}; choices: {ASIC_PDKS}); "
                           f"ignored for the fpga flow")

    # 'collect' sub-command: gather metrics from existing build results.
    sub.add_parser("collect",
                   parents=[common],
                   help="Collect metrics from existing build results "
                        "(no synthesis)")

    args = parser.parse_args()

    #################################################
    # Setup
    #################################################

    # default the results file into the build directory
    if args.output is None:
        args.output = os.path.join(args.builddir, "results.json")

    # metrics default to the full set produced by the selected flow
    if args.metric is None:
        args.metric = flow_metrics[args.flow]

    # get list of benchmarks (keyed by group, value is list of class names)
    benchmarks = {group: getattr(lb, group).__all__ for group in all_groups}

    # optional filter by benchmark name
    namefilter = set(n.lower() for n in args.name) if args.name else None

    # global analysis
    results = {metric: {} for metric in args.metric}

    # track failures so one bad benchmark does not abort the whole sweep
    failures = []

    # work list of (group, class-name) honoring the group/name filters
    worklist = [(group, item)
                for group in args.group
                for item in benchmarks[group]
                if namefilter is None or item.lower() in namefilter]

    def store(group, item, metrics):
        name = item.lower()
        for metric in args.metric:
            results[metric][name] = metrics.get(metric)

    #################################################
    # Loop
    #################################################

    if args.command == 'run':
        # job-level parallelism: each benchmark is an independent SC run, so we
        # fan them out over a process pool (synthesis is the expensive part).
        if args.jobs > 1:
            with ProcessPoolExecutor(max_workers=args.jobs) as pool:
                futures = [pool.submit(run_one, group, item, args.flow,
                                       args.builddir, args.clean, args.pdk)
                           for group, item in worklist]
                for future in as_completed(futures):
                    group, item, metrics, error = future.result()
                    name = item.lower()
                    if error is not None:
                        print(f"Error synthesizing {name} ({group}): {error}")
                        failures.append(f"{group}/{name}")
                        continue
                    print(f"Finished {name} benchmark ({group}).")
                    store(group, item, metrics)
        else:
            for group, item in worklist:
                print(f"Running {item.lower()} benchmark ({group}).")
                _, _, metrics, error = run_one(group, item, args.flow,
                                               args.builddir, args.clean,
                                               args.pdk)
                if error is not None:
                    print(f"Error synthesizing {item.lower()} ({group}): {error}")
                    failures.append(f"{group}/{item.lower()}")
                    continue
                store(group, item, metrics)
    else:
        # 'collect': read existing metrics only, no synthesis (fast, serial)
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

    # collect coverage summary (count, not a line per missing benchmark)
    if args.command == 'collect':
        collected = set()
        for col in results.values():
            collected.update(col.keys())
        expected = sum(1 for g in args.group for it in benchmarks[g]
                       if namefilter is None or it.lower() in namefilter)
        print(f"Collected {len(collected)}/{expected} benchmark(s).")

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
