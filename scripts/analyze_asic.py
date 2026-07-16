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
  9. median cell area per group     (one line per group across nodes)
 10. EPFL Fmax ratio                (tardigrade/yosys per benchmark; asap7)
 11. EPFL Fmax dumbbell             (yosys vs tardigrade absolute; asap7)
 12. median cell area per group     (as a ratio, each node normalized to asap7)
 13. benchmark size histogram       (tardigrade cell count, log-binned)
Plus report.md (coverage matrix, missing/NaN tally, schema-shape audit).

Charts 10-11 need the tardigrade_<pdk> results alongside yosys_<pdk>; they
are skipped when those files are absent.

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

# Caption for the group-median cell-area charts (9, 12). The 'memory' group's
# RAM area is not comparable across PDKs: RAMs map to an SRAM macro on some
# nodes and a standard-cell/flop fallback on others, so the area can rise at a
# smaller node (e.g. sky130 > gf180). 'ramtdpdc' has no area (synth drops the
# RAM to ~5 cells and timing fails), so it is dropped from the median.
MEM_AREA_NOTE = (
    "Note: sky130 'memory' area is inflated and not node-comparable -- "
    "lambdapdk ships a single sky130 SRAM macro, so RAM shapes are tiled with "
    "glue (e.g. sky130 > gf180); ramtdpdc omitted (no area, timing fails).")


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
# Chart 9: median cell area per group across PDKs (one line per group)
# ---------------------------------------------------------------------------
def chart_group_area(df, targets, outbase, exts, out_id):
    """Median cell area per benchmark group across the PDK columns, one
    connected line per group on a shared x (log y). Same node ordering as chart
    6 (widest process leftmost); no Fmax axis. Reads each group's per-node
    left-to-right shrink as the process scales down."""
    med = _pivot(df, "cellarea", targets, "median")     # group x node medians
    x = list(range(len(targets)))

    fig, ax = plt.subplots(figsize=(9, 6))
    fig.patch.set_facecolor(SURFACE)
    ax.set_facecolor(SURFACE)
    for i, group in enumerate(GROUPS):
        if group not in med.index:
            continue
        yv = [float(med.loc[group, t]) for t in targets]
        ax.plot(x, yv, marker="o", ms=7, lw=2, color=CAT[i % len(CAT)],
                zorder=3, label=group)

    ax.set_yscale("log")
    ax.set_xticks(x)
    ax.set_xticklabels(targets, rotation=30, ha="right")
    ax.set_xlim(-0.35, len(targets) - 0.65)
    ax.set_ylabel("Median cell area (um^2)")
    ax.spines["top"].set_visible(False)
    ax.spines["right"].set_visible(False)
    ax.spines["left"].set_color(BASE)
    ax.spines["bottom"].set_color(BASE)
    ax.tick_params(colors=MUTED, labelsize=9)
    ax.grid(axis="y", color=GRID, linewidth=0.7, zorder=0)
    ax.set_title("Median cell area per group across PDKs", color=INK,
                 fontsize=13, loc="left", fontweight="bold", pad=10)
    ax.legend(frameon=False, fontsize=9, labelcolor=INK2, loc="upper right")
    fig.tight_layout(rect=[0, 0.06, 1, 1])   # reserve bottom band for note
    fig.text(0.01, 0.015, MEM_AREA_NOTE, fontsize=7, color=MUTED,
             ha="left", va="bottom")
    _savefig(fig, outbase + out_id, exts)


# ---------------------------------------------------------------------------
# Chart 12: median cell area per group, normalized to asap7 (one line per group)
# ---------------------------------------------------------------------------
def chart_group_area_ratio(df, targets, outbase, exts, out_id):
    """Median cell area per group across nodes, each group divided by its own
    asap7 median so asap7 = 1.0 and every wider node shows its area inflation
    relative to asap7 (linear y). Same node ordering as chart 9. Groups that scale
    uniformly with the process overlap; divergence flags group-specific scaling
    (e.g. SRAM-macro-driven 'memory')."""
    med = _pivot(df, "cellarea", targets, "median")     # group x node medians
    if "asap7" not in med.columns:
        print("  chart 12 skipped: no asap7 cellarea data to normalize to")
        return
    x = list(range(len(targets)))

    fig, ax = plt.subplots(figsize=(9, 6))
    fig.patch.set_facecolor(SURFACE)
    ax.set_facecolor(SURFACE)
    for i, group in enumerate(GROUPS):
        if group not in med.index:
            continue
        base_val = med.loc[group, "asap7"]
        if not base_val or np.isnan(base_val):
            continue
        yv = [float(med.loc[group, t]) / float(base_val) for t in targets]
        ax.plot(x, yv, marker="o", ms=7, lw=2, color=CAT[i % len(CAT)],
                zorder=3, label=group)

    ax.axhline(1.0, color=BASE, lw=1, zorder=2)          # asap7 baseline
    ax.set_xticks(x)
    ax.set_xticklabels(targets, rotation=30, ha="right")
    ax.set_xlim(-0.35, len(targets) - 0.65)
    ax.set_ylim(bottom=0)
    ax.set_ylabel("Median cell area / asap7  (x)")
    ax.spines["top"].set_visible(False)
    ax.spines["right"].set_visible(False)
    ax.spines["left"].set_color(BASE)
    ax.spines["bottom"].set_color(BASE)
    ax.tick_params(colors=MUTED, labelsize=9)
    ax.grid(axis="y", color=GRID, linewidth=0.7, zorder=0)
    ax.set_axisbelow(True)
    ax.set_title("Median cell area per group, normalized to asap7", color=INK,
                 fontsize=13, loc="left", fontweight="bold", pad=10)
    ax.legend(frameon=False, fontsize=9, labelcolor=INK2, loc="upper right")
    fig.tight_layout(rect=[0, 0.06, 1, 1])   # reserve bottom band for note
    fig.text(0.01, 0.015, MEM_AREA_NOTE, fontsize=7, color=MUTED,
             ha="left", va="bottom")
    _savefig(fig, outbase + out_id, exts)


