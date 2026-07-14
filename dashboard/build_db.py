#!/usr/bin/env python3
"""Build per-config dashboard databases from collected FPGA results.

Each config is a subdirectory of results/fpga (e.g. results/fpga/small,
results/fpga/fast) holding per-target <target>.json files from 'lb collect -o
results/fpga/<config>'. This writes one self-describing database per config to
results/fpga/<config>.json, which dashboard/generate.py renders as one page
per config.

Run offline (imports logikbench). The committed <config>.json databases are all
the GitHub Action needs (generate.py renders them with only Jinja2).

Metric *presentation* (labels, better-is-lower/higher, display units) lives
here, not in logikbench: it is a dashboard concern. logikbench owns only the
metric *names* (FPGA_METRICS) and the benchmark group structure.
"""

import argparse
import glob
import json
import os

import logikbench as lb
from logikbench.runner import FPGA_METRICS, ASIC_METRICS, FPGA_TARGETS

# benchmark groups, in display order
GROUPS = ['basic', 'memory', 'arithmetic', 'epfl', 'blocks']

# metric set per run mode (fpga vs asic synthesis)
METRICS_BY_MODE = {"fpga": FPGA_METRICS, "asic": ASIC_METRICS}

# per-metric presentation: 'dir' is which way is better (the dashboard colors
# the winner green and shades losers yellow->red); 'unit' is appended in the
# cell; 'desc' is the explanation the dashboard shows under the metric tabs.
METRIC_INFO = {
    "cells":      {"label": "Cells",       "dir": "lower",  "unit": "",
                   "desc": "Total mapped standard-cell instances in the "
                           "synthesized netlist."},
    "luts":       {"label": "LUTs",        "dir": "lower",  "unit": "",
                   "desc": "LUTs and dedicated mux-fabric primitives that share "
                           "the LUT logic block (DSP and block RAM excluded)."},
    "dsps":       {"label": "DSPs",        "dir": "lower",  "unit": "",
                   "desc": "Hard multiplier / MAC / DSP blocks in the mapped "
                           "netlist."},
    "brams":      {"label": "BRAMs",       "dir": "lower",  "unit": "",
                   "desc": "Hardened block-RAM primitives in the mapped netlist "
                           "(distributed LUT-based RAM excluded)."},
    "logicdepth": {"label": "Logic depth", "dir": "lower",  "unit": "",
                   "desc": "Longest combinational path on the mapped netlist, "
                           "in cells (flip-flops excluded)."},
    "tasktime":   {"label": "Runtime",     "dir": "lower",  "unit": "s",
                   "desc": "Wall-clock runtime of the synthesis step, as "
                           "recorded by SiliconCompiler."},
    "memory":     {"label": "Peak memory", "dir": "lower",  "unit": "MB",
                   # values are already stored in MB (rescaled at collection)
                   "desc": "Peak process memory of the synthesis step, as "
                           "recorded by SiliconCompiler."},
    "leakagepower": {"label": "Leakage",   "dir": "lower",  "unit": "mW",
                     # SC records leakage power in milliwatts (raw value shown)
                     "desc": "Static leakage power of the synthesized netlist "
                             "from post-synthesis timing analysis."},
    "setuptns":   {"label": "Setup TNS",   "dir": "higher", "unit": "ns",
                   "desc": "Total negative setup slack across all endpoints "
                           "from post-synthesis static timing (0 is best)."},
    "cellarea":   {"label": "Cell area",   "dir": "lower",  "unit": "um^2",
                   "desc": "Total standard-cell area of the synthesized "
                           "netlist."},
    "fmax":       {"label": "Fmax",        "dir": "higher", "unit": "MHz",
                   # values are already stored in MHz (rescaled at collection)
                   "desc": "Maximum clock frequency from post-synthesis static "
                           "timing; combinational designs are timed against a "
                           "virtual clock."},
}


def benchmark_order():
    """(group, design-name) pairs in canonical group/definition order.

    Uses the SC design name (e.g. 'epfl_arbiter'), which keys the collected
    metrics, rather than the class name. Names are assumed unique across groups;
    a duplicate would show a row in each group.
    """
    order = []
    for group in GROUPS:
        mod = getattr(lb, group)
        for item in mod.__all__:
            order.append((group, getattr(mod, item)().name))
    return order


def _is_payload(data):
    """A per-target metrics file written by 'lb run --publish':
    {"meta": {"target", "options", ...}, "metrics": {metric: {bench: val}}}."""
    return (isinstance(data, dict)
            and isinstance(data.get("metrics"), dict)
            and isinstance(data.get("meta"), dict)
            and "target" in data["meta"])


