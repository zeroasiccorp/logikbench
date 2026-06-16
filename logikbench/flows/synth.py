"""LogikBench synthesis flows (built on base SiliconCompiler classes).

Each flow is a single-node Flowgraph whose 'synthesis' node is a YosysTask
configured for a particular target recipe under logikbench/targets. The flows
differ only in which target's synth.tcl they select.
"""

from siliconcompiler import Flowgraph

from logikbench.tools.yosys.yosys import Synthesis
from logikbench.tools.opensta import OpenStaTask


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
    the timing node runs static timing analysis on the resulting netlist. Task
    variables (target/liberty/sdc) are configured on the project by the runner.
    """

    def __init__(self, name="asic_synth"):
        super().__init__()
        self.set_name(name)
        self.node("synthesis", Synthesis())
        self.node("timing", OpenStaTask())
        self.edge("synthesis", "timing")
