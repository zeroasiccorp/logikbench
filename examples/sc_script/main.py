import argparse
from pathlib import Path
import siliconcompiler
from siliconcompiler.targets import asap7_demo
from siliconcompiler.targets import skywater130_demo
from siliconcompiler.targets import freepdk45_demo

############################
# Run single file benchmark
############################
def run_benchmark(group, module, target=None, to=None):

    rootdir = Path(__file__).resolve().parent.parent.parent
    fname = rootdir / "logikbench" / group / module / "rtl" / f"{module}.v"

    c = siliconcompiler.Chip(module)

    if target:
        c.use(target)
    else:
        c.use(asap7_demo)
    c.input(fname)
    if to:
        c.set('option', 'to', to)
    c.set('option', 'quiet', True)
    c.run()
    c.summary()


if __name__ == "__main__":



    #########################
    # Run Basic Benchmarks
    #########################

    rootdir = Path(__file__).resolve().parent.parent.parent

    #group_list = ['basic']
    group_list = ['memory']
    #group_list = ['basic', 'memory']

    # iterate through groups
    for group in group_list:
        root_path = rootdir / "logikbench" / group
        bench_list = [p.name for p in root_path.iterdir() if p.is_dir()]
        # run benchmarks
        for item in bench_list:
            run_benchmark(group, item, to="syn")
        # collect results
        results = {}
        for item in bench_list:
            results[item] = {}
            c = siliconcompiler.Chip(item)
            c.read_manifest(f"build/{item}/job0/{item}.pkg.json")
            results[item]['cellarea'] = c.get('metric', 'cellarea', step="syn", index=0)
            print(f"{item} cellarea={results[item]['cellarea']}")

        # create pretty table
        for item in bench_list:
            pass

    #########################
    # Run Memory Benchmarks
    #########################