def load_configs(results_dir):
    """{config: {target: payload}} -- one config per subdirectory of results_dir
    (e.g. results/fpga/small -> config 'small'), reading the per-target
    <target>.json collect files inside each. Non-payload files are skipped."""
    configs = {}
    for sub in sorted(glob.glob(os.path.join(results_dir, "*", ""))):
        config = os.path.basename(os.path.normpath(sub))
        collected = {}
        for path in sorted(glob.glob(os.path.join(sub, "*.json"))):
            if not os.path.isfile(path):
                continue   # a "*.json" glob can match directories; skip them
            with open(path) as f:
                data = json.load(f)
            if _is_payload(data):
                # key by file stem, not the embedded target, so variants of one
                # target (e.g. z1015 and z1015opt) are kept as
                # separate columns instead of overwriting each other.
                stem = os.path.splitext(os.path.basename(path))[0]
                collected[stem] = data
        if collected:
            configs[config] = collected
    return configs


def load_flat(results_dir):
    """{mode: {stem: payload}} from the flat <target>.json collect files directly
    under results_dir (no config subdirs).

    Each file is classified 'fpga' if its embedded target is an FPGA target, else
    'asic' (sc/yosys/tardigrade). Columns are keyed by file stem so target
    variants stay distinct. Non-payload files are skipped.
    """
    modes = {"fpga": {}, "asic": {}}
    for path in sorted(glob.glob(os.path.join(results_dir, "*.json"))):
        if not os.path.isfile(path):
            continue   # a "*.json" glob can match directories; skip them
        with open(path) as f:
            data = json.load(f)
        if not _is_payload(data):
            continue
        stem = os.path.splitext(os.path.basename(path))[0]
        mode = "fpga" if data["meta"]["target"] in FPGA_TARGETS else "asic"
        modes[mode][stem] = data
    return {m: c for m, c in modes.items() if c}


def build_section(targets, metric_names, collected):
    """Assemble one config's dashboard section: column order, display labels,
    per-target settings, metric metadata, group layout, and the
    {benchmark: {target: {metric: value}}} matrix. Benchmarks with no recorded
    value on any target are omitted. 'collected' is keyed by target."""
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
        # columns are keyed/labeled by file stem (e.g. z1015,
        # z1015opt); the dashboard header shows the stem directly.
        "targets": targets,
        # synthesis settings each column was produced with (shown under the
        # column name); empty string means defaults.
        "settings": {t: (collected.get(t, {}).get("meta", {}).get("options")
                         or "")
                     for t in targets},
        "metrics": [{"key": m, **METRIC_INFO[m]} for m in metric_names],
        "groups": [{"name": g, "benchmarks": by_group[g]}
                   for g in GROUPS if g in by_group],
        "data": data,
    }


def main():
    ap = argparse.ArgumentParser(description=__doc__,
                                 formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--results", default=os.path.join("results", "fpga"),
                    metavar="DIR",
                    help="Directory whose subdirectories are configs (each "
                         "holding per-target <target>.json collect files), "
                         "e.g. results/fpga/{small,fast} (default: results/fpga)")
    ap.add_argument("--metrics", choices=list(METRICS_BY_MODE), default="fpga",
                    help="metric set to tabulate: 'fpga' (luts/logicdepth/"
                         "tasktime) or 'asic' (cells/cellarea/fmax/logicdepth/"
                         "leakagepower/setuptns/memory/tasktime) (default: "
                         "fpga); ignored with --flat (derived per mode)")
    ap.add_argument("--flat", action="store_true",
                    help="read flat <target>.json collect files directly from "
                         "--results (no config subdirs), split them into fpga/asic "
                         "by target, and write one section per mode to "
                         "--out/<mode>/<config>.json")
    ap.add_argument("--out", metavar="DIR",
                    help="output directory for the section databases (default: "
                         "same as --results)")
    ap.add_argument("--config", default="default", metavar="NAME",
                    help="config/page name for the flat-mode section "
                         "(default: default)")
    args = ap.parse_args()

    out_dir = args.out if args.out else args.results

    if args.flat:
        modes = load_flat(args.results)
        if not modes:
            ap.error(f"no <target>.json collect files under {args.results}")
        for mode, collected in sorted(modes.items()):
            metric_names = METRICS_BY_MODE[mode]
            targets = sorted(collected, reverse=True)
            section = build_section(targets, metric_names, collected)
            subdir = os.path.join(out_dir, mode)
            os.makedirs(subdir, exist_ok=True)
            output = os.path.join(subdir, f"{args.config}.json")
            with open(output, "w") as f:
                json.dump(section, f, indent=2, sort_keys=True)
            print(f"{mode}/{args.config}: {len(section['data'])} benchmark(s) x "
                  f"{len(targets)} target(s) -> {output}")
        return

    metric_names = METRICS_BY_MODE[args.metrics]
    configs = load_configs(args.results)
    if not configs:
        ap.error(f"no <config>/<target>.json collect files under {args.results}")

    for config, collected in sorted(configs.items()):
        # columns: one per target (clean name), ordered alphabetically z->a
        targets = sorted(collected, reverse=True)
        section = build_section(targets, metric_names, collected)
        output = os.path.join(args.results, f"{config}.json")
        with open(output, "w") as f:
            json.dump(section, f, indent=2, sort_keys=True)
        print(f"{config}: {len(section['data'])} benchmark(s) x "
              f"{len(targets)} target(s) -> {output}")


if __name__ == "__main__":
    main()
