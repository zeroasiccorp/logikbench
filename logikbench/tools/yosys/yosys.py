"""Yosys synthesis task for LogikBench.

Subclasses SiliconCompiler's YosysTask (inheriting its executable, version,
'-c' invocation, log regexes, and stat-based metric extraction). The task
runs scripts/synthesis.tcl, which sources the per-mode synthesis core
(scripts/<mode>/synthesis_<mode>.tcl). The mode ('fpga' or 'asic'), the FPGA
target (which selects the yosys synth command), extra synthesis options, and
the ASIC liberty are all supplied as task variables by the flow.
"""

import json
import os
import re

from siliconcompiler import sc_open
from siliconcompiler.tools.yosys import YosysTask

# directory holding this tool's TCL scripts: scripts/<refdir>/synthesis.tcl
_TOOLDIR = os.path.dirname(os.path.abspath(__file__))


# Per-target cell classification. Each vendor (identified by its synth_* command
# via _VENDOR) maps a resource bucket to the EXACT yosys cell types it emits. The
# names are ground-truthed from the yosys techlib sources (the *_map.v / *.txt /
# cells_sim.v that define what each synth_* emits) -- not substring heuristics. A
# cell type not listed for its vendor is written to reports/fpga_unclassified.json
# rather than silently miscounted, so gaps stay visible. Every bucket maps to a
# metric (_BUCKET_METRIC); 'ignore' is non-fabric cells (I/O and clock buffers,
# constants) counting toward nothing.
#
# Sources: yosys techlibs/<vendor>/{lut_map,ff_map,arith_map,dsp_map,brams*,
# lutrams*,cells_map,cells_sim}. 'analogdevices' (flex16ffc) and 'zeroasic'
# (z1015/z1060) are out-of-tree plugins (not in yosys techlibs), so their entries
# are observation-based from stat.json and get completed by the rerun.
_CELLMAP = {
    "xilinx": {                          # synth_xilinx -family xc7 (virtex7)
        "dsp": {"DSP48E1"},
        "bram": {"RAMB18E1", "RAMB36E1"},
        "mux": {"MUXF7", "MUXF8"},
        "lutram": {"RAM32M", "RAM32M16", "RAM64M", "RAM64M8", "RAM64X1S",
                   "RAM64X1D", "RAM64X8SW", "RAM128X1S", "RAM128X1D",
                   "RAM256X1S", "RAM256X1D", "RAM512X1S", "RAM32X16DR8",
                   "SRL16E", "SRLC32E"},
        "register": {"FDRE", "FDSE", "FDCE", "FDPE", "FDCPE",
                     "FDRE_1", "FDSE_1", "FDCE_1", "FDPE_1"},
        "latch": {"LDCE", "LDPE", "LDCPE"},
        "carry": {"CARRY4"},
        "lut": {"LUT1", "LUT2", "LUT3", "LUT4", "LUT5", "LUT6", "INV"},
        "ignore": {"IBUF", "OBUF", "BUFG"},
    },
    "ice40": {                           # synth_ice40
        "dsp": {"SB_MAC16"},
        "bram": {"SB_RAM40_4K", "SB_RAM40_4KNR", "SB_RAM40_4KNW",
                 "SB_RAM40_4KNRNW", "SB_SPRAM256KA"},
        "register": {"SB_DFF", "SB_DFFN", "SB_DFFE", "SB_DFFNE", "SB_DFFR",
                     "SB_DFFNR", "SB_DFFS", "SB_DFFNS", "SB_DFFER",
                     "SB_DFFNER", "SB_DFFES", "SB_DFFNES", "SB_DFFSR",
                     "SB_DFFNSR", "SB_DFFSS", "SB_DFFNSS", "SB_DFFESR",
                     "SB_DFFNESR", "SB_DFFESS", "SB_DFFNESS"},
        "carry": {"SB_CARRY"},
        "lut": {"SB_LUT4"},
    },
    "lattice": {                         # synth_lattice -family ecp5  (ecp5)
        "dsp": {"MULT18X18D"},
        "bram": {"DP16KD", "PDPW16KD"},
        "mux": {"PFUMX", "L6MUX21"},
        "lutram": {"TRELLIS_DPR16X4"},
        "register": {"TRELLIS_FF"},
        "carry": {"CCU2C"},
        "lut": {"LUT4"},
    },
    "gowin": {                           # synth_gowin -family gw5a  (gw5a)
        "bram": {"SP", "SPX9", "DPB", "DPX9B", "SDPB", "SDPX9B"},
        "mux": {"MUX2_LUT5", "MUX2_LUT6", "MUX2_LUT7", "MUX2_LUT8"},
        "lutram": {"RAM16SDP1", "RAM16SDP2", "RAM16SDP4"},
        "register": {"DFF", "DFFN", "DFFE", "DFFNE", "DFFR", "DFFNR", "DFFRE",
                     "DFFNRE", "DFFS", "DFFNS", "DFFSE", "DFFNSE", "DFFP",
                     "DFFNP", "DFFC", "DFFNC", "DFFPE", "DFFNPE", "DFFCE",
                     "DFFNCE"},
        "latch": {"DL", "DLN", "DLC", "DLCE", "DLE", "DLNC", "DLNCE", "DLNE",
                  "DLNP", "DLNPE", "DLP", "DLPE"},
        "carry": {"ALU"},               # gw5a emits no hard DSP (soft mult)
        "lut": {"LUT1", "LUT2", "LUT3", "LUT4"},
        "ignore": {"IBUF", "OBUF", "GND", "VCC"},
    },
    "microchip": {                       # synth_microchip -family polarfire
        "dsp": {"MACC_PA"},
        "bram": {"RAM1K20", "RAM64x12"},
        "mux": {"MX4"},
        "register": {"SLE"},
        "carry": {"ARI1"},
        "lut": {"CFG1", "CFG2", "CFG3", "CFG4", "XOR8"},   # XOR8: reduce-xor
        "ignore": {"INBUF", "OUTBUF", "CLKINT"},
    },
    "efinix": {                          # synth_efinix  (trion)
        "bram": {"EFX_RAM_5K"},          # efinix emits no hard DSP
        "register": {"EFX_FF"},
        "carry": {"EFX_ADD"},
        "lut": {"EFX_LUT4"},
        "ignore": {"EFX_GBUFCE"},
    },
    "gatemate": {                        # synth_gatemate  (cologne)
        "dsp": {"CC_MULT"},
        "bram": {"CC_BRAM_20K", "CC_BRAM_40K"},
        "mux": {"CC_MX4", "CC_MX8"},
        "register": {"CC_DFF"},
        "latch": {"CC_DLT"},
        "carry": {"CC_ADDF"},
        "lut": {"CC_LUT1", "CC_LUT2", "CC_LUT3", "CC_LUT4"},
        "ignore": {"CC_IBUF", "CC_OBUF", "CC_BUFG"},
    },
    "analogdevices": {          # synth_analogdevices -tech t16ffc (flex16ffc)
        "dsp": {"RBBDSP"},               # out-of-tree plugin: observation-based
        "mux": {"LUTMUX7", "LUTMUX8"},
        "lutram": {"RAMS64X1"},
        "register": {"FFRE"},
        "carry": {"CRY4", "CRY4INIT"},
        "lut": {"LUT1", "LUT2", "LUT3", "LUT4", "LUT5", "LUT6"},
        "ignore": {"INBUF", "OUTBUF"},
    },
    "fabulous": {                        # synth_fabulous  (fabulous)
        "bram": {"RegFile_32x4"},        # dedicated hard RegFile BEL, not LUTRAM
        "register": {"LUTFF", "LUTFF_E", "LUTFF_SR", "LUTFF_SS", "LUTFF_ESR",
                     "LUTFF_ESS"},
        "carry": {"LUT4_HA"},            # only with -carry ha (default: none)
        "lut": {"LUT1", "LUT2", "LUT3", "LUT4", "LUT5", "LUT6"},
    },
    # zeroasic (wildebeest synth_fpga, z1015/z1060) is classified by scoped
    # regex, not exact names -- its cells are size-parameterized. See _CELLMAP_RE.
    "quicklogic": {                      # synth_quicklogic -family pp3
        "mux": {"mux4x0", "mux8x0"},
        "register": {"dffepc"},
        "lut": {"LUT1", "LUT2", "LUT3", "LUT4"},
        "ignore": {"inpad", "outpad", "ckpad", "bipad",
                   "logic_0", "logic_1"},
    },
    "achronix": {                        # synth_achronix  (speedster22i)
        "register": {"DFF"},
        "lut": {"LUT4"},
        "ignore": {"PADIN", "PADOUT"},
    },
}


