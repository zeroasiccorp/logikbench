#!/usr/bin/env python3
"""Analyze and visualize the ASIC synthesis results in results/syn/asic/.

Thin front-end over scripts/analyze_common.py for the ASIC (yosys + OpenSTA)
QoR: cell area, Fmax, leakage power, timing, plus cells/logic-depth/runtime.
Only the clean 'yosys_<pdk>' files are used; the stale 'sc_<pdk>' asicflow files
(flat schema, unrescaled Fmax) are skipped. The 'yosys_' prefix is stripped so
columns read as the PDK (asap7, freepdk45, gf180, ihp130, sky130).

Charts (matplotlib, static PNG/PDF):
  1. cross-PDK cell-area comparison (magnitude + efficiency-vs-median heatmaps)
  2. area vs Fmax (PPA)             (all PDKs overlaid)
  3. timing + power                 (Fmax and leakage distributions per PDK)
  4. synth cost                     (runtime + peak-memory distribution)
  5. pairwise parity scatters       (PDK vs PDK on area / Fmax)
  6. picorv32 area vs Fmax          (dual-axis connected lines)
  7. peak memory vs cell area       (all PDKs overlaid)
  8. runtime vs cell area           (all PDKs overlaid)
Plus report.md (coverage matrix, missing/NaN tally, schema-shape audit).

Note: Fmax and setuptns are higher-is-better (every other metric is lower).
"""

import argparse
import os
import re
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from analyze_common import (                                        # noqa: E402
    CAT, INK, INK2, MUTED, BASE, GRID, SURFACE, SEQ_STEPS, SEQ_CMAP, DIV_CMAP,
    _heatmap, _pivot, _style_axes, _savefig, load_results, order_targets,
    set_rcparams, chart_metric_scatter, chart_synth_cost, chart_pair_scatter,
    write_report)
import numpy as np                                                  # noqa: E402
import matplotlib.pyplot as plt                                     # noqa: E402

# Metric presentation (label, unit, lower-is-better). Fmax and setuptns are
# HIGHER-is-better; everything else is lower-is-better.
METRIC_META = {
    "cells":        ("Cells", "", True),
    "cellarea":     ("Cell area", "um^2", True),
    "fmax":         ("Fmax", "MHz", False),
    "logicdepth":   ("Logic depth", "cells", True),
    "leakagepower": ("Leakage", "mW", True),
    "setuptns":     ("Setup TNS", "ns", False),
    "memory":       ("Peak memory", "MB", True),
    "tasktime":     ("Runtime", "s", True),
}
METRICS = list(METRIC_META)

# Benchmark groups to analyze (koios/large excluded as incomplete).
GROUPS = ["basic", "memory", "arithmetic", "epfl", "blocks",
          "iscas85", "iscas89"]

# PDK column order (the yosys_ prefix is stripped for display).
PDKS = ["asap7", "freepdk45", "gf180", "ihp130", "sky130"]


# ---------------------------------------------------------------------------
# Chart 1: cross-PDK cell-area comparison
# ---------------------------------------------------------------------------
def chart_area_comparison(df, targets, outbase, exts):
    from matplotlib.colors import LogNorm, TwoSlopeNorm

    med = _pivot(df, "cellarea", targets, "median")

    # efficiency vs pack: per-benchmark ratio to the cross-PDK median, then the
    # geometric mean per group (mean of log2 ratios). Lower area is better, so
    # blue = smaller than the pack, red = larger.
    area = df[df["metric"] == "cellarea"].copy()
    pos = area["value"].where(area["value"] > 0)
    bench_med = area.groupby("benchmark")["value"].transform("median")
    area["log2ratio"] = np.log2(pos / bench_med.where(bench_med > 0))
    eff = area.pivot_table(index="group", columns="target",
                           values="log2ratio", aggfunc="mean")
    eff = eff.reindex(columns=[t for t in targets if t in eff.columns])
    eff = eff.reindex(index=med.index)

    fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(15, 5.2))
    fig.patch.set_facecolor(SURFACE)

    mvals = med.to_numpy(dtype=float)
    finite = mvals[np.isfinite(mvals) & (mvals > 0)]
    lognorm = LogNorm(vmin=max(finite.min(), 1e-3), vmax=finite.max()) \
        if finite.size else None
    _heatmap(ax1, mvals, list(med.index), list(med.columns), SEQ_CMAP,
             norm=lognorm, fmt="{:.0f}",
             title="Median cell area per group (um^2)",
             cbar_label="cell area (log)")

    evals = eff.to_numpy(dtype=float)
    amax = np.nanmax(np.abs(evals)) if np.isfinite(evals).any() else 1.0
    amax = max(amax, 0.1)
    divnorm = TwoSlopeNorm(vmin=-amax, vcenter=0.0, vmax=amax)
    _heatmap(ax2, evals, list(eff.index), list(eff.columns), DIV_CMAP,
             norm=divnorm, fmt="{:+.2f}",
             title="Cell-area efficiency vs cross-PDK median\n"
                   "(log2 ratio; blue = smaller, red = larger)",
             cbar_label="log2(pdk / median)")

    fig.suptitle("Cross-PDK cell-area comparison", color=INK, fontsize=13,
                 x=0.02, ha="left", fontweight="bold")
    fig.tight_layout(rect=(0, 0, 1, 0.96))
    _savefig(fig, outbase + "1_area_comparison", exts)


