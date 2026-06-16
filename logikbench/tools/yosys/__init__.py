"""Yosys task for LogikBench synthesis flows.

YosysTask is built only on the base SiliconCompiler Task. It runs a per-target
Yosys TCL recipe (logikbench/targets/<target>/synth.tcl) and records
SiliconCompiler-standard metrics from the Yosys stat report. The target is
selected by the flow via the 'target' task variable, so a single task type
serves both the FPGA and ASIC synthesis flows.
"""

import json
import os

from siliconcompiler import Task, sc_open

# logikbench/tools/yosys/__init__.py -> logikbench/ -> logikbench/targets
_TARGETS_DIR = os.path.join(
    os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__)))),
    "targets")


class YosysTask(Task):
    """Run a per-target Yosys TCL recipe and record synthesis metrics."""

    def __init__(self):
        """Declare the per-flow 'target' variable.

        The flow sets this to a directory under logikbench/targets (e.g.
        'fpga/zeroasic'); setup() resolves the recipe from it. Storing it as a
        task variable keeps the task generic and lets it survive the schema
        round-trip when SiliconCompiler reconstructs the node.
        """
        super().__init__()
        self.add_parameter(
            "target",
            "str",
            "directory under logikbench/targets containing synth.tcl",
            "fpga/zeroasic")
        self.add_parameter(
            "liberty",
            "str",
            "standard-cell liberty for ASIC mapping (empty for FPGA)",
            "")

    def tool(self):
        """Name of the tool/executable group (namespaces settings + binary)."""
        return "yosys"

    def task(self):
        """Task name; SiliconCompiler keys schema and flow steps on it."""
        return "synth"

    def setup(self):
        """Declare the command, recipe, design inputs, outputs, and log regexes.

        SiliconCompiler calls this to build the node's run configuration. The
        recipe is resolved from the 'target' variable so FPGA and ASIC flows
        reuse this one task with different synth.tcl scripts.
        """
        super().setup()

        # Yosys is invoked in TCL mode: 'yosys -c <script>'.
        self.set_exe("yosys", vswitch="--version", format="tcl")
        self.add_version(">=0.48")
        self.add_commandline_option("-c")

        # Resolve the recipe from the flow-selected target. The script is found
        # relative to the task refdir, so set both.
        target = self.get("var", "target")
        self.set_dataroot("logikbench-targets", _TARGETS_DIR)
        with self.active_dataroot("logikbench-targets"):
            self.set_refdir(target)
            self.set_script("synth.tcl")

        # Mark the design RTL as required inputs; the script reads them from
        # the manifest (sc_cfg_get_fileset), so no input staging is needed.
        for lib, key in (self.get_fileset_file_keys("systemverilog")
                         + self.get_fileset_file_keys("verilog")):
            self.add_required_key(lib, *key)

        # We only emit the gate-level netlist.
        self.add_output_file(ext="vg")

        self.add_regex("warnings", "Warning:")
        self.add_regex("errors", "^ERROR")

    def parse_version(self, stdout):
        """Extract the version from 'yosys --version' for add_version() checks."""
        # Yosys 0.48 (git sha1 ..., gcc ...)
        return stdout.split()[1]

    def normalize_version(self, version):
        """Map yosys '+' local-version labels to '-' so ranges compare."""
        return version.replace('+', '-')

    def post_process(self):
        """Record SiliconCompiler metrics from the Yosys stat report.

        Called in the node directory after yosys exits. Decoupled from the TCL:
        it reads reports/stat.json and records whichever metrics apply, so any
        compliant recipe (FPGA or ASIC) populates the same metric names.
        """
        super().post_process()

        stat_json = "reports/stat.json"
        if not os.path.exists(stat_json):
            self.logger.warning("Yosys cell statistics are missing")
            return

        with sc_open(stat_json) as f:
            data = json.load(f)
        design = data.get("design", data)

        # Common metrics (valid in both FPGA and ASIC metric schemas).
        if "num_cells" in design:
            self.record_metric("cells", design["num_cells"], source_file=stat_json)
        if "num_wire_bits" in design:
            self.record_metric("nets", design["num_wire_bits"], source_file=stat_json)
        if "num_port_bits" in design:
            self.record_metric("pins", float(design["num_port_bits"]), source_file=stat_json)

        # Flow-specific metrics; quiet so recording a key absent from the
        # current schema (e.g. luts on an ASIC project) is silently skipped.
        if "area" in design:
            self.record_metric("cellarea", float(design["area"]), source_file=stat_json,
                               source_unit="um^2", quiet=True)
        by_type = design.get("num_cells_by_type", {})
        if "$lut" in by_type:
            self.record_metric("luts", by_type["$lut"], source_file=stat_json, quiet=True)
