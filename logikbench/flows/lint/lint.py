"""Lint / static-analysis flow (`lb lint`), RTL-only (no target-class split).

A local SiliconCompiler Flowgraph -- LB owns the flow; only the task comes from
SC. Single 'lint' node; '--tool' selects the linter (slang [default] or
verilator). LB records per-benchmark warning/error counts (see LINT_METRICS).

Adding a linter follows the tools/ pattern (see logikbench/tools/README.md):
add its SC lint Task and one entry to _LINT.
"""

from siliconcompiler import Flowgraph
from siliconcompiler.tools.slang.lint import Lint as SlangLint
from siliconcompiler.tools.verilator.lint import LintTask as VerilatorLint


class LintFlow(Flowgraph):
    """Local single-node RTL lint flow (linter by --tool)."""

    # linter task by --tool name
    _LINT = {"slang": SlangLint, "verilator": VerilatorLint}

    def __init__(self, tool="slang", name="lint"):
        super().__init__()
        self.set_name(name)
        self.node("lint", self._LINT[tool]())