# ---------------------------------------------------------------------------
# Chart 3: timing + power (Fmax and leakage distributions per PDK)
# ---------------------------------------------------------------------------
def chart_timing_power(df, targets, outbase, exts):
    fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(15, 5.2))
    fig.patch.set_facecolor(SURFACE)

    def box(ax, metric, title, unit):
        data = []
        for t in targets:
            vals = df[(df["metric"] == metric) & (df["target"] == t)]["value"]
            vals = vals[np.isfinite(vals) & (vals > 0)]
            data.append(vals.to_numpy())
        bp = ax.boxplot(data, patch_artist=True, widths=0.6, showfliers=True)
        for patch in bp["boxes"]:
            patch.set_facecolor(SEQ_STEPS[2])
            patch.set_edgecolor(SEQ_STEPS[5])
            patch.set_alpha(0.9)
        for element in ("whiskers", "caps", "medians"):
            for line in bp[element]:
                line.set_color(SEQ_STEPS[6])
        for flier in bp["fliers"]:
            flier.set(marker="o", markersize=3, markerfacecolor=CAT[5],
                      markeredgecolor="none", alpha=0.6)
        ax.set_yscale("log")
        ax.set_xticks(range(1, len(targets) + 1))
        ax.set_xticklabels(targets, rotation=45, ha="right")
        ax.set_ylabel(f"{title} ({unit})")
        ax.set_title(f"{title} per benchmark", fontsize=11)
        _style_axes(ax)
        ax.grid(axis="y", color=GRID, linewidth=0.8, zorder=0)

    box(ax1, "fmax", "Fmax (higher is better)", "MHz")
    box(ax2, "leakagepower", "Leakage (lower is better)", "mW")

    fig.suptitle("Timing and power per PDK", color=INK, fontsize=13,
                 x=0.02, ha="left", fontweight="bold")
    fig.tight_layout(rect=(0, 0, 1, 0.96))
    _savefig(fig, outbase + "3_timing_power", exts)


# ---------------------------------------------------------------------------
# Chart 6: one benchmark's cell area vs Fmax across PDKs (dual axis)
# ---------------------------------------------------------------------------
def chart_benchmark_dual(df, name, targets, outbase, exts, out_id):
    """Cell area (left y) and Fmax (right y), both linear, for a single
    benchmark across the PDK columns, drawn as two connected lines on a shared
    x. Dual y-scales: each axis (spine, ticks, label) is colored to match its
    line so the two are not read against a common scale -- only each line's own
    left-to-right trend across nodes is meaningful."""
    sub = df[df["benchmark"] == name]

    def series(metric):
        vals = sub[sub["metric"] == metric].set_index("target")["value"]
        return [float(vals.get(t, np.nan)) for t in targets]

    area = series("cellarea")
    fmax = series("fmax")
    if not (np.isfinite(area).any() or np.isfinite(fmax).any()):
        print(f"  chart 6 skipped: no cellarea/fmax data for '{name}'")
        return

    x = list(range(len(targets)))
    ca_col, fm_col = CAT[0], CAT[1]

    fig, ax1 = plt.subplots(figsize=(10, 6))
    fig.patch.set_facecolor(SURFACE)
    ax1.set_facecolor(SURFACE)
    ax2 = ax1.twinx()

    ax1.plot(x, area, marker="o", ms=8, lw=2, color=ca_col, zorder=3,
             label="Cell area")
    ax1.set_ylabel("Cell area (um^2)", color=ca_col)
    ax2.plot(x, fmax, marker="s", ms=8, lw=2, color=fm_col, zorder=3,
             label="Fmax")
    ax2.set_ylabel("Fmax (MHz)", color=fm_col)

    ax1.set_xticks(x)
    ax1.set_xticklabels(targets, rotation=30, ha="right")
    ax1.set_xlim(-0.35, len(targets) - 0.65)

    # each y-axis wears its line's color; keep the two outer spines, drop the
    # rest, and put a light horizontal grid under the (left-axis) marks.
    for ax in (ax1, ax2):
        ax.spines["top"].set_visible(False)
    ax1.spines["right"].set_visible(False)
    ax2.spines["top"].set_visible(False)
    ax2.spines["left"].set_visible(False)
    ax2.spines["bottom"].set_visible(False)
    ax1.spines["left"].set_color(ca_col)
    ax1.spines["bottom"].set_color(BASE)
    ax2.spines["right"].set_color(fm_col)
    ax1.tick_params(axis="y", colors=ca_col, labelsize=9)
    ax2.tick_params(axis="y", colors=fm_col, labelsize=9)
    ax1.tick_params(axis="x", colors=MUTED, labelsize=10)
    ax1.grid(axis="y", color=GRID, linewidth=0.7, zorder=0)

    ax1.set_title(f"{name}: cell area vs Fmax across PDKs", color=INK,
                  fontsize=13, loc="left", fontweight="bold", pad=10)
    lines = ax1.get_lines() + ax2.get_lines()
    ax1.legend(lines, [ln.get_label() for ln in lines], frameon=False,
               fontsize=10, labelcolor=INK2, loc="upper center", ncol=2)
    fig.tight_layout()
    _savefig(fig, outbase + out_id, exts)