# synth_* command token -> vendor key in _CELLMAP.
_VENDOR = {
    "synth_xilinx": "xilinx",
    "synth_ice40": "ice40",
    "synth_lattice": "lattice",
    "synth_gowin": "gowin",
    "synth_microchip": "microchip",
    "synth_efinix": "efinix",
    "synth_gatemate": "gatemate",
    "synth_analogdevices": "analogdevices",
    "synth_fabulous": "fabulous",
    "synth_quicklogic": "quicklogic",
    "synth_achronix": "achronix",
    "synth_fpga": "zeroasic",
}

# resource bucket -> recorded metric name ('ignore' and unclassified cells
# count toward nothing).
_BUCKET_METRIC = {"lut": "luts", "mux": "muxes", "dsp": "dsps",
                  "bram": "brams", "register": "registers",
                  "latch": "latches", "carry": "carrycells",
                  "lutram": "lutram"}

# bucket lookup order (exact and regex maps share it).
_BUCKETS = ("dsp", "bram", "mux", "register", "latch", "carry", "lut",
            "lutram", "ignore")

# Scoped regex classification for out-of-tree plugin vendors whose cell names
# are parameterized (memory sizes, FF/mult variants) and cannot be enumerated
# exactly. ONLY these vendors use patterns; the in-tree yosys vendors above use
# exact names in _CELLMAP. Checked after the exact map, in _BUCKETS order.
_CELLMAP_RE = {
    "zeroasic": {                        # wildebeest synth_fpga (z1015/z1060)
        "dsp": [re.compile(r"^efpga_mult")],
        "bram": [re.compile(r"^(?:s|sd|td)pram_\d+x\d+$")],
        "register": [re.compile(r"^dff")],
        "lut": [re.compile(r"^\$lut$")],
    },
}


