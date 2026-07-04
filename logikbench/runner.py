"""Drive LogikBench benchmarks through SiliconCompiler.

This module is the public entry point: it assembles the full set of valid
targets and dispatches a single benchmark to the right flow. The flow
implementations live in sibling modules and are kept apart by run mode:
  * logikbench.fpga   -- the custom 'lbflow' FPGA synthesis path;
  * logikbench.asic   -- the 'lbflow' ASIC path and the SC path (targets
    built into SiliconCompiler, run through asicflow);
  * logikbench.common -- flow-agnostic plumbing (project setup, step ranges,
    manifest readers) shared by both.

Targets (--target) select what runs:
  * an FPGA target name (e.g. 'xilinx_virtex7') -> logikbench.fpga;
  * a lambdapdk PDK name (e.g. 'freepdk45') -> logikbench.asic lbflow path;
  * a '<pdk>_demo' name (e.g. 'asap7_demo') -> logikbench.asic SC path (a
    target built into SiliconCompiler).

The names re-exported below (metrics, targets, step names, DEFAULT_CLK_NS and
the manifest readers) are the stable interface used by lb, the dashboard, and
the scripts; import them from here rather than the submodules.
"""

import os
import shutil

from logikbench import asic, fpga
from logikbench.common import (
    FPGA_METRICS, ASIC_METRICS, STEPS, read_metrics, read_asic_metrics,
    read_tool_var, is_complete, clean_build, benchmark_name,
)
from logikbench.fpga import FPGA_TARGETS
from logikbench.asic import DEFAULT_CLK_NS

# Stable public interface (import these from here, not the submodules).
__all__ = [
    "FPGA_METRICS", "ASIC_METRICS", "STEPS", "DEFAULT_CLK_NS",
    "FPGA_TARGETS", "TARGETS", "LBFLOW_TARGETS",
    "run_one", "read_metrics", "read_asic_metrics", "read_tool_var",
    "is_complete", "clean_build", "benchmark_name",
]

# all valid --target values, in match order: FPGA '<vendor>_<part>', then SC
# built-in targets (verbatim, e.g. 'asap7_demo'), then LB bare-PDK names for the
# fast lbflow ASIC path (e.g. 'asap7', 'freepdk45').
TARGETS = (list(fpga.FPGA_TARGETS) + list(asic.SC_TARGETS)
           + list(asic._LBFLOW_PDKS))

LBFLOW_TARGETS = list(fpga.FPGA_TARGETS) + list(asic._LBFLOW_PDKS)


def run_one(group, item, target=None, options="", builddir="build", quiet=True,
            start=None, stop=None, timeout=None, clk=DEFAULT_CLK_NS):
    """Run a single benchmark; return (group, item, metrics, error).

    Dispatches on --target. Catches errors and returns them so a pool worker
    never crashes the parent. Module-level so it is picklable for the pool.
    'timeout' (seconds, or None) caps each step's wall clock; SC kills the tool
    tree on expiry and the step fails, so one hung synth cannot stall a sweep.
    'clk' is the ASIC clock period in ns for the generic SDC (ignored for FPGA
    targets).
    """
    import logikbench
    design = getattr(getattr(logikbench, group), item)()
    # key off the SC design name, not the class name: a class like EPFLArbiter
    # has design name 'epfl_arbiter', so item.lower() would not match its build
    # dir or recorded metrics.
    name = design.name
    # fresh run by default (avoids SC build reuse); keep the prior build only
    # when resuming mid-flow with --start, which needs earlier steps' outputs.
    # --stop alone still runs from the beginning, so it wipes.
    if not start:
        shutil.rmtree(os.path.join(builddir, name), ignore_errors=True)
    try:
        # match order: FPGA target, then SC built-in target (verbatim), then LB
        # bare-PDK name (fast lbflow ASIC path).
        if target in fpga.FPGA_TARGETS:
            fpga._run_fpga(design, target, options, builddir, quiet, start,
                           stop, timeout)
            metrics = read_metrics(name, FPGA_METRICS, builddir)
        elif target in asic.SC_TARGETS:
            asic._run_scflow(design, target, builddir, quiet, start, stop,
                             timeout, clk)
            metrics = read_metrics(name, ASIC_METRICS, builddir)
        elif target in asic._LBFLOW_PDKS:
            asic._run_lbflow(design, target, builddir, quiet, start, stop,
                             timeout, clk)
            metrics = read_metrics(name, ASIC_METRICS, builddir)
        else:
            raise ValueError(
                f"target '{target}' is not a known FPGA, SC, or LB target")
        return (group, item, metrics, None)
    except Exception as e:  # noqa: BLE001 - report to parent, keep the sweep going
        return (group, item, None, str(e))