# ---------------------------------------------------------------------------
# Charts 10-11: yosys vs tardigrade comparison (one benchmark group, one PDK)
#
# These load BOTH tools directly (yosys_<pdk> and tardigrade_<pdk>) and are kept apart
# from the yosys-only dataframe above: that pipeline strips the tool prefix and
# treats the column as the PDK, so merging tardigrade into it would corrupt
# charts 1-9. Fmax is higher-is-better, so ratio = tardigrade / yosys (>1 means
# tardigrade is faster).
# ---------------------------------------------------------------------------
def _tool_pair(results_dir, pdk, group, metric):
    """(names, yosys_vals, tardigrade_vals) for one group/metric/PDK, over the
    benchmarks present in both tools, sorted by tardigrade/yosys ratio."""
    import json
    with open(os.path.join(results_dir, f"yosys_{pdk}.json")) as fh:
        y = json.load(fh)["metrics"][metric].get(group, {})
    with open(os.path.join(results_dir, f"tardigrade_{pdk}.json")) as fh:
        t = json.load(fh)["metrics"][metric].get(group, {})
    names = sorted(set(y) & set(t), key=lambda n: t[n] / y[n])
    return names, [y[n] for n in names], [t[n] for n in names]


def chart_tool_ratio(results_dir, pdk, group, outbase, exts, out_id):
    """Bar chart of tardigrade/yosys Fmax ratio per benchmark, sorted low to
    high (benchmark on x, ratio on y); parity line at 1.0."""
    names, yv, tv = _tool_pair(results_dir, pdk, group, "fmax")
    ratio = [t / y for t, y in zip(tv, yv)]
    x = list(range(len(names)))
    colors = [CAT[1] if r >= 1 else CAT[5] for r in ratio]

    fig, ax = plt.subplots(figsize=(9, 6))
    fig.patch.set_facecolor(SURFACE)
    ax.set_facecolor(SURFACE)
    ax.bar(x, ratio, color=colors, zorder=3)
    ax.axhline(1.0, color=BASE, lw=1, zorder=2)
    for i, r in enumerate(ratio):
        ax.text(i, r + max(ratio) * 0.012, f"{r:.2f}", ha="center",
                fontsize=8, color=INK2)
    ax.set_xticks(x)
    ax.set_xticklabels(names, rotation=45, ha="right")
    ax.set_ylabel("tardigrade / yosys Fmax  (>1 = tardigrade faster)")
    ax.set_ylim(0, max(ratio) * 1.12)
    ax.spines["top"].set_visible(False)
    ax.spines["right"].set_visible(False)
    ax.spines["left"].set_color(BASE)
    ax.spines["bottom"].set_color(BASE)
    ax.tick_params(colors=MUTED, labelsize=9)
    ax.grid(axis="y", color=GRID, linewidth=0.7, zorder=0)
    ax.set_axisbelow(True)
    ax.set_title(f"{group} Fmax gain: tardigrade vs yosys ({pdk})", color=INK,
                 fontsize=13, loc="left", fontweight="bold", pad=10)
    fig.tight_layout()
    _savefig(fig, outbase + out_id, exts)


