"""Drive LogikBench benchmarks through SiliconCompiler.

This module is the public entry point: it assembles the full set of valid
targets and dispatches a single benchmark to the right flow. The flow
implementations live in sibling modules and are kept apart by run mode:
  * logikbench.fpga   -- the custom 'lbflow' FPGA synthesis path;
  * logikbench.asic   -- the 'lbflow' ASIC path and the SC path (targets
    built into SiliconCompiler, run through asicflow);
  * logikbench.common -- flow-agnostic plumbing (project setup, step ranges,
    manifest readers) shared by both.

Targets (--target) are named '<tool>_<part>' and select what runs:
  * an FPGA target (e.g. 'xilinx_virtex7') -> logikbench.fpga;
  * 'yosys_<pdk>' / 'tardigrade_<pdk>' (e.g. 'yosys_freepdk45') ->
    logikbench.asic lbflow path (mapper chosen by the tool prefix);
  * 'sc_<pdk>' (e.g. 'sc_asap7') -> logikbench.asic SC asicflow path (a
    target built into SiliconCompiler).

The names re-exported below (metrics, targets, step names and the manifest
readers) are the stable interface used by lb, the dashboard, and the scripts;
import them from here rather than the submodules.
"""

import os
import shutil

from logikbench import asic, fpga
from logikbench.common import (
    FPGA_METRICS, ASIC_METRICS, STEPS, read_metrics, read_asic_metrics,
    read_tool_var, is_complete, clean_build,
)
from logikbench.fpga import FPGA_TARGETS

# Stable public interface (import these from here, not the submodules).
__all__ = [
    "FPGA_METRICS", "ASIC_METRICS", "STEPS",
    "FPGA_TARGETS", "SC_TARGETS", "YOSYS_TARGETS", "TARDIGRADE_TARGETS",
    "TARGETS",
    "run_one", "read_metrics", "read_asic_metrics", "read_tool_var",
    "is_complete", "clean_build",
]

# ASIC target sets by tool, all '<tool>_<pdk>' (defined in logikbench.asic):
#   SC_TARGETS          'sc_<pdk>'         -> SC asicflow (through P&R)
#   YOSYS_TARGETS       'yosys_<pdk>'      -> lbflow: yosys synth + STA
#   TARDIGRADE_TARGETS  'tardigrade_<pdk>' -> lbflow: tardigrade synth + STA
# yosys and tardigrade run the same lbflow path; they differ only in the mapper.
SC_TARGETS = list(asic.SC_TARGETS)
YOSYS_TARGETS = list(asic.YOSYS_TARGETS)
TARDIGRADE_TARGETS = list(asic.TARDIGRADE_TARGETS)

# all valid --target values, all '<tool>_<part>': FPGA '<vendor>_<part>', then
# the ASIC sets (sc asicflow, yosys lbflow, tardigrade lbflow).
TARGETS = (list(fpga.FPGA_TARGETS) + SC_TARGETS + YOSYS_TARGETS
           + TARDIGRADE_TARGETS)


def run_one(design_cls, target=None, options="", builddir="build", quiet=True,
            start=None, stop=None, timeout=None, clk=None, lintonly=False):
    """Run a single benchmark class; return (metrics, error).

    'design_cls' is the benchmark's Design subclass (resolved by the caller); it
    is instantiated here. Dispatches on --target. Catches errors and returns
    them so a pool worker never crashes the parent. Module-level so it is
    picklable for the pool. 'timeout' (seconds, or None) caps each step's wall
    clock; SC kills the tool tree on expiry and the step fails, so one hung
    synth cannot stall a sweep. 'clk' is the ASIC clock period in ns for the
    generic SDC (None -> use each PDK's tech.tcl default; ignored for FPGA
    targets).
    """
    design = design_cls()
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
        # match by '<tool>_<part>': FPGA target, then 'sc_<pdk>' (asicflow),
        # then 'yosys_<pdk>'/'tardigrade_<pdk>' (lbflow, mapper from the name).
        if target in fpga.FPGA_TARGETS:
            fpga._run_fpga(design, target, options, builddir, quiet, start,
                           stop, timeout, lintonly=lintonly)
            metrics = {} if lintonly else read_metrics(name, FPGA_METRICS,
                                                       builddir)
        elif target in asic.SC_TARGETS:
            asic._run_scflow(design, target, builddir, quiet, start, stop,
                             timeout, clk, lintonly=lintonly)
            metrics = {} if lintonly else read_metrics(name, ASIC_METRICS,
                                                       builddir)
        elif target in asic.YOSYS_TARGETS or target in asic.TARDIGRADE_TARGETS:
            asic._run_lbflow(design, target, options, builddir, quiet, start,
                             stop, timeout, clk, lintonly=lintonly)
            metrics = {} if lintonly else read_metrics(name, ASIC_METRICS,
                                                       builddir)
        else:
            raise ValueError(
                f"target '{target}' is not a known FPGA, SC, or LB target")
        return (metrics, None)
    except Exception as e:  # noqa: BLE001 - report to parent, keep the sweep going
        return (None, str(e))
