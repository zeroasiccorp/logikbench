"""FPGA synthesis flow (`lb syn`, FPGA targets).

Single-node SiliconCompiler Flowgraph running Yosys synth_fpga (LUT / logic-depth
metrics). The FPGA part/target is configured on the project by the runner; the
'--tool' selection picks the synthesis engine (see _SYNTH).

Adding an FPGA synthesis tool (including a vendor flow such as Vivado): add its
SC Task subclass under logikbench/tools/<tool>/ following the tools/tardigrade
pattern, then add one entry to _SYNTH. See logikbench/tools/README.md.
"""

from siliconcompiler import Flowgraph

from logikbench.tools.yosys.yosys import Synthesis as YosysSynthesis


class FPGASynthesis(Flowgraph):
    """Single-node FPGA synthesis (engine by --tool)."""

    # synthesis engine by --tool name -> its SC Task class
    _SYNTH = {"yosys": YosysSynthesis}

    def __init__(self, tool="yosys", name="fpga_synth"):
        super().__init__()
        self.set_name(name)
        self.node("synthesis", self._SYNTH[tool]())