# ---------------------------------------------------------------------------
# Orchestration
# ---------------------------------------------------------------------------
def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--results", default=os.path.join("results", "syn", "asic"),
                    help="directory of per-target *.json files "
                         "(default: results/syn/asic)")
    ap.add_argument("--out", default=os.path.join("analysis", "asic"),
                    help="output directory (default: analysis/asic)")
    ap.add_argument("--format", choices=["png", "pdf", "both"], default="png",
                    help="chart file format (default: png)")
    ap.add_argument("--targets", nargs="+",
                    help="restrict to these PDKs")
    ap.add_argument("--groups", nargs="+",
                    help=f"benchmark groups to analyze (default: {GROUPS}; "
                         "koios/large excluded as incomplete)")
    args = ap.parse_args()

    # keep only the clean yosys_<pdk> synth+STA files (skip stale sc_<pdk>).
    df, files_meta = load_results(
        args.results, METRICS,
        keep=lambda d: d["meta"].get("target", "").startswith("yosys_"))
    if df.empty:
        raise SystemExit(f"no yosys_<pdk> ASIC results under {args.results}")
    # strip the tool prefix so columns read as the PDK (yosys_asap7 -> asap7)
    df["target"] = df["target"].str.replace(r"^yosys_", "", regex=True)
    for m in files_meta.values():
        m["target"] = re.sub(r"^yosys_", "", m["target"])

    df = df[df["group"].isin(args.groups or GROUPS)]
    if args.targets:
        df = df[df["target"].isin(args.targets)]

    set_rcparams()
    # order PDKs by median 'blocks'-group cell area, descending, so the largest
    # node (gf180) is leftmost; PDKs with no blocks data fall back to the end.
    blocks_area = (df[(df["metric"] == "cellarea") & (df["group"] == "blocks")]
                   .groupby("target")["value"].median()
                   .sort_values(ascending=False))
    targets = list(blocks_area.index)
    targets += [t for t in order_targets(df, canon=PDKS) if t not in targets]
    os.makedirs(args.out, exist_ok=True)
    exts = ["png", "pdf"] if args.format == "both" else [args.format]
    base = os.path.join(args.out, "asic_")

    df.sort_values(["metric", "group", "benchmark", "target"]).to_csv(
        os.path.join(args.out, "summary.csv"), index=False)

    chart_area_comparison(df, targets, base, exts)
    chart_metric_scatter(df, "cellarea", "fmax", targets, METRIC_META, base,
                         exts, "2_area_vs_fmax")
    chart_timing_power(df, targets, base, exts)
    chart_synth_cost(df, targets, base, exts)
    chart_pair_scatter(df, "asap7", "sky130", "cellarea", METRIC_META, base,
                       exts)
    chart_pair_scatter(df, "asap7", "sky130", "fmax", METRIC_META, base, exts)
    chart_benchmark_dual(df, "picorv32", targets, base, exts,
                         "6_picorv32_area_fmax")
    chart_metric_scatter(df, "cellarea", "memory", targets, METRIC_META, base,
                         exts, "7_area_vs_memory")
    chart_metric_scatter(df, "cellarea", "tasktime", targets, METRIC_META, base,
                         exts, "8_area_vs_tasktime")
    write_report(df, files_meta, targets, METRICS,
                 os.path.join(args.out, "report.md"),
                 "ASIC results: data-quality report")

    n_bench = df.dropna(subset=["value"])["benchmark"].nunique()
    print(f"Loaded {len(files_meta)} PDK files, {n_bench} benchmarks -> "
          f"{args.out}")
    print(f"  charts: asic_1..8.{'/'.join(exts)}  + summary.csv + report.md")


if __name__ == "__main__":
    main()
