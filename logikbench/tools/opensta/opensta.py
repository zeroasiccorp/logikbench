"""OpenSTA timing task for LogikBench synthesis flows.

OpenStaTask is built only on the base SiliconCompiler Task. It runs a
per-target timing recipe (logikbench/targets/<target>/timing.tcl) on the
synthesized netlist staged from the upstream synthesis node, and records
the fmax timing metric parsed from the OpenSTA log.
"""

import os
import re

from siliconcompiler import Task, sc_open

# logikbench/tools/opensta/opensta.py -> logikbench/ -> logikbench/targets
_TARGETS_DIR = os.path.join(
    os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__)))),
    "targets")


class OpenStaTask(Task):
    """Run a per-target OpenSTA timing recipe and record timing metrics."""

    def __init__(self):
        """Declare the per-flow target, liberty, and SDC inputs.

        These are set by the flow: 'target' selects the timing.tcl recipe,
        'liberty' is the standard-cell library used for delay calculation, and
        'sdc' is the timing-constraints file. Stored as task variables so they
        survive SiliconCompiler's node reconstruction.
        """
        super().__init__()
        self.add_parameter(
            "target",
            "str",
            "directory under logikbench/targets containing timing.tcl",
            "asic/nangate45")
        self.add_parameter("liberty", "str", "standard-cell liberty for STA", "")
        self.add_parameter("sdc", "str", "timing constraints (SDC) file", "")

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

        target = self.get("var", "target")
        self.set_dataroot("logikbench-targets", _TARGETS_DIR)
        with self.active_dataroot("logikbench-targets"):
            self.set_refdir(target)
            self.set_script("timing.tcl")

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
