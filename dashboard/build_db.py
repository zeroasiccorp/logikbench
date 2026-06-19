#!/usr/bin/env python3
"""Build per-config dashboard databases from collected FPGA results.

'lb collect --suffix _<config>' writes one file per (target, config) as
results/fpga/<target>_<config>.json. This groups those by config and writes one
self-describing database per config to results/fpga/<config>.json, which
dashboard/generate.py renders as one page per config.

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
from logikbench.benchmark import FPGA_METRICS

# benchmark groups, in display order
GROUPS = ['basic', 'memory', 'arithmetic', 'epfl', 'blocks']

# per-metric presentation: 'dir' is which way is better (the dashboard colors
# the winner green and shades losers yellow->red); 'unit' is appended in the cell.
METRIC_INFO = {
    "cells":      {"label": "Cells",       "dir": "lower",  "unit": ""},
    "luts":       {"label": "LUTs",        "dir": "lower",  "unit": ""},
    "logicdepth": {"label": "Logic depth", "dir": "lower",  "unit": ""},
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


def _is_payload(data):
    """A 'lb collect' payload: {"target", "options", "metrics": {...}}."""
    return (isinstance(data, dict) and "target" in data
            and isinstance(data.get("metrics"), dict))


def load_configs(results_dir):
    """{config: {target: payload}} from the <target>_<config>.json collect files
    in results_dir. Section/db files (which lack a "target" key) are skipped, so
    re-running over the same directory is safe."""
    configs = {}
    for path in sorted(glob.glob(os.path.join(results_dir, "*.json"))):
        with open(path) as f:
            data = json.load(f)
        if not _is_payload(data):
            continue
        target = data["target"]
        stem = os.path.splitext(os.path.basename(path))[0]
        # config = the suffix lb collect appended after the target name
        config = stem[len(target) + 1:] if stem.startswith(target + "_") else ""
        configs.setdefault(config, {})[target] = data
    return configs


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
        "targets": targets,
        # display name per column (here the clean target; one config per db)
        "labels": {t: (collected.get(t, {}).get("target") or t) for t in targets},
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
    ap.add_argument("--results", default=os.path.join("results", "fpga"),
                    metavar="DIR",
                    help="Directory with the <target>_<config>.json collect "
                         "files (default: results/fpga)")
    args = ap.parse_args()

    configs = load_configs(args.results)
    if not configs:
        ap.error(f"no <target>_<config>.json collect files under {args.results}")

    for config, collected in sorted(configs.items()):
        # columns: one per target (clean name), ordered alphabetically z->a
        targets = sorted(collected, reverse=True)
        section = build_section(targets, FPGA_METRICS, collected)
        output = os.path.join(args.results, f"{config}.json")
        with open(output, "w") as f:
            json.dump(section, f, indent=2, sort_keys=True)
        print(f"{config}: {len(section['data'])} benchmark(s) x "
              f"{len(targets)} target(s) -> {output}")


if __name__ == "__main__":
    main()
