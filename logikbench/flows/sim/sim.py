"""Simulation flow (`lb sim`), RTL-only (no target-class split).

A local SiliconCompiler Flowgraph -- LB owns the flow; only the tasks come from
SC. Two nodes: 'compile' (build/elaborate the sim model) -> 'simulate' (execute
the self-checking testbench). '--tool' selects the compiler task; the run node
is SC's generic exec-of-input task. LB records per-node metrics (compiletime from
'compile'; status / simtime / cycles from 'simulate' -- see SIM_METRICS).

Default tool is icarus: LB benchmarks ship self-checking *Verilog* testbenches,
which Icarus runs directly. Verilator (stricter, needs a C++ harness) is also
selectable via --tool. np>1 fans out independent simulate replicas.

Adding a simulator follows the tools/ pattern (see logikbench/tools/README.md):
add its SC compile Task and one entry to _COMPILE.
"""

from siliconcompiler import Flowgraph
from siliconcompiler.tools.icarus.compile import CompileTask as IcarusCompile
from siliconcompiler.tools.verilator.compile import CompileTask as VerilatorCompile
from siliconcompiler.tools.execute.exec_input import ExecInputTask


class SimFlow(Flowgraph):
    """Local compile -> simulate flow (compiler by --tool)."""

    # simulator compile task by --tool name
    _COMPILE = {"icarus": IcarusCompile, "verilator": VerilatorCompile}

    def __init__(self, tool="icarus", np=1, name="sim"):
        super().__init__()
        self.set_name(name)
        self.node("compile", self._COMPILE[tool]())
        sim_task = ExecInputTask()
        for n in range(np):
            self.node("simulate", sim_task, index=n)
            self.edge("compile", "simulate", head_index=n)
