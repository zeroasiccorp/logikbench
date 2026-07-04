"""LogikBench synthesis flows (built on base SiliconCompiler classes).

Each flow is a single-node Flowgraph whose 'synthesis' node is a YosysTask.
The flows differ only in the yosys 'mode' ('fpga' or 'asic'), which selects
the synthesis core the shared scripts/synthesis.tcl sources.
"""

from siliconcompiler import Flowgraph
from siliconcompiler.tools.opensta.timing import TimingTask

from logikbench.tools.yosys.yosys import Synthesis


class FPGASynthesis(Flowgraph):
    """Single-node FPGA synthesis flow (Yosys synth_fpga).

    Task variables (target) are configured on the project by the runner;
    setting them on the task instance here would not survive node
    reconstruction.
    """

    def __init__(self, name="fpga_synth"):
        super().__init__()
        self.set_name(name)
        self.node("synthesis", Synthesis())


class ASICSynthesis(Flowgraph):
    """Two-node ASIC synthesis flow: Yosys synthesis followed by OpenSTA.

    The synthesis node maps the design to a standard-cell library (liberty);
    the timing node is SiliconCompiler's OpenSTA TimingTask, which records the
    full metric set (fmax, cells, cellarea, nets, pins, registers, slacks,
    power, ...). It reads liberty/scenarios from the ASIC project, so the
    runner sets this flow on an ASIC() project (PDK + single corner).
    """

    def __init__(self, name="asic_synth"):
        super().__init__()
        self.set_name(name)
        self.node("synthesis", Synthesis())
        self.node("timing", TimingTask())
        self.edge("synthesis", "timing")
