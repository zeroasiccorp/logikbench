import os
import sys
import csv
import argparse
from pathlib import Path
from multiprocessing.pool import ThreadPool
from dataclasses import dataclass
from typing import List, Any

from siliconcompiler import Chip
from siliconcompiler.flows import fpgaflow

from logikbench import *

from parse_verilog_ports import extract_modules_from_file
from gen_verilog_wrapper import gen_verilog_wrapper


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


def load_benchmark(group, name):
    bench = None
    try:
        # instance of benchmark class
        mod = sys.modules[f"logikbench.{group}.{name}.{name}"]
        bobj = getattr(mod, name.capitalize())
        bench = bobj()
        return bench
    except (KeyError, NotImplementedError):
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


def synth_vivado(
        benchmark: BenchmarkMetaData,
        synth_directive: str,
        partname: str = "xc7a100tcsg324-1"):
    # get top module
    topmodule = benchmark.bench_obj.get_topmodule(fileset='rtl')

    # write out design fileset
    cmdfile = f"build/cmdfile_dir/{benchmark.group}_{benchmark.name}.f"
    benchmark.bench_obj.write_fileset(cmdfile, fileset='rtl')

    top_wrapper_module_name = f"{benchmark.group}_{benchmark.name}_{synth_directive}_top"

    chip = Chip(top_wrapper_module_name)

    chip.import_flist(cmdfile)

    ##############################################
    # Create top level wrapper
    ##############################################

    # Find source file with top level module
    top_level_verilog_file = None
    print(f"{chip.find_files('input', 'rtl', 'verilog')}")
    for verilog_file in chip.find_files('input', 'rtl', 'verilog'):
        print(f"looking in verilog file {verilog_file}")
        if topmodule in extract_modules_from_file(filepath=verilog_file):
            top_level_verilog_file = verilog_file
            break
    assert top_level_verilog_file is not None, f"Error, Could not find top level module '{topmodule}'"

    top_wrapper_path = f"build/verilog_wrapper_dir/{top_wrapper_module_name}.v"
    gen_verilog_wrapper(
        top_level_module=topmodule,
        wrapper_module_name=top_wrapper_module_name,
        input_file=Path(top_level_verilog_file),
        output_file=Path(top_wrapper_path)
    )

    chip.import_flist(cmdfile)
    chip.input(top_wrapper_path)
    chip.input("synth_const.xdc")

    chip.use(fpgaflow, fpgaflow_type="vivado", partname=partname)
    chip.set("fpga", "partname", partname)
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


def run_benchmarks(groups: List[str], names: List[str] = None, parallel: bool = True):
    make_dirs()

    for group in groups:
        for synth_directive in ["PerformanceOptimized", "AreaOptimized_high"]:
            benchmarks = load_benchmark_group(group)

            # Filter by names of benchmarks if provided
            if names:
                benchmarks = [bench for bench in benchmarks if bench.name in names]

            results = []

            if parallel:
                pool = ThreadPool(processes=10)
                results = [result.synth_results for result in pool.starmap(
                    synth_vivado,
                    [(bench, synth_directive) for bench in benchmarks]
                )]
            else:
                for bench in benchmarks:
                    results.append(synth_vivado(bench, synth_directive))

            write_dict_as_csv(f"{group}_{synth_directive}_results.csv", results)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="""\

LogikBench silicon compiler usage example

Example Usage:
python make.py -group basic arithmetic

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
    args = parser.parse_args()
    run_benchmarks(args.group, args.name)
