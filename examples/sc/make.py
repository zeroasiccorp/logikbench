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
from typing import List, Any
from dataclasses import dataclass


@dataclass
class BenchmarkMetaData:
    group: str
    name: str
    bench_obj: Any
    synth_results: Any = None


def write_dict_as_csv(filename, data):
    # writing results to file
    with open(filename, "w", newline="") as f:
        writer = csv.writer(f)
        # Write header
        writer.writerow(list(data[0].keys()))
        # Write each row
        for result in data:
            writer.writerow(list(result.values()))


def filter_for_benchmarks_peter_cares_about(
        benchmarks: List[BenchmarkMetaData]) -> List[BenchmarkMetaData]:
    benchmark_names = []
    with open("z1060_synth_only_logikbench_metrics_baseline_6lut.csv") as file:
        reader = csv.DictReader(file)
        for row in reader:
            benchmark_names.append(row["benchmark"])

    return [b for b in benchmarks if b.name in benchmark_names]


def load_benchmark(group, name):
    bench = None
    try:
        # instance of benchmark class
        mod = sys.modules[f"logikbench.{group}.{name}.{name}"]
        bobj = getattr(mod, name.capitalize())
        bench = bobj()
        return bench
    except KeyError:
        return None


def load_benchmark_group(group: str) -> List[BenchmarkMetaData]:

    rootdir = Path(__file__).resolve().parent.parent.parent

    benchmarks = []
    group_path = rootdir / "logikbench" / group
    bench_list = sorted([p.name for p in group_path.iterdir() if p.is_dir()])

    # iterate over all benchmarks in group
    for name in bench_list:
        bench = load_benchmark(group, name)
        if bench:
            benchmarks.append(BenchmarkMetaData(
                group=group,
                name=name,
                bench_obj=bench
            ))
    return benchmarks


def load_all_benchmarks() -> List[BenchmarkMetaData]:
    groups = ["arithmetic", "basic", "blocks", "epfl", "memory"]
    benchmarks = []
    for group in groups:
        benchmarks.extend(load_benchmark_group(group))
    return benchmarks


def peter_run():
    try:
        os.mkdir("build")
    except OSError:
        pass

    try:
        os.mkdir("build/cmdfile_dir")
    except OSError:
        pass

    pool = ThreadPool(processes=15)

    benchmarks = load_all_benchmarks()

    benchmarks = filter_for_benchmarks_peter_cares_about(benchmarks)

    for synth_directive in ["AreaOptimized_high", "PerformanceOptimized"]:
        results = [result.synth_results for result in pool.starmap(
            synth_vivado,
            [(bench, synth_directive) for bench in benchmarks]
        )]
        write_dict_as_csv(f"{synth_directive}_results.csv", results)


def make_dirs():
    dirs = [
        "build",
        "build/cmdfile_dir",
        "build/verilog_wrapper_dir",
    ]
    for d in dirs:
        try:
            os.mkdir(d)
        except OSError:
            pass


def thierry_run():
    make_dirs()

    pool = ThreadPool(processes=15)

    for group in ["arithmetic"]:
        benchmarks = load_benchmark_group(group)
        for synth_directive in ["AreaOptimized_high", "PerformanceOptimized"]:
            results = [result.synth_results for result in pool.starmap(
                synth_vivado,
                [(bench, synth_directive) for bench in benchmarks]
            )]
            write_dict_as_csv(f"{group}_{synth_directive}_results.csv", results)


def rice_run():
    make_dirs()

    pool = ThreadPool(processes=15)

    for group in ["basic"]:
        benchmarks = load_benchmark_group(group)
        for synth_directive in ["AreaOptimized_high", "PerformanceOptimized"]:
            results = [result.synth_results for result in pool.starmap(
                synth_vivado,
                [(bench, synth_directive) for bench in benchmarks]
            )]
            write_dict_as_csv(f"{group}_{synth_directive}_results.csv", results)


def aes():
    make_dirs()

    pool = ThreadPool(processes=15)

    for group in ["blocks"]:
        benchmarks = load_benchmark_group(group)
        for synth_directive in ["AreaOptimized_high"]:
            results = [result.synth_results for result in pool.starmap(
                synth_vivado,
                [(bench, synth_directive) for bench in benchmarks if bench.name == "aes"]
            )]
            write_dict_as_csv(f"{group}_{synth_directive}_results.csv", results)


def synth_vivado(benchmark: BenchmarkMetaData, synth_directive: str):
    # get top module
    topmodule = benchmark.bench_obj.get_topmodule(fileset='rtl')

    # write out design fileset
    cmdfile = f"build/cmdfile_dir/{benchmark.group}_{benchmark.name}.f"
    benchmark.bench_obj.write_fileset(cmdfile, fileset='rtl')

    top_wrapper_module_name = f"{benchmark.group}_{benchmark.name}_{synth_directive}_top"
    top_wrapper_path = f"build/verilog_wrapper_dir/{top_wrapper_module_name}.v"
    wrapper = f"""
        module {top_wrapper_module_name}();
            (* DONT_TOUCH = "TRUE" *)
            {topmodule} {topmodule}_inst();
        endmodule

    """

    with open(top_wrapper_path, "w") as f:
        f.write(wrapper)

    chip = Chip(top_wrapper_module_name)

    chip.import_flist(cmdfile)
    chip.input("synth_const.xdc")
    chip.input(top_wrapper_path)

    chip.use(fpgaflow, fpgaflow_type="vivado", partname="xc7a100tcsg324-1")
    chip.set("fpga", "partname", "xc7a100tcsg324-1")
    chip.set('option', 'flow', 'fpgaflow')
    chip.set('option', 'to', 'syn_fpga')

    chip.set('option', 'jobname', benchmark.group + "_" + benchmark.name + "_" + synth_directive)
    chip.set('tool', 'vivado', 'task', 'syn_fpga', 'var', 'synth_directive', synth_directive)
    chip.dashboard(type="cli")
    if chip.run():
        luts = chip.get("metric", "luts", step='syn_fpga', index=0)
        regs = chip.get("metric", "registers", step='syn_fpga', index=0)
        brams = chip.get("metric", "brams", step='syn_fpga', index=0)
        dsps = chip.get("metric", "dsps", step='syn_fpga', index=0)
        cpu = chip.get("metric", "exetime", step='syn_fpga', index=0)

        benchmark.synth_results = {
            "name": benchmark.name,
            "luts": luts if luts else 0,
            "regs": regs if regs else 0,
            "dsps": dsps if dsps else 0,
            "brams": brams if brams else 0,
            "maxlvl": 0,
            "cpu": cpu
        }
    else:
        benchmark.synth_results = {
            "name": benchmark.name,
            "luts": 0,
            "regs": 0,
            "dsps": 0,
            "brams": 0,
            "maxlvl": 0,
            "cpu": 0
        }

    return benchmark


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="""\

LogikBench bare metal usage example
-Runs using single file jinja script template
-No dependency on external run time infrastructures

Example Usage:
python make.py -target xc7a100tcsg423-1 -group basic -name arbiter

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
    parser.add_argument("-target",
                        help="Compilation target")
    parser.add_argument('-output', '-o',
                        default="build/results.csv",
                        help='Output file name')

    args = parser.parse_args()
    run(None, None)
