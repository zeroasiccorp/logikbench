"""OpenSTA timing task for LogikBench synthesis flows.

OpenStaTask is built only on the base SiliconCompiler Task. It runs the shared
scripts/timing.tcl recipe on the synthesized netlist staged from the upstream
synthesis node, and records the fmax timing metric parsed from the OpenSTA log.
The recipe is PDK-agnostic; per-PDK timing constants come from each PDK's
tech.tcl, whose path is passed in as a task variable.
"""

import os
import re

from siliconcompiler import Task, sc_open

# directory holding this tool's TCL scripts: scripts/timing.tcl
_TOOLDIR = os.path.dirname(os.path.abspath(__file__))


class OpenStaTask(Task):
    """Run the shared OpenSTA timing recipe and record timing metrics."""

    def __init__(self):
        """Declare the per-flow liberty, SDC, and constraint inputs.

        These are set by the flow: 'liberty' is the standard-cell library used
        for delay calculation, 'sdc' is the benchmark timing-constraints file,
        and 'clk'/'techfile'/'defaultsdc' feed the constraint sourcing. Stored
        as task variables so they survive SiliconCompiler's node reconstruction.
        """
        super().__init__()
        self.add_parameter("liberty", "str", "standard-cell liberty for STA", "")
        self.add_parameter("sdc", "str", "benchmark timing constraints (SDC) file", "")
        self.add_parameter("clk", "str", "clock period in ns injected as LB_CLK_NS", "")
        self.add_parameter("techfile", "str", "PDK tech.tcl the benchmark SDC sources", "")
        self.add_parameter("defaultsdc", "str", "default.sdc the benchmark SDC sources", "")

    def tool(self):
        """Tool/executable group (namespaces settings + the 'sta' binary)."""
        return "opensta"

    def task(self):
        """Task name; SiliconCompiler keys schema and flow steps on it."""
        return "timing"

    def setup(self):
        """Declare the command, recipe, netlist input, and log regexes."""
        super().setup()

        # OpenSTA is invoked in TCL mode: 'sta -no_init -exit <script>'.
        self.set_exe("sta", vswitch="-version", format="tcl")
        self.add_version(">=2.0.0")

        # run scripts/timing.tcl from this tool's directory (PDK-agnostic)
        self.set_dataroot("logikbench-opensta", _TOOLDIR)
        with self.active_dataroot("logikbench-opensta"):
            self.set_refdir("scripts", clobber=True)
            self.set_script("timing.tcl", clobber=True)

        # the synthesized netlist is produced by the upstream synthesis node
        self.set("input", f"{self.design_topmodule}.vg")

        self.add_required_key("var", "liberty")

        self.add_regex("warnings", r'^\[WARNING|^Warning')
        self.add_regex("errors", r'^\[ERROR|^Error')

    def runtime_options(self):
        """Append OpenSTA's non-interactive flags after the base options."""
        options = super().runtime_options()
        options.append("-no_init")
        if not self.has_breakpoint():
            options.append("-exit")
        return options

    def parse_version(self, stdout):
        """OpenSTA prints a bare version string to stdout."""
        return stdout.strip()

    def post_process(self):
        """Record fmax parsed from the OpenSTA log.

        The recipe prints 'fmax = <MHz> MHz'; we parse that line rather than
        depend on machine-readable reports, keeping the task decoupled from the
        TCL details.
        """
        super().post_process()

        fmax = None
        with sc_open(self.get_logpath("exe")) as f:
            for line in f:
                m = re.search(r'^fmax = (\d*\.?\d*)', line)
                if m:
                    fmax = float(m.group(1))

        if fmax is not None:
            self.record_metric("fmax", fmax, source_file=self.get_logpath("exe"),
                               source_unit="MHz")
