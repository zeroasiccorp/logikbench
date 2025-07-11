#####################################################################
# Simple script that loops over benchmarks using
# a native yosys script running at the command line
#####################################################################
import argparse
import subprocess
import os
from pathlib import Path
from jinja2 import Environment, FileSystemLoader

if __name__ == "__main__":

    parser = argparse.ArgumentParser(description="""\

LogikBench bare metal usage example
-Calls tools using single file scripts
-No dependency on external run time infrastructures
Example Usage:
make.py -tool yosys -group epfl
""", formatter_class=argparse.RawDescriptionHelpFormatter)


    parser.add_argument("-tool",
                        choices=['yosys', 'vivado'],
                        required=True,
                        help="Synthesis tool")
    parser.add_argument("-group",
                       nargs='+',
                        required=True,
                        help="Benchmark group")
    parser.add_argument("-name",
                        nargs='+',
                        help="Benchmark name")

    args = parser.parse_args()

    # resolving relative path
    scriptdir = Path(__file__).resolve().parent
    rootdir = Path(__file__).resolve().parent.parent.parent

    # generated local script
    env = Environment(loader=FileSystemLoader('.'))
    template = env.get_template(f'{args.tool}_template.j2')

    # generic runtime script
    script = "run.tcl"

    # iterate over all groups
    for group in args.group:
        group_path = rootdir / "logikbench" / group
        if args.name:
           bench_list =args.name
        else:
           bench_list = [p.name for p in group_path.iterdir() if p.is_dir()]
        # iterate over all benchmarks in group
        for name in bench_list:

           os.makedirs(f"build/{group}/{name}", exist_ok=True)
           os.chdir(f"build/{group}/{name}")

           # create tool script
           output = template.render(context)
           with open(script, 'w') as f:
               f.write(output)

           # run tool
            try:
             result = subprocess.run(
                ["yosys", script],
                check=True,
                capture_output=True,
                text=True)
             print("Yosys output:")
             print(result.stdout)

          except subprocess.CalledProcessError as e:
             print("Yosys failed with error:")
             print(e.stderr)
             # go back home
             os.chdir(scriptdir)
