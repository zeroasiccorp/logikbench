#!/usr/bin/env python3
"""Offline re-extraction of FPGA synthesis metrics from kept build artifacts.

Re-applies the current cell classifier (logikbench.tools.yosys.yosys._CELLMAP)
to each benchmark's retained reports/stat.json (and reports/ltp.rpt for logic
depth) WITHOUT re-synthesizing, rewrites the recorded metric values in the job
manifest, then regenerates the per-target results via the normal save/publish
path. Runtime metrics (memory, tasktime) are left untouched -- they are not
derivable from stat.json.

Use after a _CELLMAP change so the fix lands in results without a full re-run
(clean_build keeps reports/stat.json + reports/ltp.rpt for exactly this). Only
works where those reports survived; a benchmark missing stat.json is reported
and left as-is (it needs a real re-synthesis). A metric absent from an older
manifest's schema is skipped (that manifest predates the metric).

Usage:
    python scripts/reextract_fpga.py [-b build] [--targets virtex7 ...]
                                     [--publish/--no-publish]
"""
import argparse
import json
import os
import re
import sys
from types import SimpleNamespace

from logikbench.fpga import FPGA_TARGETS
from logikbench.tools.yosys.yosys import classify_cells, _vendor_from_command
from logikbench.apps.lb import save_target, publish_target_task, should_publish

_LTP_RE = re.compile(r"Longest topological path .*\(length=(\d+)\)")


def _read_logicdepth(ltp_path):
    """Longest-path length from a reports/ltp.rpt, or None if absent/empty."""
    if not os.path.isfile(ltp_path):
        return None
    depth = None
    with open(ltp_path) as fh:
        for line in fh:
            match = _LTP_RE.search(line)
            if match:
                depth = int(match.group(1))
    return depth


def _update_manifest(manifest_path, values):
    """Overwrite the synthesis-node value of each metric in 'values' in the job
    manifest. Returns (updated, skipped): skipped are metrics with no synthesis
    entry in this manifest (it predates the metric)."""
    with open(manifest_path) as fh:
        data = json.load(fh)
    updated, skipped = [], []
    for metric, value in values.items():
        if value is None:
            continue
        node = data.get("metric", {}).get(metric, {}).get("node", {})
        syn = node.get("synthesis")
        if not syn:
            skipped.append(metric)
            continue
        for rec in syn.values():
            rec["value"] = value
        updated.append(metric)
    with open(manifest_path, "w") as fh:
        json.dump(data, fh, indent=2)
    return updated, skipped


def reextract_target(target, builddir):
    """Re-classify every benchmark of one target from its kept reports and
    rewrite the manifests. Returns (worklist, stats) where worklist is the
    (group, None, name) triples touched and stats is a summary dict."""
    tdir = os.path.join(builddir, target)
    vendor = _vendor_from_command(FPGA_TARGETS[target])
    worklist = []
    unclassified = {}
    n_ok = n_nostat = 0
    missing_metric = set()
    if not os.path.isdir(tdir):
        return worklist, {"ok": 0, "nostat": 0, "unclassified": {},
                          "missing_metric": set()}
    for group in sorted(os.listdir(tdir)):
        gdir = os.path.join(tdir, group)
        if not os.path.isdir(gdir):
            continue
        for name in sorted(os.listdir(gdir)):
            job = os.path.join(gdir, name, "job0")
            manifest = os.path.join(job, f"{name}.pkg.json")
            if not os.path.isfile(manifest):
                continue
            worklist.append((group, None, name))
            reports = os.path.join(job, "synthesis", "0", "reports")
            stat = os.path.join(reports, "stat.json")
            if not os.path.isfile(stat):
                n_nostat += 1
                continue
            with open(stat) as fh:
                stats = json.load(fh)
            by_type = stats.get("design", stats).get("num_cells_by_type", {})
            counts, unc = classify_cells(by_type, vendor)
            for cell, num in unc.items():
                unclassified[cell] = unclassified.get(cell, 0) + num
            # refresh the per-benchmark report so it reflects this classifier
            # (remove a stale one when the fix closed all gaps).
            report = os.path.join(reports, "fpga_unclassified.json")
            if unc:
                with open(report, "w") as fh:
                    json.dump({"vendor": vendor, "cells": unc}, fh,
                              indent=2, sort_keys=True)
            elif os.path.exists(report):
                os.remove(report)
            values = dict(counts)
            values["logicdepth"] = _read_logicdepth(
                os.path.join(reports, "ltp.rpt"))
            _, skipped = _update_manifest(manifest, values)
            missing_metric.update(skipped)
            n_ok += 1
    return worklist, {"ok": n_ok, "nostat": n_nostat,
                      "unclassified": unclassified,
                      "missing_metric": missing_metric}


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("-b", dest="builddir", default="build", metavar="DIR",
                    help="build directory root (default: build)")
    ap.add_argument("--targets", nargs="+",
                    help="FPGA targets to re-extract (default: all present)")
    ap.add_argument("--publish", action=argparse.BooleanOptionalAction,
                    default=None,
                    help="publish into the committed results tree "
                         "(default: autodetect, on in a git clone)")
    args = ap.parse_args()

    targets = args.targets or [t for t in FPGA_TARGETS
                               if os.path.isdir(os.path.join(args.builddir, t))]
    if not targets:
        raise SystemExit(f"no FPGA target build dirs under {args.builddir}")

    all_unclassified = {}
    for target in targets:
        if target not in FPGA_TARGETS:
            print(f"skip unknown target '{target}'", file=sys.stderr)
            continue
        worklist, st = reextract_target(target, args.builddir)
        if not worklist:
            print(f"{target}: no benchmarks built, skipping")
            continue
        # regenerate results from the rewritten manifests (normal save/publish)
        sargs = SimpleNamespace(builddir=args.builddir, label=None,
                                name=None, publish=args.publish)
        save_target(target, sargs, worklist)
        if should_publish(sargs):
            publish_target_task("syn", [target], sargs)
        note = f"re-extracted {st['ok']}"
        if st["nostat"]:
            note += f", {st['nostat']} missing stat.json (need re-synth)"
        if st["missing_metric"]:
            note += (f", metrics absent from old manifests: "
                     f"{sorted(st['missing_metric'])}")
        print(f"{target}: {note}")
        for cell, num in st["unclassified"].items():
            all_unclassified[cell] = all_unclassified.get(cell, 0) + num

    if all_unclassified:
        print("\nUNCLASSIFIED cell types (add to _CELLMAP):")
        for cell, num in sorted(all_unclassified.items(),
                                key=lambda kv: -kv[1]):
            print(f"  {cell}: {num}")
    else:
        print("\nAll cells classified (no _CELLMAP gaps).")


if __name__ == "__main__":
    main()
