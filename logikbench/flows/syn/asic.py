"""ASIC synthesis flow (`lb syn`, ASIC targets).

Two-node SiliconCompiler Flowgraph: a standard-cell mapping node followed by
OpenSTA timing. The 'synthesis' node maps the design to a liberty library; the
'--tool' selection picks which mapper runs it (see _SYNTH). Both mappers emit
the same gate-level netlist contract, so the 'timing' node is SC's OpenSTA
TimingTask unchanged (records fmax, cells, cellarea, nets, pins, registers,
slacks, power, ...). It reads liberty/scenarios from the ASIC project, so the
runner sets this flow on an ASIC() project (PDK + single corner).

Adding a mapper (including a proprietary tool such as Design Compiler): add its
SC Task subclass under logikbench/tools/<tool>/ following the tools/tardigrade
pattern, then add one entry to _SYNTH. See logikbench/tools/README.md.
"""

from siliconcompiler import Flowgraph
from siliconcompiler.tools.opensta.timing import TimingTask

from logikbench.tools.yosys.yosys import Synthesis as YosysSynthesis
from logikbench.tools.tardigrade.tardigrade import Synthesis as TardigradeSynthesis


class ASICSynthesis(Flowgraph):
    """Standard-cell mapping (mapper by --tool) + OpenSTA timing."""

    # synthesis mapper by --tool name -> its SC Task class
    _SYNTH = {"yosys": YosysSynthesis, "tardigrade": TardigradeSynthesis}

    def __init__(self, tool="yosys", name="asic_synth"):
        super().__init__()
        self.set_name(name)
        self.node("synthesis", self._SYNTH[tool]())
        self.node("timing", TimingTask())
        self.edge("synthesis", "timing")
