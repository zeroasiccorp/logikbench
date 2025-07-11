#####################################################################
# Simple script that loops over benchmarks using
# a native yosys script running at the command line
#####################################################################
import argparse
import subprocess
import os
import sys
from pathlib import Path
from jinja2 import Environment, FileSystemLoader
from logikbench import *

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="""\

LogikBench bare metal usage example
-Calls tools using single file scripts
-No dependency on external run time infrastructures
Example Usage:
make.py -tool yosys -group epfl
""", formatter_class=argparse.RawDescriptionHelpFormatter)

    parser.add_argument("-group",
                        nargs='+',
                        required=True,
                        help="Benchmark group")
    parser.add_argument("-name",
                        nargs='+',
                        help="Benchmark name")
    parser.add_argument("-tool",
                        choices=['yosys', 'vivado'],
                        required=True,
                        help="Benchmark tool")
    parser.add_argument("-target",
                        choices=['ice40'],
                        required=True,
                        help="Benchmark target")


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
            bench_list = [p.name for p in group_path.iterdir() if p.is_dir()]

        # iterate over all benchmarks in group
        for name in bench_list:
            if args.tool == 'yosys':
                script = f"{name}.ys" # yosys corner case
            else:
                script = f"{name}.tcl"

            # get top module
            # TODO: find module by string?
            # TODO: generalize
            mod = sys.modules["logikbench.basic.binv.binv"]
            cls = getattr(mod, "Binv")
            d = cls()
            print(d.get_topmodule(fileset='rtl'))

            mod = importlib.import_module("logikbench.basic.binv.binv")
            cls = getattr(mod, "Binv")
            d = cls()
            print(d.get_topmodule(fileset='rtl'))

            # create run dir
            os.makedirs(f"build/{group}/{name}", exist_ok=True)
            os.chdir(f"build/{group}/{name}")
            filename = group_path / name / "rtl" / f"{name}.v"

            # create tool script
            context = {
                'name': name,
                'top': topmodule,
                'filename': filename,
                'target': args.target,
            }
            output = template.render(context)
            with open(script, 'w') as f:
                f.write(output)

            # run benchmark
            try:
                print(f"Running {name} benchmark in group '{group}'. Lofile: build/{group}/{name}/{name}.log")
                with open(f'{name}.log', "w") as log:
                          result = subprocess.run([args.tool, script],
                                        stdout=log,
                                        stderr=subprocess.STDOUT,
                                        check=True)

            except subprocess.CalledProcessError as e:
                print(f"Error...see logfile!!")

            # go back home
            os.chdir(scriptdir)
