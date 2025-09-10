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

#####################################################################
# Simple benchmark runner that calls EDA tools directly using
# scripts generated from simple Jinja templates.
#####################################################################

if __name__ == "__main__":

    print(os.path.dirname(lb.__file__))

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
                'synth_xilinx'],

    all_flows = ['syn',
                 'rtlgds',
                 'rtl2bits']

    # TODO: implement
    all_metrics = ['cells']

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
                        default="cells",
                        metavar="CMD",
                        help=f"Metrics to track (choices: {all_metrics}")

    parser.add_argument("-c", "--cmd",
                        choices=all_cmds,
                        default="synth_fpga",
                        metavar="CMD",
                        help=f"Synthesis command (choices: {all_cmds}")

    parser.add_argument("-part",
                        default="build/results.json",
                        help='Part name')

    parser.add_argument("-opt",
                        nargs='+',
                        help="Synthesis options")

    parser.add_argument("-tool",
                        choices=all_tools,
                        default="yosys",
                        metavar="TOOL",
                        help=f"Synthesis tool (choices: {all_tools})")

    parser.add_argument('-clean',
                        action='store_true',
                        help='Clean up build directory')

    parser.add_argument('-o', '--output',
                        default="build/results.json",
                        help='Output file name')

    args = parser.parse_args()

    # Error checking
    if args.tool == 'vivado' and args.target is None:
        print("Target must be specified with Vivado tool.")
        exit()

    # resolving relative path
    cwd = os.getcwd()
    scriptdir = Path(lb.__file__).parent / "data" / "templates"

    # generated local script
    env = Environment(loader=FileSystemLoader(scriptdir))
    template = env.get_template(f'{args.tool}_template.j2')

    # get list of benchmarks
    benchmarks = {}
    benchmarks['basic'] = lb.basic.__all__
    benchmarks['arithmetic'] = lb.arithmetic.__all__
    benchmarks['memory'] = lb.memory.__all__
    benchmarks['blocks'] = lb.blocks.__all__
    benchmarks['epfl'] = lb.epfl.__all__

    # global analysis
    results = {}
    results["cells"] = {}

    # iterate over all groups
    for group in args.group:
        bench_list = benchmarks[group]
        # iterate over all benchmarks in group
        for item in bench_list:
            name = item.lower()
            if args.tool == 'yosys':
                script = f"{name}.ys"
                cmd = ['yosys', '-m', 'slang', '-m', 'yosys-syn', '-s', script]
            elif args.tool == 'vivado':
                script = f"{name}.tcl"
                cmd = ['vivado', '-mode', 'batch', '-source', script]

            # clean up old results
            if os.path.isdir(f"build/{group}/{name}"):
                if args.clean:
                    shutil.rmtree(f"build/{group}/{name}")

            # change dir
            os.makedirs(f"build/{group}/{name}", exist_ok=True)
            os.chdir(f"build/{group}/{name}")

            # instance of benchmark class
            mod = sys.modules[f"logikbench.{group}.{name}.{name}"]
            bobj = getattr(mod, name.capitalize())
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
            }
            output = template.render(context)
            with open(script, 'w') as f:
                f.write(output)

            # run benchmark
            if os.path.exists(f"{name}_stats.json"):
                print(f"Found previous results, skipping {name} benchmark ({group}).")
            else:
                try:
                    print(f"Running {name} benchmark ({group}).")
                    print(f"Logfile: build/{group}/{name}/{name}.log")
                    with open(f'{name}.log', "w") as log:
                        result = subprocess.run(cmd,
                                                stdout=log,
                                                stderr=subprocess.STDOUT,
                                                check=True)

                except subprocess.CalledProcessError:
                    print("Error...see logfile!!")
                    sys.exit()

            # collect results
            if args.tool == 'yosys':
                with open(f"{name}_stats.json") as f:
                    data = json.load(f)
                results["cells"][name] = data["design"]["num_cells"]

            # go back to cwd
            os.chdir(cwd)

    # writing results to file
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