def _vendor_from_command(command):
    """Map the yosys synth command to a _CELLMAP vendor key (None if unknown)."""
    for token, vendor in _VENDOR.items():
        if token in command:
            return vendor
    return None


def _classify(cell, vendor):
    """Return the resource bucket for a cell type under a vendor, or None if
    unlisted (an unclassified gap). Exact names in _CELLMAP win; a vendor with a
    _CELLMAP_RE entry then falls back to its scoped regex patterns."""
    cellmap = _CELLMAP.get(vendor, {})
    for bucket in _BUCKETS:
        if cell in cellmap.get(bucket, ()):
            return bucket
    remap = _CELLMAP_RE.get(vendor)
    if remap:
        for bucket in _BUCKETS:
            if any(pat.match(cell) for pat in remap.get(bucket, ())):
                return bucket
    return None


def classify_cells(by_type, vendor):
    """Bin a stat.json 'num_cells_by_type' into resource-metric counts for a
    vendor. Returns (counts, unclassified): counts maps every metric in
    _BUCKET_METRIC.values() plus the derived 'cells' (their unweighted sum);
    unclassified maps cell types absent from the vendor's cellmap to their
    counts. Shared by the synthesis task and the offline re-extractor so
    classification has a single implementation."""
    counts = {metric: 0 for metric in _BUCKET_METRIC.values()}
    unclassified = {}
    for cell, n in by_type.items():
        bucket = _classify(cell, vendor)
        if bucket in _BUCKET_METRIC:
            counts[_BUCKET_METRIC[bucket]] += n
        elif bucket != "ignore":
            unclassified[cell] = n
    counts["cells"] = sum(counts.values())
    return counts, unclassified


