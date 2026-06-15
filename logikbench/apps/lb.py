#!/usr/bin/env python3

import argparse
import subprocess
import os
import shutil
import sys
import json
import csv
from pathlib import Path

import logikbench as lb


def collect_stats(statsfile, name, tool, results):
    """Read a tool stats file and record the requested metrics."""
    if tool == 'yosys' and 'cells' in results:
        with open(statsfile) as f:
            data = json.load(f)
        results["cells"][name] = data["design"]["num_cells"]


def main():

    #################################################
    # Scope
    #################################################

    all_groups = ['basic',
                  'memory',
                  'arithmetic',
                  'epfl',
                  'blocks']

    all_tools = ['yosys',
                 'vivado']

    all_cmds = ['synth_fpga',
                'synth_efinix',
                'synth_ice40',
                'synth_microchip',
                'synth_quicklogic',
                'synth_xilinx']

    # TODO: implement
    all_metrics = ['cells']

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

    common.add_argument("-m", "--metric",
                        nargs='+',
                        default=["cells"],
                        choices=all_metrics,
                        metavar="METRIC",
                        help=f"Metrics to track (choices: {all_metrics})")

    common.add_argument("-t", "--tool",
                        choices=all_tools,
                        default="yosys",
                        metavar="TOOL",
                        help=f"Synthesis tool (default: yosys; "
                             f"choices: {all_tools})")

    common.add_argument('-o', '--output',
                        default="build/results.json",
                        help='Output file name (default: build/results.json)')

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

    prun.add_argument('-s', '--script',
                      required=True,
                      metavar="PATH",
                      help='Path to the synthesis script (TCL), e.g. '
                           'results/fpga/zeroasic/synth.tcl. It should '
                           'source the generated params.tcl for per-benchmark '
                           'values (top, fileset, name, cmd, options, part)')

    prun.add_argument("-c", "--cmd",
                      choices=all_cmds,
                      default="synth_fpga",
                      metavar="CMD",
                      help=f"Synthesis command (default: synth_fpga; "
                           f"choices: {all_cmds})")

    prun.add_argument("--part",
                      default=None,
                      help='FPGA part name (required for Vivado)')

    prun.add_argument("--opt",
                      default="",
                      help='Extra synthesis command options, as a quoted '
                           'string (e.g. --opt="-opt area")')

    prun.add_argument('--clean',
                      action='store_true',
                      help='Clean up build directory before running')

    prun.add_argument('--timeout',
                      type=int,
                      default=0,
                      help='Per-benchmark timeout in seconds (0 = no limit)')

    # 'collect' sub-command: gather metrics from existing build results.
    sub.add_parser("collect",
                   parents=[common],
                   help="Collect metrics from existing build results "
                        "(no synthesis)")

    args = parser.parse_args()

    #################################################
    # Setup
    #################################################

    cwd = os.getcwd()

    # get list of benchmarks (keyed by group, value is list of class names)
    benchmarks = {group: getattr(lb, group).__all__ for group in all_groups}

    # optional filter by benchmark name
    namefilter = set(n.lower() for n in args.name) if args.name else None

    # global analysis
    results = {metric: {} for metric in args.metric}

    # track failures so one bad benchmark does not abort the whole sweep
    failures = []

    # 'run'-only validation and synthesis script resolution
    if args.command == 'run':
        if args.tool == 'vivado' and args.part is None:
            print("Error: --part must be specified with the Vivado tool.")
            sys.exit(1)
        # resolved to absolute, since the loop chdir's into build directories
        scriptpath = Path(args.script).resolve()
        if not scriptpath.is_file():
            print(f"Error: synthesis script not found: {args.script}")
            sys.exit(1)

    #################################################
    # Loop
    #################################################

    # iterate over all groups
    for group in args.group:
        bench_list = benchmarks[group]
        # iterate over all benchmarks in group
        for item in bench_list:
            name = item.lower()

            # optional name filter
            if namefilter is not None and name not in namefilter:
                continue

            rundir = f"build/{group}/{name}"
            statsfile = f"{name}_stats.json"

            # 'collect': read existing stats only, no synthesis
            if args.command == 'collect':
                statspath = os.path.join(rundir, statsfile)
                if not os.path.isfile(statspath):
                    print(f"No results for {name} benchmark ({group}), "
                          f"skipping.")
                    continue
                collect_stats(statspath, name, args.tool, results)
                continue

            # 'run': synthesize the benchmark
            if args.tool == 'yosys':
                cmd = ['yosys', '-c', str(scriptpath)]
            elif args.tool == 'vivado':
                cmd = ['vivado', '-mode', 'batch', '-source', str(scriptpath)]

            # clean up old results
            if args.clean and os.path.isdir(rundir):
                shutil.rmtree(rundir)

            os.makedirs(rundir, exist_ok=True)
            os.chdir(rundir)
            try:
                # instance of benchmark class (class name comes from __all__)
                bobj = getattr(getattr(lb, group), item)
                b = bobj()

                # get top module
                topmodule = b.get_topmodule(fileset='rtl')

                # write out design fileset
                filesetfile = f"{name}.f"
                b.write_fileset(filesetfile, fileset='rtl')

                # per-benchmark parameters written to a TCL file that the
                # synthesis script sources (cwd is the per-benchmark build dir)
                with open('params.tcl', 'w') as p:
                    p.write("# Auto-generated by lb; sourced by the "
                            "synthesis script.\n")
                    p.write(f"set top {{{topmodule}}}\n")
                    p.write(f"set fileset {{{filesetfile}}}\n")
                    p.write(f"set name {{{name}}}\n")
                    p.write(f"set cmd {{{args.cmd}}}\n")
                    p.write(f"set options {{{args.opt}}}\n")
                    p.write(f"set part {{{args.part or ''}}}\n")

                # run benchmark (skip if results already exist)
                if os.path.exists(statsfile):
                    print(f"Found previous results, skipping {name} "
                          f"benchmark ({group}).")
                else:
                    print(f"Running {name} benchmark ({group}).")
                    print(f"Logfile: {rundir}/{name}.log")
                    try:
                        with open(f'{name}.log', "w") as log:
                            subprocess.run(cmd,
                                           stdout=log,
                                           stderr=subprocess.STDOUT,
                                           check=True,
                                           timeout=args.timeout or None)
                    except subprocess.CalledProcessError:
                        print(f"Error running {name} ({group}), see "
                              f"{rundir}/{name}.log")
                        failures.append(f"{group}/{name}")
                        continue
                    except subprocess.TimeoutExpired:
                        print(f"Timeout ({args.timeout}s) running {name} "
                              f"({group}), see {rundir}/{name}.log")
                        failures.append(f"{group}/{name} (timeout)")
                        continue

                # collect results
                collect_stats(statsfile, name, args.tool, results)
            finally:
                # always return to the original working directory
                os.chdir(cwd)

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
