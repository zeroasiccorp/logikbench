"""Yosys synthesis task for LogikBench.

Subclasses SiliconCompiler's YosysTask (inheriting its executable, version,
'-c' invocation, log regexes, and stat-based metric extraction). The task
runs scripts/synthesis.tcl, which sources the per-mode synthesis core
(scripts/<mode>/synthesis_<mode>.tcl). The mode ('fpga' or 'asic'), the FPGA
target (which selects the yosys synth command), extra synthesis options, and
the ASIC liberty are all supplied as task variables by the flow.
"""

import json
import os
import re

from siliconcompiler import sc_open
from siliconcompiler.tools.yosys import YosysTask

# directory holding this tool's TCL scripts: scripts/<refdir>/synthesis.tcl
_TOOLDIR = os.path.dirname(os.path.abspath(__file__))


# Dedicated mux-fabric primitives that live in the LUT logic block but are NOT
# named with 'lut': quicklogic mux4x0/mux8x0, xilinx MUXF7/MUXF8, lattice ECP5
# L6MUX21/PFUMX, gatemate CC_MX4/CC_MX8, microchip MX4. These do mux logic that
# a LUT-only fabric (ice40) would spend LUTs on, so they count toward "LUTs" for
# a fair cross-vendor fabric comparison. (The lut-named wide muxes -- gowin
# MUX2_LUT*, adi LUTMUX* -- are already caught by the 'lut' substring below.)
_MUX_FABRIC = {"mux4x0", "mux8x0", "muxf7", "muxf8", "l6mux21", "pfumx",
               "cc_mx4", "cc_mx8", "mx4"}


def _is_dsp(cell):
    """True if a cell is a hard multiplier / MAC / DSP block: xilinx DSP48E1,
    lattice MULT18X18D, gatemate CC_MULT, microchip MACC_PA, adi RBBDSP,
    zeroasic efpga_mult*. Like the muxes, these implement logic a LUT-only
    fabric would otherwise spend (many) LUTs on, so they count toward the total.
    Carry/ALU cells (CARRY4, ALU, CCU2C, ARI1, ...) are NOT DSPs and excluded."""
    name = cell.lower()
    return "mult" in name or "dsp" in name or "macc" in name


def _is_lut(cell):
    """True if a yosys cell type counts toward the LUT (logic-fabric) total.

    Includes lookup tables (LUTn, $lut, SB_LUT4, CC_LUTn, EFX_LUT4, LUTFF;
    microchip CFG1..CFG4), the dedicated mux-fabric primitives that share the
    LUT logic block (see _MUX_FABRIC, plus the lut-named wide muxes MUX2_LUT* /
    LUTMUX*), and hard DSP/multiply/MAC blocks (see _is_dsp). Counting the muxes
    and DSPs keeps fabrics that offload logic to them (quicklogic, xilinx, ...)
    comparable with LUT-only fabrics like ice40."""
    name = cell.lower()
    if name in _MUX_FABRIC or _is_dsp(name):
        return True
    return "lut" in name or re.fullmatch(r"cfg[1-4]", name) is not None


