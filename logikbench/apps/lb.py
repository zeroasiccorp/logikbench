#!/usr/bin/env python3

import argparse
import subprocess
import os
import shutil
import sys
import json
import csv
from pathlib import Path
from jinja2 import Environment, FileSystemLoader

import logikbench as lb


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

    parser = argparse.ArgumentParser(description="""\
Simple LogikBench runner.
""", formatter_class=argparse.RawDescriptionHelpFormatter)

    parser.add_argument("-g", "--group",
                        nargs='+',
                        choices=all_groups,
                        metavar="GROUP",
                        required=True,
                        help=f"Benchmark group (choices: {all_groups})")

    parser.add_argument("-n", "--name",
                        nargs='+',
                        help="Benchmark name")

    parser.add_argument("-m", "--metric",
                        nargs='+',
                        default=["cells"],
                        choices=all_metrics,
                        metavar="METRIC",
                        help=f"Metrics to track (choices: {all_metrics})")

    parser.add_argument("-c", "--cmd",
                        choices=all_cmds,
                        default="synth_fpga",
                        metavar="CMD",
                        help=f"Synthesis command (choices: {all_cmds})")

    parser.add_argument("--part",
                        default=None,
                        help='FPGA part name (required for Vivado)')

    parser.add_argument("--opt",
                        default="",
                        help='Extra synthesis command options, as a quoted '
                             'string (e.g. --opt="-flatten -noabc9")')

    parser.add_argument("--tool",
                        choices=all_tools,
                        default="yosys",
                        metavar="TOOL",
                        help=f"Synthesis tool (choices: {all_tools})")

    parser.add_argument('--clean',
                        action='store_true',
                        help='Clean up build directory before running')

    parser.add_argument('-o', '--output',
                        default="build/results.json",
                        help='Output file name')

    args = parser.parse_args()

    # Error checking
    if args.tool == 'vivado' and args.part is None:
        print("Error: --part must be specified with the Vivado tool.")
        sys.exit(1)

    # resolving relative path
    cwd = os.getcwd()
    scriptdir = Path(lb.__file__).parent / "data" / "templates"

    # generated local script
    env = Environment(loader=FileSystemLoader(scriptdir))
    template = env.get_template(f'{args.tool}_template.j2')

    # get list of benchmarks (keyed by group, value is list of class names)
    benchmarks = {group: getattr(lb, group).__all__ for group in all_groups}

    # optional filter by benchmark name
    namefilter = set(n.lower() for n in args.name) if args.name else None

    # global analysis
    results = {metric: {} for metric in args.metric}

    # track failures so one bad benchmark does not abort the whole sweep
    failures = []

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

            if args.tool == 'yosys':
                script = f"{name}.ys"
                cmd = ['yosys', '-m', 'slang', '-m', 'wildebeest', '-s', script]
            elif args.tool == 'vivado':
                script = f"{name}.tcl"
                cmd = ['vivado', '-mode', 'batch', '-source', script]

            rundir = f"build/{group}/{name}"

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

                # create tool script
                context = {
                    'name': name,
                    'top': topmodule,
                    'filesetfile': filesetfile,
                    'cmd': args.cmd,
                    'options': args.opt,
                    'part': args.part,
                }
                output = template.render(context)
                with open(script, 'w') as f:
                    f.write(output)

                # run benchmark (skip if results already exist)
                if os.path.exists(f"{name}_stats.json"):
                    print(f"Found previous results, skipping {name} benchmark ({group}).")
                else:
                    print(f"Running {name} benchmark ({group}).")
                    print(f"Logfile: {rundir}/{name}.log")
                    try:
                        with open(f'{name}.log', "w") as log:
                            subprocess.run(cmd,
                                           stdout=log,
                                           stderr=subprocess.STDOUT,
                                           check=True)
                    except subprocess.CalledProcessError:
                        print(f"Error running {name} ({group}), see {rundir}/{name}.log")
                        failures.append(f"{group}/{name}")
                        continue

                # collect results (yosys only)
                if args.tool == 'yosys' and 'cells' in results:
                    with open(f"{name}_stats.json") as f:
                        data = json.load(f)
                    results["cells"][name] = data["design"]["num_cells"]
            finally:
                # always return to the original working directory
                os.chdir(cwd)

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
