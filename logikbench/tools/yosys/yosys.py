"""Yosys synthesis task for LogikBench.

Subclasses SiliconCompiler's YosysTask (inheriting its executable, version,
'-c' invocation, log regexes, and stat-based metric extraction). The task
runs scripts/synthesis.tcl, which sources the per-mode synthesis core
(scripts/<mode>/synthesis_<mode>.tcl). The mode ('fpga' or 'asic'), the FPGA
target (which selects the yosys synth command), extra synthesis options, and
the ASIC liberty are all supplied as task variables by the flow.
"""

import os

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
            "target", "str",
            "FPGA target selecting the yosys synth command "
            "(e.g. zeroasic, ice40, xilinx)", "zeroasic")
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
        # reuse YosysTask's stat.json metric extraction
        self._synthesis_post_process()
