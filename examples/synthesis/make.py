import argparse
import subprocess
import os
import shutil
import sys
import json
import csv
from pathlib import Path
from jinja2 import Environment, FileSystemLoader
from logikbench import *

#####################################################################
# Simple benchmark runner that calls EDA tools directly using
# scripts generated from simple Jinja templates.
#####################################################################

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="""\

LogikBench bare metal usage example
-Runs using single file jinja script template
-No dependency on external run time infrastructures

Example Usage:
python make.py -tool yosys -target ice40 -group  epfl -name mem_ctrl

""", formatter_class=argparse.RawDescriptionHelpFormatter)

    parser.add_argument("-group","-g",
                        nargs='+',
                        choices=['basic',
                                 'memory',
                                 'arithmetic',
                                 'epfl',
                                 'blocks'],
                        required=True,
                        help="Benchmark group")
    parser.add_argument("-name","-n",
                        nargs='+',
                        help="Benchmark name")
    parser.add_argument("-tool",
                        choices=['yosys', 'vivado'],
                        default="yosys",
                        help="Tool name")
    parser.add_argument("-target",
                        help="Compilation target")
    parser.add_argument('-clean','-c',
                        action='store_true',
                        help='Clean up build directory')
    parser.add_argument('-output','-o',
                        default="build/results.json",
                        help='Output file name')

    args = parser.parse_args()

    # Error checking
    if args.tool == 'vivado' and args.target is None:
        print("Target must be specified with Vivado tool.")
        exit()

    # resolving relative path
    cwd = os.getcwd()
    scriptdir = Path(__file__).resolve().parent
    rootdir = Path(__file__).resolve().parent.parent.parent

    # generated local script
    env = Environment(loader=FileSystemLoader(scriptdir))
    template = env.get_template(f'{args.tool}_template.j2')

    # global analysis
    results = {}
    results["cells"] = {}

    # iterate over all groups
    for group in args.group:
        group_path = rootdir / "logikbench" / group
        if args.name:
            bench_list = args.name
        else:
            bench_list = sorted([p.name for p in group_path.iterdir() if p.is_dir()])

        # iterate over all benchmarks in group
        for name in bench_list:
            if args.tool == 'yosys':
                script = f"{name}.ys" # yosys corner case
                cmd = ['yosys', '-m', 'slang', '-s', script]
            elif args.tool == 'vivado':
                script = f"{name}.tcl"
                cmd = ['vivado', '-mode', 'batch', '-source', script]

            # clean up old results
            if os.path.isdir(f"build/{group}/{name}"):
                if args.clean: # create run dir.clean:
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
            cmdfile = f"{name}.f"
            b.write_fileset(cmdfile, fileset='rtl')

            # create tool script
            context = {
                'name': name,
                'top': topmodule,
                'cmdfile': cmdfile,
                'target': args.target,
            }
            output = template.render(context)
            with open(script, 'w') as f:
                f.write(output)

            # run benchmark
            if os.path.exists(f"{name}_stats.json"):
                    print(f"Found previous results, skipping {name} benchmark ({group}).")
            else:
                try:
                    print(f"Running {name} benchmark ({group}). Logfile: build/{group}/{name}/{name}.log")
                    with open(f'{name}.log', "w") as log:
                        result = subprocess.run(cmd,
                                                stdout=log,
                                                stderr=subprocess.STDOUT,
                                                check=True)

                except subprocess.CalledProcessError as e:
                    print(f"Error...see logfile!!")
                    exit()

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
