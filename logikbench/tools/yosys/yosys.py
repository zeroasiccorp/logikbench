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
            "liberty", "str",
            "standard-cell liberty for ASIC mapping (empty for FPGA)", "")

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

    def post_process(self):
        super().post_process()
        # reuse YosysTask's stat.json metric extraction (cells, cellarea, ...)
        self._synthesis_post_process()
        self._record_luts()
        self._record_logicdepth()

    def _record_luts(self):
        """Record the FPGA LUT count, which SC's base does not break out.

        'cells' is the total cell count; the LUTs are a subset reported per
        type in stat.json. Vendor LUT primitive names differ ($lut, SB_LUT4,
        LUT1..LUT6, ...), so sum every type whose name contains 'lut'. ASIC
        netlists have no LUTs, so nothing is recorded there.
        """
        stat_json = "reports/stat.json"
        if not os.path.exists(stat_json):
            return
        with open(stat_json) as f:
            stats = json.load(f)
        design = stats.get("design", stats)
        by_type = design.get("num_cells_by_type", {})
        luts = sum(n for cell, n in by_type.items() if "lut" in cell.lower())
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
