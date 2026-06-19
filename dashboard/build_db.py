#!/usr/bin/env python3
"""Merge per-target results (from 'lb collect') into one dashboard database.

Run this offline, where logikbench/SiliconCompiler are installed. It reads the
aggregated <target>.json files produced by 'lb collect' and writes a single,
self-describing results/db.json: column order, metric presentation metadata,
group/benchmark layout, and the value matrix. The committed db.json is all the
GitHub Action needs (dashboard/generate.py renders it with only Jinja2).

Metric *presentation* (labels, better-is-lower/higher, display units) lives
here, not in logikbench: it is a dashboard concern. logikbench owns only the
metric *names* (FPGA_METRICS / ASIC_METRICS) and the benchmark group structure.
"""

import argparse
import glob
import json
import os

import logikbench as lb
from logikbench.benchmark import FPGA_METRICS, ASIC_METRICS, FPGA_TARGETS

# benchmark groups, in display order
GROUPS = ['basic', 'memory', 'arithmetic', 'epfl', 'blocks']

# per-metric presentation: 'dir' is which way is better (the dashboard colors
# best=blue, worst=red per benchmark); 'unit' is appended in the cell.
METRIC_INFO = {
    "cells":      {"label": "Cells",       "dir": "lower",  "unit": ""},
    "luts":       {"label": "LUTs",        "dir": "lower",  "unit": ""},
    "logicdepth": {"label": "Logic depth", "dir": "lower",  "unit": ""},
    "nets":       {"label": "Nets",        "dir": "lower",  "unit": ""},
    "pins":       {"label": "Pins",        "dir": "lower",  "unit": ""},
    "tasktime":   {"label": "Runtime",     "dir": "lower",  "unit": "s"},
    "cellarea":   {"label": "Cell area",   "dir": "lower",  "unit": "um^2"},
    "fmax":       {"label": "Fmax",        "dir": "higher", "unit": "MHz"},
    "setupslack": {"label": "Setup slack", "dir": "higher", "unit": "ns"},
}


def benchmark_order():
    """(group, benchmark-name) pairs in canonical group/definition order.

    Benchmark names are assumed unique across groups (results key by name and
    share a build dir per target); a duplicate would show a row in each group.
    """
    order = []
    for group in GROUPS:
        for item in getattr(lb, group).__all__:
            order.append((group, item.lower()))
    return order


def load_targets(results_dirs):
    """{target: payload} from <target>.json files written by 'lb collect'.

    Each payload is {"target", "options", "metrics": {metric: {bench: value}}}.
    """
    collected = {}
    for d in results_dirs:
        for path in sorted(glob.glob(os.path.join(d, "*.json"))):
            stem = os.path.splitext(os.path.basename(path))[0]
            if stem == "db":
                continue
            with open(path) as f:
                collected[stem] = json.load(f)
    return collected


def build_section(targets, metric_names, collected):
    """Assemble one flow's slice: column order, per-target settings, metric
    metadata, group layout, and the {benchmark: {target: {metric: value}}}
    matrix. Benchmarks with no recorded value on any target are omitted."""
    data = {}
    by_group = {}
    for group, bench in benchmark_order():
        per_target = {}
        for target in targets:
            tm = collected.get(target, {}).get("metrics", {})
            vals = {m: tm.get(m, {}).get(bench) for m in metric_names}
            if any(v is not None for v in vals.values()):
                per_target[target] = vals
        if per_target:
            data[bench] = per_target
            by_group.setdefault(group, []).append(bench)

    return {
        "targets": targets,
        # synthesis settings each column was produced with (shown under the
        # target name); empty string means defaults.
        "settings": {t: (collected.get(t, {}).get("options") or "")
                     for t in targets},
        "metrics": [{"key": m, **METRIC_INFO[m]} for m in metric_names],
        "groups": [{"name": g, "benchmarks": by_group[g]}
                   for g in GROUPS if g in by_group],
        "data": data,
    }


def main():
    ap = argparse.ArgumentParser(description=__doc__,
                                 formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--results", nargs="+", default=["results"], metavar="DIR",
                    help="Directory(ies) holding <target>.json files from "
                         "'lb collect' (default: results)")
    ap.add_argument("-o", "--output", default=os.path.join("results", "db.json"),
                    metavar="FILE", help="Database file to write "
                                         "(default: results/db.json)")
    args = ap.parse_args()

    collected = load_targets(args.results)
    if not collected:
        ap.error(f"no <target>.json files found under: {', '.join(args.results)}")

    # Each loaded file is one column, keyed by its filename stem (which may be a
    # --suffix variant like xilinx_virtex7_abc9). The flow is decided by the
    # embedded real target (payload["target"]), not the stem. Columns ordered
    # alphabetically z->a (left to right).
    def is_fpga(col):
        return collected[col].get("target", col) in FPGA_TARGETS
    fpga = sorted((c for c in collected if is_fpga(c)), reverse=True)
    asic = sorted((c for c in collected if not is_fpga(c)), reverse=True)

    db = {}
    if fpga:
        db["fpga"] = build_section(fpga, FPGA_METRICS, collected)
    if asic:
        db["asic"] = build_section(asic, ASIC_METRICS, collected)

    outdir = os.path.dirname(args.output)
    if outdir:
        os.makedirs(outdir, exist_ok=True)
    with open(args.output, "w") as f:
        json.dump(db, f, indent=2)

    for flow, section in db.items():
        print(f"{flow}: {len(section['data'])} benchmark(s) x "
              f"{len(section['targets'])} target(s)")
    print(f"Wrote {args.output}.")


if __name__ == "__main__":
    main()
