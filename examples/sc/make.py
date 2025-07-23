import argparse
import os
import sys
import json
import csv
from multiprocessing import Queue
from multiprocessing.pool import ThreadPool
from pathlib import Path
from siliconcompiler.flows import fpgaflow
from siliconcompiler import Chip
from logikbench import *


def peter_benchmarks():
    benchmarks = []
    with open("z1060_synth_only_logikbench_metrics_baseline_6lut.csv") as file:
        reader = csv.DictReader(file)
        for row in reader:
            benchmarks.append(row["benchmark"])
    return benchmarks


def run(args):
    # Error checking
    if args.tool == 'vivado' and args.target is None:
        print("Target must be specified with Vivado tool.")
        exit()

    # resolving relative path
    rootdir = Path(__file__).resolve().parent.parent.parent

    try:
        os.mkdir("build")
    except OSError:
        pass

    try:
        os.mkdir("build/cmdfile_dir")
    except OSError:
        pass

    # global analysis
    results = {}

    rslt_queue = Queue()

    pool = ThreadPool(processes=15)

    process_args = []

    # Get all groups
    for group in args.group:
        group_path = rootdir / "logikbench" / group
        if args.name:
            bench_list = args.name
        else:
            bench_list = sorted([p.name for p in group_path.iterdir() if p.is_dir()])

        # iterate over all benchmarks in group
        for name in bench_list:
            try:
                # instance of benchmark class
                mod = sys.modules[f"logikbench.{group}.{name}.{name}"]
                bobj = getattr(mod, name.capitalize())
                b = bobj()

                # TODO: switch to thread pool
                process_args.append((b, name, group, rslt_queue))
            except KeyError:
                pass

    pb = peter_benchmarks()
    process_args = [arg for arg in process_args if arg[1] in pb]
    print(process_args)
    assert (sorted([arg[1] for arg in process_args]) == sorted(pb)), "Missing benchmark that peter ran"

    for result in pool.starmap(run_synth, process_args):
        pass

    results = [rslt_queue.get() for _ in range(rslt_queue.qsize())]
    results = sorted(results, key=lambda r: r["group"] + r["name"] + r["syn_directive"])

    # writing results to file
    _, ext = os.path.splitext(args.output)
    if ext == ".json":
        with open(args.output, "w") as f:
            json.dump(results, f, indent=2)
    elif ext == ".csv":
        with open(args.output, "w", newline="") as f:
            writer = csv.writer(f)
            # Write header
            writer.writerow(list(results[0].keys()))
            # Write each row
            for result in results:
                writer.writerow(list(result.values()))


def run_synth(bench, name, group, rslt_queue):
    # get top module
    topmodule = bench.get_topmodule(fileset='rtl')

    # write out design fileset
    cmdfile = f"build/cmdfile_dir/{group}_{name}.f"
    bench.write_fileset(cmdfile, fileset='rtl')

    chip = Chip(topmodule)
    chip.import_flist(cmdfile)
    chip.use(fpgaflow, fpgaflow_type="vivado", partname="xc7a100tcsg324-1")
    chip.set("fpga", "partname", "xc7a100tcsg324-1")
    chip.set('option', 'flow', 'fpgaflow')
    chip.set('option', 'to', 'syn_fpga')

    synth_directives = ["AreaOptimized_high", "PerformanceOptimized"]

    for synth_directive in synth_directives:
        chip.set('option', 'jobname', group + "_" + name + "_" + synth_directive)
        chip.set('tool', 'vivado', 'task', 'syn_fpga', 'var', 'synth_directive', synth_directive)
        chip.dashboard(type="cli")
        assert chip.run()

        luts = chip.get("metric", "luts", step='syn_fpga', index=0)
        regs = chip.get("metric", "registers", step='syn_fpga', index=0)
        brams = chip.get("metric", "brams", step='syn_fpga', index=0)
        dsps = chip.get("metric", "dsps", step='syn_fpga', index=0)
        cpu = chip.get("metric", "exetime", step='syn_fpga', index=0)

        rslt_queue.put({
            "group": group,
            "name": name,
            "syn_directive": synth_directive,
            "luts": luts if luts else 0,
            "regs": regs if regs else 0,
            "dsps": dsps if dsps else 0,
            "brams": brams if brams else 0,
            "maxlvl": 0,
            "cpu": cpu
        })


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="""\

LogikBench bare metal usage example
-Runs using single file jinja script template
-No dependency on external run time infrastructures

Example Usage:
python make.py -tool yosys -target ice40 -group  epfl -name mem_ctrl

""", formatter_class=argparse.RawDescriptionHelpFormatter)

    parser.add_argument("-group", "-g",
                        nargs='+',
                        choices=['basic',
                                 'memory',
                                 'arithmetic',
                                 'epfl',
                                 'blocks'],
                        required=True,
                        help="Benchmark group")
    parser.add_argument("-name", "-n",
                        nargs='+',
                        help="Benchmark name")
    parser.add_argument("-tool",
                        choices=['yosys', 'vivado'],
                        default="yosys",
                        help="Tool name")
    parser.add_argument("-target",
                        help="Compilation target")
    parser.add_argument('-clean', '-c',
                        action='store_true',
                        help='Clean up build directory')
    parser.add_argument('-output', '-o',
                        default="build/results.json",
                        help='Output file name')

    args = parser.parse_args()
    run(args)
