"""Tardigrade ASIC synthesis.

Tardigrade is Zero ASIC's standalone synthesis tool that maps RTL to a standard-cell
library and writes out a gate-level Verilog netlist.

Interface:

    tardigrade -f cmd.f -l <lib> [-l <lib> ...]
               -t <top> \
               [-s <sdc> [-s <sdc> ...]
               [-o <output file>] [--option <opt> ...]

  -f          Verilog RTL command file(s)
  -s,--sdc    SDC file(s)
  -l,--lib    standard-cell liberty file
  -t,--top    top module name
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

    def parse_version(self, stdout):
        # 'tardigrade -v' prints 'tardigrade <version>'
        return stdout.split()[1]

    def setup(self):
        super().setup()
        self.set_exe("tardigrade", vswitch="-v")
        # TODO(bring-up): pin a minimum version once stable, e.g.
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
            "argument (fed by lb syn --options)", [])
        self.add_parameter(
            "pdk", "str",
            "PDK name passed to 'tardigrade --pdk', which auto-populates the "
            "synth_asic mapping args (techmap/dont-use/tie cells) from "
            "lambdapdk", "")
        self.add_parameter(
            "lintonly", "bool",
            "elaborate then stop before synth_asic (passes 'tardigrade "
            "--lintonly'); used by 'lb syn --lintonly'", False)

    def task(self):
        return "synthesis"

    def setup(self):
        '''Task interface setup'''
        super().setup()
        # Required RTL
        for lib, key in (self.get_fileset_file_keys("systemverilog")
                         + self.get_fileset_file_keys("verilog")):
            self.add_required_key(lib, *key)
        # Required SDC
        for lib, key in self.get_fileset_file_keys("sdc"):
            self.add_required_key(lib, *key)
        # TODO: cleanup outputs
        self.add_output_file(ext="vg")
        self.add_output_file(ext="netlist.json")

    def pre_process(self):
        '''Dynamic runtime pre-processing'''
        super().pre_process()
        # Export .f filelist for use by tool verilog parser
        fileset = self.project.get("option", "fileset")[0]
        self.project.design.write_fileset("cmd.f", fileset=fileset)

    def runtime_options(self):
        '''Dynamic runtime options.'''
        opts = super().runtime_options()
        design = self.project.design
        fileset = self.project.get("option", "fileset")[0]
        top = design.get_topmodule(fileset)
        opts += ["-f", "cmd.f", "-t", top]
        pdk = self.get("var", "pdk")
        # PDK target
        if pdk:
            opts += ["--pdk", pdk]
        # Liberty
        for lib in self.get("var", "liberty"):
            opts += ["-l", lib]
        # SDC
        if design.has_fileset("lbsdc"):
            for sdc in design.get_file(fileset="lbsdc"):
                opts += ["-s", sdc]
        # Options
        opts += ["-o", f"outputs/{top}.vg", "--qor", "qor.json"]
        if self.get("var", "lintonly"):
            opts += ["--lintonly"]
        for opt in self.get("var", "options"):
            opts += [f"--option={opt}"]
        return opts

    def post_process(self):
        '''Dynamic post-processing'''
        super().post_process()
        # process tardigrade qor file
        qor = "qor.json"
        if not os.path.exists(qor):
            return
        with open(qor) as f:
            metrics = json.load(f)
        for metric, value in metrics.items():
            if value is not None:
                self.record_metric(metric, value, source_file=qor)
