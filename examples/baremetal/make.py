import argparse
import subprocess
import os
import sys
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

    parser.add_argument("-group",
                        nargs='+',
                        choices=['basic', 'memory', 'arithmetic', 'epfl', 'block'],
                        required=True,
                        help="Benchmark group")
    parser.add_argument("-name",
                        nargs='+',
                        help="Benchmark name")
    parser.add_argument("-tool",
                        choices=['yosys', 'vivado'],
                        required=True,
                        help="Tool name")
    parser.add_argument("-target",
                        required=True,
                        help="Compilation target")

    args = parser.parse_args()

    # resolving relative path
    scriptdir = Path(__file__).resolve().parent
    rootdir = Path(__file__).resolve().parent.parent.parent

    # generated local script
    env = Environment(loader=FileSystemLoader('.'))
    template = env.get_template(f'{args.tool}_template.j2')

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
                cmd = ['vivado', '-mode batch', '-source', script]

            # create run dir
            os.makedirs(f"build/{group}/{name}", exist_ok=True)
            os.chdir(f"build/{group}/{name}")

            # get top module (not always equal to module name)
            mod = sys.modules[f"logikbench.{group}.{name}.{name}"]
            cls = getattr(mod, name.capitalize())
            d = cls()
            topmodule = d.get_topmodule(fileset='rtl')

            # write out fileset locally
            cmdfile = f"{name}.f"
            d.write_fileset(cmdfile, fileset='rtl')

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
            try:
                print(f"Running {name} benchmark ({group}). Logfile: build/{group}/{name}/{name}.log")
                with open(f'{name}.log', "w") as log:
                          result = subprocess.run(cmd,
                                        stdout=log,
                                        stderr=subprocess.STDOUT,
                                        check=True)

            except subprocess.CalledProcessError as e:
                print(f"Error...see logfile!!")

            # go back home
            os.chdir(scriptdir)
