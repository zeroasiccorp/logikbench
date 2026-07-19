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
  * an FPGA part (e.g. 'virtex7') -> logikbench.fpga;
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
from math import prod

from logikbench import asic, fpga
from logikbench.common import (
    FPGA_METRICS, ASIC_METRICS, STEPS, read_metrics, read_asic_metrics,
    read_tool_var, read_flow_tools, read_metric_units, is_complete, clean_build,
    write_netlist_cache, read_netlist_cache, netlist_cache_path,
)
from logikbench.fpga import FPGA_TARGETS

# Stable public interface (import these from here, not the submodules).
__all__ = [
    "FPGA_METRICS", "ASIC_METRICS", "STEPS",
    "FPGA_TARGETS", "SC_TARGETS", "YOSYS_TARGETS", "TARDIGRADE_TARGETS",
    "STA_TARGETS", "TARGETS",
    "run_one", "run_task", "read_metrics", "read_asic_metrics",
    "read_tool_var", "read_flow_tools", "read_metric_units",
    "is_complete", "clean_build",
    "write_netlist_cache", "read_netlist_cache", "netlist_cache_path",
    "variant_combos",
]


def variant_combos(design):
    """Number of design variants a full sweep produces: the cross product of the
    swept value lists declared in design.variants. Coupled or derived parameters
    (e.g. a multiplier's OW = 2*DW) are not listed there, so they do not inflate
    the count. Returns 1 when the design declares no variants, so callers can
    size or estimate a run before launching it.
    """
    variants = getattr(design, "variants", {})
    return prod(len(values) for values in variants.values())


# ASIC target sets by tool, all '<tool>_<pdk>' (defined in logikbench.asic):
#   SC_TARGETS          'sc_<pdk>'         -> SC asicflow (through P&R)
#   YOSYS_TARGETS       'yosys_<pdk>'      -> lbflow: yosys synth + STA
#   TARDIGRADE_TARGETS  'tardigrade_<pdk>' -> lbflow: tardigrade synth + STA
# yosys and tardigrade run the same lbflow path; they differ only in the mapper.
SC_TARGETS = list(asic.SC_TARGETS)
YOSYS_TARGETS = list(asic.YOSYS_TARGETS)
TARDIGRADE_TARGETS = list(asic.TARDIGRADE_TARGETS)
STA_TARGETS = list(asic.STA_TARGETS)  # 'sta_<pdk>' -> OpenSTA on cached netlist

# all valid --target values, all '<tool>_<part>': FPGA '<vendor>_<part>', then
# the ASIC sets (sc asicflow, yosys lbflow, tardigrade lbflow, sta).
TARGETS = (list(fpga.FPGA_TARGETS) + SC_TARGETS + YOSYS_TARGETS
           + TARDIGRADE_TARGETS + STA_TARGETS)


def run_one(design_cls, target=None, group="", options="", builddir="build",
            quiet=True, start=None, stop=None, timeout=None, clk=None,
            lintonly=False, params=None, name=None):
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
    # override RTL parameters (e.g. {'DW': '8', 'OW': '16'}) before the run
    for pname, pval in (params or {}).items():
        design.set_param(pname, str(pval), "rtl")
    # rename the design (e.g. a per-sweep-point variant like 'muls_DW8_OW16') so
    # its build tree and metrics do not collide with sibling sweep points; the
    # RTL top module is set separately and stays unchanged.
    if name:
        design.set_name(name)
    # key off the SC design name, not the class name (a class like ConvLayer
    # has design name 'conv_layer', which keys its build dir and metrics).
    name = design.name
    # bare names are unique only within a group, so namespace the whole
    # per-benchmark build tree by group: <target-builddir>/<group>/<name>. The
    # netlist cache lives one level above the target tree (the -b root).
    cache_root = os.path.dirname(builddir)
    builddir = os.path.join(builddir, group)
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
            asic._run_scflow(design, target, group, cache_root, builddir, quiet,
                             start, stop, timeout, clk, lintonly=lintonly)
            metrics = {} if lintonly else read_metrics(name, ASIC_METRICS,
                                                       builddir)
        elif target in asic.STA_TARGETS:
            asic._run_sta(design, target, group, cache_root, builddir, quiet,
                          start, stop, timeout, clk, lintonly=lintonly)
            metrics = read_metrics(name, ASIC_METRICS, builddir)
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


def run_task(task, design_cls, tool=None, builddir="build", quiet=True,
             timeout=None):
    """Run one RTL-only task (sim|lint) for a benchmark; return (metrics, error).

    RTL-only tasks take no target/PDK and run their whole (short) flow. 'sim'
    compiles + runs the self-checking testbench (needs a 'testbench' fileset)
    via a local SimFlow on an SC Sim project; 'lint' statically analyzes the RTL
    via a local LintFlow. Errors are caught and returned so a pool worker never
    crashes the parent; module-level so it is picklable for the pool.
    """
    import siliconcompiler
    from logikbench.common import _quiet, read_sim_metrics, read_lint_metrics
    from logikbench.flows.sim import SimFlow
    from logikbench.flows.lint import LintFlow

    design = design_cls()
    name = design.name
    shutil.rmtree(os.path.join(builddir, name), ignore_errors=True)
    try:
        if task == "sim":
            if not design.has_fileset("testbench"):
                raise ValueError(f"{name}: no 'testbench' fileset to simulate")
            proj = siliconcompiler.Sim(design)
            proj.set("option", "builddir", builddir)
            if timeout is not None:
                proj.set("option", "timeout", timeout)
            _quiet(proj, quiet)
            # testbench fileset first so the sim top is the TB
            proj.add_fileset("testbench")
            proj.add_fileset("rtl")
            proj.set_flow(SimFlow(tool=tool or "icarus"))
            proj.run()
            metrics = read_sim_metrics(name, builddir=builddir)
        elif task == "lint":
            proj = siliconcompiler.Project(design)
            proj.set("option", "builddir", builddir)
            if timeout is not None:
                proj.set("option", "timeout", timeout)
            _quiet(proj, quiet)
            proj.add_fileset("rtl")
            proj.set_flow(LintFlow(tool=tool or "slang"))
            proj.run()
            metrics = read_lint_metrics(name, builddir=builddir)
        else:
            raise ValueError(f"run_task: unsupported RTL-only task '{task}'")
        return (metrics, None)
    except Exception as e:  # noqa: BLE001 - report to parent, keep the sweep going
        return (None, str(e))