def chart_tool_dumbbell(results_dir, pdk, group, outbase, exts, out_id):
    """Dumbbell of absolute Fmax per benchmark: a yosys dot and a tardigrade dot
    linked per row, log x, sorted by tardigrade/yosys ratio."""
    names, yv, tv = _tool_pair(results_dir, pdk, group, "fmax")
    y = list(range(len(names)))

    fig, ax = plt.subplots(figsize=(8, 7))
    fig.patch.set_facecolor(SURFACE)
    ax.set_facecolor(SURFACE)
    for i, (a, b) in enumerate(zip(yv, tv)):
        ax.plot([a, b], [i, i], color=MUTED, lw=1.5, zorder=1)
    ax.scatter(yv, y, color=CAT[0], s=45, zorder=3, label="yosys")
    ax.scatter(tv, y, color=CAT[1], s=45, zorder=3, label="tardigrade")
    ax.set_xscale("log")
    ax.set_yticks(y)
    ax.set_yticklabels(names)
    ax.set_xlabel("Fmax (MHz, log scale)")
    ax.spines["top"].set_visible(False)
    ax.spines["right"].set_visible(False)
    ax.spines["left"].set_color(BASE)
    ax.spines["bottom"].set_color(BASE)
    ax.tick_params(colors=MUTED, labelsize=9)
    ax.grid(axis="x", color=GRID, linewidth=0.7, zorder=0)
    ax.set_axisbelow(True)
    ax.set_title(f"{group} Fmax: yosys vs tardigrade ({pdk})", color=INK,
                 fontsize=13, loc="left", fontweight="bold", pad=10)
    ax.legend(frameon=False, fontsize=10, labelcolor=INK2, loc="lower right")
    fig.tight_layout()
    _savefig(fig, outbase + out_id, exts)


# ---------------------------------------------------------------------------
# Chart 13: benchmark size distribution (tardigrade cell count, log-binned)
# ---------------------------------------------------------------------------
def chart_cell_histogram(results_dir, pdk, outbase, exts, out_id):
    """Histogram of benchmark size (post-synthesis cell count) over all
    tardigrade_<pdk> benchmarks. Log-binned: cell counts span ~6 decades
    (single gates to million-cell cores), so linear bins are useless."""
    import json
    with open(os.path.join(results_dir, f"tardigrade_{pdk}.json")) as fh:
        cells = json.load(fh)["metrics"]["cells"]
    vals = [v for grp in cells.values() if isinstance(grp, dict)
            for v in grp.values() if isinstance(v, (int, float)) and v > 0]
    bins = np.logspace(0, 7, 29)   # 1 .. 1e7, ~4 bins/decade (resolve the tail)

    fig, ax = plt.subplots(figsize=(9, 5.5))
    fig.patch.set_facecolor(SURFACE)
    ax.set_facecolor(SURFACE)
    ax.hist(vals, bins=bins, color=CAT[1], edgecolor=SURFACE, linewidth=0.6,
            zorder=3)
    ax.set_xscale("log")
    ax.set_xlabel("Cell count (log scale)")
    ax.set_ylabel(f"Benchmarks (n = {len(vals)})")
    ax.spines["top"].set_visible(False)
    ax.spines["right"].set_visible(False)
    ax.spines["left"].set_color(BASE)
    ax.spines["bottom"].set_color(BASE)
    ax.tick_params(colors=MUTED, labelsize=9)
    ax.grid(axis="y", color=GRID, linewidth=0.7, zorder=0)
    ax.set_axisbelow(True)
    ax.set_title(f"Benchmark size distribution -- tardigrade {pdk} (cell count)",
                 color=INK, fontsize=13, loc="left", fontweight="bold", pad=10)
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
    chart_group_area(df, targets, base, exts, "9_group_median_cellarea")
    chart_group_area_ratio(df, targets, base, exts,
                           "12_group_median_cellarea_ratio")

    # yosys-vs-tardigrade comparison (asap7 EPFL) -- only if tardigrade results exist
    cmp_pdk = "asap7"
    if (os.path.isfile(os.path.join(args.results, f"yosys_{cmp_pdk}.json"))
            and os.path.isfile(os.path.join(args.results,
                                            f"tardigrade_{cmp_pdk}.json"))):
        chart_tool_ratio(args.results, cmp_pdk, "epfl", base, exts,
                         f"10_epfl_fmax_ratio_{cmp_pdk}")
        chart_tool_dumbbell(args.results, cmp_pdk, "epfl", base, exts,
                            f"11_epfl_fmax_dumbbell_{cmp_pdk}")
        chart_cell_histogram(args.results, cmp_pdk, base, exts,
                             f"13_tardigrade_cell_histogram_{cmp_pdk}")
    else:
        print(f"  charts 10-11,13 skipped: no tardigrade_{cmp_pdk}.json")
    write_report(df, files_meta, targets, METRICS,
                 os.path.join(args.out, "report.md"),
                 "ASIC results: data-quality report")

    n_bench = df.dropna(subset=["value"])["benchmark"].nunique()
    print(f"Loaded {len(files_meta)} PDK files, {n_bench} benchmarks -> "
          f"{args.out}")
    print(f"  charts: asic_1..13.{'/'.join(exts)}  + summary.csv + report.md")


if __name__ == "__main__":
    main()