class Synthesis(YosysTask):
    """Run scripts/<refdir>/synthesis.tcl and record synthesis metrics."""

    def __init__(self):
        super().__init__()
        self.add_parameter(
            "mode", "str",
            "synthesis core to run: 'fpga' or 'asic'", "fpga")
        self.add_parameter(
            "command", "str",
            "resolved yosys FPGA synth command line (mapped from the target "
            "in benchmark.py), e.g. 'synth_xilinx -family xc7'", "")
        self.add_parameter(
            "options", "str",
            "extra options appended verbatim to the FPGA synth command", "")
        self.add_parameter(
            "liberty", "[str]",
            "standard-cell liberty file(s) for ASIC mapping; several when the "
            "PDK splits its library by cell group (empty for FPGA)", [])
        self.add_parameter(
            "macrolib", "[str]",
            "hard-macro liberty file(s) (e.g. SRAM) read as '-lib' blackboxes "
            "before the design so instantiated macros stay blackboxes instead "
            "of synthesizing to flops (empty for FPGA / macro-free designs)",
            [])
        self.add_parameter(
            "ignore_initial", "bool",
            "pass slang --ignore-initial (drop initial blocks); opt-in for "
            "benchmarks whose initial blocks are simulation-only", False)
        self.add_parameter(
            "lintonly", "bool",
            "elaborate (read_slang + hierarchy check) then stop before the "
            "synthesis core; used by 'lb syn --lintonly'", False)

    def task(self):
        return "synthesis"

    def setup(self):
        super().setup()

        # run scripts/synthesis.tcl from this tool's directory; it sources the
        # per-mode core via $sc_refdir. clobber overrides the parent's defaults.
        self.set_dataroot("logikbench-yosys", _TOOLDIR)
        with self.active_dataroot("logikbench-yosys"):
            self.set_refdir("scripts", clobber=True)
            self.set_script("synthesis.tcl", clobber=True)

        # the script reads the design RTL from the manifest (sc_cfg_get_fileset)
        for lib, key in (self.get_fileset_file_keys("systemverilog")
                         + self.get_fileset_file_keys("verilog")):
            self.add_required_key(lib, *key)

        self.add_output_file(ext="vg")
        self.add_output_file(ext="netlist.json")

    def pre_process(self):
        super().pre_process()
        # Dump a resolved slang command file covering the full dependency
        # graph (e.g. lambdalib la_spram, umi sub-blocks). synthesis.tcl reads
        # it via 'read_slang -F'. Slang options are passed as flags there, and
        # there are no command-file filesets, so the dump is clean.
        #
        # Apply the project's fileset aliases so a lambdalib memory (la_spram,
        # ...) resolves to the PDK's macro wrapper -- the same swap the SC
        # asicflow does -- instead of the generic behavioral model. The wrapper
        # instantiates the hard macro, which 'macrolib' blackboxes. For FPGA and
        # macro-free ASIC designs get_alias() is empty, so this is a no-op.
        proj = self.project
        fileset = proj.get("option", "fileset")[0]
        depalias = {}
        for dep, depfs, alib, afs in proj.option.get_alias():
            lib = proj.get("library", alib, field="schema")
            depalias[(dep, depfs)] = (lib, afs)
        proj.design.write_fileset("sc_rtl.f", fileset=fileset,
                                  depalias=depalias)

    def post_process(self):
        super().post_process()
        # reuse YosysTask's stat.json metric extraction (cells, cellarea, ...)
        self._synthesis_post_process()
        self._record_luts()
        self._record_logicdepth()

    def _record_luts(self):
        """Record the FPGA LUT count, which SC's base does not break out.

        'cells' is the total cell count; the LUTs are a subset reported per
        type in stat.json. ASIC netlists have no LUTs, so nothing is recorded
        there.
        """
        stat_json = "reports/stat.json"
        if not os.path.exists(stat_json):
            return
        with open(stat_json) as f:
            stats = json.load(f)
        design = stats.get("design", stats)
        by_type = design.get("num_cells_by_type", {})
        luts = sum(n for cell, n in by_type.items() if _is_lut(cell))
        if luts:
            self.record_metric("luts", luts, source_file=stat_json)

    def _record_logicdepth(self):
        """Record combinational logic depth: the longest topological path (in
        cells, FFs excluded) on the mapped netlist, parsed from the 'length=N'
        printed by the 'ltp -noff' that the FPGA synthesis script runs. ASIC
        runs do not emit it, so nothing is recorded there.
        """
        log = self.get_logpath("exe")
        if not os.path.exists(log):
            return
        depth = None
        pattern = re.compile(r"Longest topological path .*\(length=(\d+)\)")
        with sc_open(log) as f:
            for line in f:
                match = pattern.search(line)
                if match:
                    depth = int(match.group(1))
        if depth is not None:
            self.record_metric("logicdepth", depth, source_file=log)