class Synthesis(YosysTask):
    """Run scripts/<refdir>/synthesis.tcl and record synthesis metrics."""

    def __init__(self):
        super().__init__()
        self.add_parameter(
            "mode", "str",
            "synthesis core to run: 'fpga' or 'asic'", "fpga")
        self.add_parameter(
            "command", "str",
            "resolved yosys FPGA synth command line (mapped from the target "
            "in benchmark.py), e.g. 'synth_xilinx -family xc7'", "")
        self.add_parameter(
            "options", "str",
            "extra options appended verbatim to the FPGA synth command", "")
        self.add_parameter(
            "liberty", "[str]",
            "standard-cell liberty file(s) for ASIC mapping; several when the "
            "PDK splits its library by cell group (empty for FPGA)", [])
        self.add_parameter(
            "macrolib", "[str]",
            "hard-macro liberty file(s) (e.g. SRAM) read as '-lib' blackboxes "
            "before the design so instantiated macros stay blackboxes instead "
            "of synthesizing to flops (empty for FPGA / macro-free designs)",
            [])
        self.add_parameter(
            "blackbox", "[str]",
            "verilog blackbox model file(s) (e.g. I/O pad macros with no "
            "liberty) read with 'read_verilog -setattr blackbox' before the "
            "design so instantiated library cells link to blackboxes and "
            "survive in the netlist (empty for FPGA / designs with none)",
            [])
        self.add_parameter(
            "ignore_initial", "bool",
            "pass slang --ignore-initial (drop initial blocks); opt-in for "
            "benchmarks whose initial blocks are simulation-only", False)
        self.add_parameter(
            "lintonly", "bool",
            "elaborate (read_slang + hierarchy check) then stop before the "
            "synthesis core; used by 'lb syn --lintonly'", False)

    def task(self):
        return "synthesis"

    def setup(self):
        super().setup()

        # run scripts/synthesis.tcl from this tool's directory; it sources the
        # per-mode core via $sc_refdir. clobber overrides the parent's defaults.
        self.set_dataroot("logikbench-yosys", _TOOLDIR)
        with self.active_dataroot("logikbench-yosys"):
            self.set_refdir("scripts", clobber=True)
            self.set_script("synthesis.tcl", clobber=True)

        # the script reads the design RTL from the manifest (sc_cfg_get_fileset)
        for lib, key in (self.get_fileset_file_keys("systemverilog")
                         + self.get_fileset_file_keys("verilog")):
            self.add_required_key(lib, *key)

        self.add_output_file(ext="vg")
        self.add_output_file(ext="netlist.json")

    def pre_process(self):
        super().pre_process()
        # Dump a resolved slang command file covering the full dependency
        # graph (e.g. lambdalib la_spram, umi sub-blocks). synthesis.tcl reads
        # it via 'read_slang -F'. Slang options are passed as flags there, and
        # there are no command-file filesets, so the dump is clean.
        #
        # Apply the project's fileset aliases so a lambdalib memory (la_spram,
        # ...) resolves to the PDK's macro wrapper -- the same swap the SC
        # asicflow does -- instead of the generic behavioral model. The wrapper
        # instantiates the hard macro, which 'macrolib' blackboxes. For FPGA and
        # macro-free ASIC designs get_alias() is empty, so this is a no-op.
        proj = self.project
        fileset = proj.get("option", "fileset")[0]
        depalias = {}
        for dep, depfs, alib, afs in proj.option.get_alias():
            lib = proj.get("library", alib, field="schema")
            depalias[(dep, depfs)] = (lib, afs)
        proj.design.write_fileset("sc_rtl.f", fileset=fileset,
                                  depalias=depalias)

    def post_process(self):
        super().post_process()
        # reuse YosysTask's stat.json metric extraction (cells, cellarea, ...)
        self._synthesis_post_process()
        self._record_fpga_resources()
        self._record_logicdepth()

    def _record_fpga_resources(self):
        """Record the FPGA fabric resource counts SC's base does not break out:
        LUTs, mux-fabric cells, DSP blocks, block RAMs, registers, latches,
        carry cells, and distributed (LUT-based) RAM.

        Every stat.json cell type is looked up in the running vendor's _CELLMAP
        and binned by its bucket (see _BUCKET_METRIC); 'ignore' cells (I/O and
        clock buffers, constants) count toward nothing. A cell type not listed
        for the vendor is written to reports/fpga_unclassified.json so the gap
        is auditable, not silently miscounted. FPGA only: on an ASIC run (mode
        != 'fpga') nothing is recorded. A zero count is a real result and
        recorded as 0, not dropped.
        """
        if self.get("var", "mode") != "fpga":
            return
        stat_json = "reports/stat.json"
        if not os.path.exists(stat_json):
            return
        with open(stat_json) as f:
            stats = json.load(f)
        by_type = stats.get("design", stats).get("num_cells_by_type", {})
        vendor = _vendor_from_command(self.get("var", "command"))
        # counts includes the derived 'cells' (unweighted sum of all reported
        # buckets); recording it here overrides SC's raw num_cells on FPGA runs
        # (num_cells = cells + ignore + unclassified).
        counts, unclassified = classify_cells(by_type, vendor)
        for metric, n in counts.items():
            self.record_metric(metric, n, source_file=stat_json)
        # Surface any cell type not in this vendor's cellmap to a small report
        # (kept by clean_build) so classification gaps are visible, not silent.
        # Remove a stale report when this run has no gaps, so it always reflects
        # the current synthesis (clean_build retains reports/ across runs).
        report = "reports/fpga_unclassified.json"
        if unclassified:
            with open(report, "w") as f:
                json.dump({"vendor": vendor, "cells": unclassified}, f,
                          indent=2, sort_keys=True)
        elif os.path.exists(report):
            os.remove(report)

    def _record_logicdepth(self):
        """Record combinational logic depth: the longest topological path (in
        cells, FFs excluded) on the mapped netlist, parsed from the 'length=N'
        printed by 'ltp -noff'. The FPGA script tees it to reports/ltp.rpt (a
        small file that survives clean_build); the run log is the fallback for
        older builds. ASIC runs do not emit it, so nothing is recorded there.
        """
        pattern = re.compile(r"Longest topological path .*\(length=(\d+)\)")
        depth, source = None, None
        for src in ("reports/ltp.rpt", self.get_logpath("exe")):
            if not src or not os.path.exists(src):
                continue
            with sc_open(src) as f:
                for line in f:
                    match = pattern.search(line)
                    if match:
                        depth = int(match.group(1))
            if depth is not None:
                source = src
                break
        if depth is not None:
            self.record_metric("logicdepth", depth, source_file=source)
