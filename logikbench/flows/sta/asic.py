"""ASIC static timing analysis flow (`lb sta`, ASIC targets) -- local.

Runs OpenSTA on a cached synthesized netlist: an ImportFilesTask entry node
brings in `lb syn`'s netlist and feeds SC's OpenSTA TimingTask (fmax, slacks).
No synthesis, no place-and-route. The netlist path is supplied by the runner as
the import task's 'file' var (tool 'builtin', task 'importfiles').
"""

from siliconcompiler import Flowgraph
from siliconcompiler.tools.builtin.importfiles import ImportFilesTask
from siliconcompiler.tools.opensta.timing import TimingTask


class ASICSta(Flowgraph):
    """Import a cached netlist, then run STA (import -> timing).

    `tool` is the STA engine being benchmarked; only the SiliconCompiler
    reference (OpenSTA) has a hard-coded flow here. Another engine (e.g. a
    proprietary STA tool) would supply its own flow via tools/ (see
    logikbench/tools/README.md)."""

    def __init__(self, tool="opensta", name="asic_sta"):
        super().__init__()
        self.set_name(name)
        if tool != "opensta":
            raise ValueError(
                f"sta --tool '{tool}' has no flow; only 'opensta' is wired.")
        self.node("import", ImportFilesTask())
        self.node("timing", TimingTask())
        self.edge("import", "timing")
