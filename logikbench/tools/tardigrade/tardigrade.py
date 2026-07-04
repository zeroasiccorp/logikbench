"""Tardigrade ASIC synthesis.

Tardigrade maps the design to a standard-cell library and writes a gate-level
Verilog netlist (outputs/<top>.vg) that the downstream OpenSTA timing node
reads for fmax/cellarea/cells.

Interface:

    tardigrade -f cmd.f -l <lib> [-l <lib> ...]
               -t <top> \
               [-s <sdc> [-s <sdc> ...]
               [-o <output file>] [--option <opt> ...]

  -f        Verilog RTL command file(s)
  -s,--sdc  SDC file(s)
  -l,--lib  standard-cell liberty file
  -t,--top  top module name
  -o,--output output netlist filepath
  --option    extra option passed through verbatim (repeatable)
  --qor       qor json filepath

"""

import json
import os

from siliconcompiler import Task

# directory holding this tool's assets (none yet, for future)
_TOOLDIR = os.path.dirname(os.path.abspath(__file__))


class TardigradeTask(Task):
    """Tool-level definition for the tardigrade binary.

    Declares the executable, version switch, and log scraping shared by every
    tardigrade task. Concrete tasks (Synthesis) derive from this and add their
    task-specific inputs, outputs, and command line.
    """

    def tool(self):
        return "tardigrade"

    def setup(self):
        super().setup()
        self.set_exe("tardigrade", vswitch="-v")
        # TODO(bring-up): once tardigrade is on PATH, pin a minimum version
        #   self.add_version(">=<ver>")
        # and, if 'tardigrade -v' is not '<name> <version> ...', override
        # parse_version()
        self.add_regex("warnings", "Warning:")
        self.add_regex("errors", "^ERROR")


class Synthesis(TardigradeTask):
    """Run tardigrade ASIC synthesis and emit a mapped Verilog netlist."""

    def __init__(self):
        super().__init__()
        self.add_parameter(
            "liberty", "[str]",
            "standard-cell liberty file(s) for ASIC mapping; several when the "
            "PDK splits its library by cell group", [])
        self.add_parameter(
            "options", "[str]",
            "extra options passed through verbatim, each as a '--option <opt>' "
            "argument (fed by lb run --options)", [])

    def task(self):
        return "synthesis"

    def setup(self):
        super().setup()
        for lib, key in (self.get_fileset_file_keys("systemverilog")
                         + self.get_fileset_file_keys("verilog")):
            self.add_required_key(lib, *key)
        # SDC drives timing-driven mapping; mark it required like the RTL so SC
        # stages/tracks it (same access pattern OpenSTA's TimingTask uses).
        for lib, key in self.get_fileset_file_keys("sdc"):
            self.add_required_key(lib, *key)
        self.add_output_file(ext="vg")

    def pre_process(self):
        '''Dynamic runtime pre-processing step.'''
        super().pre_process()
        # Dump the resolved flat filelist (full dependency graph: sources,
        # +incdir/+define) that tardigrade reads via -f.
        fileset = self.project.get("option", "fileset")[0]
        self.project.design.write_fileset("cmd.f", fileset=fileset)

    def runtime_options(self):
        opts = super().runtime_options()
        design = self.project.design
        fileset = self.project.get("option", "fileset")[0]
        top = design.get_topmodule(fileset)
        opts += ["-f", "cmd.f", "-t", top]
        for lib in self.get("var", "liberty"):
            opts += ["-l", lib]
        # timing-driven mapping: pass the SDC (the lbsdc wrapper OpenSTA also
        # reads). tardigrade's -s is OpenSTA-compatible TCL, so the one file
        # serves both the synthesis and timing nodes.
        if design.has_fileset("lbsdc"):
            for sdc in design.get_file(fileset="lbsdc"):
                opts += ["-s", sdc]
        opts += ["-o", f"outputs/{top}.vg", "--qor", "qor.json"]
        for opt in self.get("var", "options"):
            opts += ["--option", opt]
        return opts

    def post_process(self):
        super().post_process()
        # tardigrade writes a QoR JSON (via --qor) whose keys are exactly SC
        # schema metric names
        qor = "qor.json"
        if not os.path.exists(qor):
            return
        with open(qor) as f:
            metrics = json.load(f)
        for metric, value in metrics.items():
            if value is not None:
                self.record_metric(metric, value, source_file=qor)
