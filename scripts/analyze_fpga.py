#!/usr/bin/env python3
"""Analyze and visualize the FPGA synthesis results in results/syn/fpga/.

Thin front-end over scripts/analyze_common.py: supplies the FPGA metric set and
the FPGA-only charts (cross-target LUT comparison, DSP/BRAM resource mix), and
drives the shared charts (metric-vs-metric overlays, synth-cost boxes, pairwise
parity scatters, single-benchmark bars) + the data-quality report.

Charts (matplotlib, static PNG/PDF):
  1. cross-target LUT comparison   (magnitude + efficiency-vs-median heatmaps)
  2. resource mix                  (DSP/BRAM inference rate + DSP totals)
  3. area vs logic-depth           (all targets overlaid)
  4. synth cost                    (runtime + peak-memory distribution)
  5. pairwise parity scatters      (target vs target on one metric)
  6. picorv32 cells + logic depth  (paired bars)
  7. peak memory vs LUTs           (all targets overlaid)
  8. runtime vs LUTs               (all targets overlaid)
Plus report.md (coverage matrix, missing/NaN tally, schema-shape audit).
"""

import argparse
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from analyze_common import (                                        # noqa: E402
    CAT, INK, INK2, GRID, SURFACE, SEQ_CMAP, DIV_CMAP, AQUA_CMAP,
    _pivot, _heatmap, _style_axes, _savefig, load_results, order_targets,
    set_rcparams, chart_metric_scatter, chart_synth_cost, chart_pair_scatter,
    chart_benchmark_bars, write_report)
import numpy as np                                                  # noqa: E402
import matplotlib.pyplot as plt                                     # noqa: E402

# Metric presentation (label, unit, lower-is-better). Every FPGA metric is
# lower-is-better.
METRIC_META = {
    "cells":      ("Cells", "", True),
    "luts":       ("LUTs", "", True),
    "muxes":      ("Muxes", "", True),
    "lutram":     ("LUT RAM", "", True),
    "dsps":       ("DSPs", "", True),
    "brams":      ("BRAMs", "", True),
    "registers":  ("Registers", "", True),
    "latches":    ("Latches", "", True),
    "carrycells": ("Carry cells", "", True),
    "logicdepth": ("Logic depth", "cells", True),
    "memory":     ("Peak memory", "MB", True),
    "tasktime":   ("Runtime", "s", True),
}
METRICS = list(METRIC_META)

# Benchmark groups to analyze, in display order. 'koios' and 'large' are
# excluded for now -- those sweeps are incomplete (not run across all targets).
# Override with --groups.
GROUPS = ["basic", "memory", "arithmetic", "epfl", "blocks",
          "iscas85", "iscas89"]


# ---------------------------------------------------------------------------
# Chart 1: cross-target LUT comparison
# ---------------------------------------------------------------------------
def chart_lut_comparison(df, targets, outbase, exts):
    from matplotlib.colors import LogNorm, TwoSlopeNorm

    med = _pivot(df, "luts", targets, "median")

    # efficiency vs pack: per-benchmark ratio to the cross-target median, then
    # the geometric mean per group (mean of log2 ratios).
    luts = df[df["metric"] == "luts"].copy()
    pos = luts["value"].where(luts["value"] > 0)
    bench_med = luts.groupby("benchmark")["value"].transform("median")
    luts["log2ratio"] = np.log2(pos / bench_med.where(bench_med > 0))
    eff = luts.pivot_table(index="group", columns="target",
                           values="log2ratio", aggfunc="mean")
    eff = eff.reindex(columns=[t for t in targets if t in eff.columns])
    eff = eff.reindex(index=med.index)

    fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(15, 5.2))
    fig.patch.set_facecolor(SURFACE)

    mvals = med.to_numpy(dtype=float)
    finite = mvals[np.isfinite(mvals) & (mvals > 0)]
    lognorm = LogNorm(vmin=max(finite.min(), 1), vmax=finite.max()) \
        if finite.size else None
    _heatmap(ax1, mvals, list(med.index), list(med.columns), SEQ_CMAP,
             norm=lognorm, fmt="{:.0f}",
             title="Median LUTs per group", cbar_label="LUTs (log)")

    evals = eff.to_numpy(dtype=float)
    amax = np.nanmax(np.abs(evals)) if np.isfinite(evals).any() else 1.0
    amax = max(amax, 0.1)
    divnorm = TwoSlopeNorm(vmin=-amax, vcenter=0.0, vmax=amax)
    _heatmap(ax2, evals, list(eff.index), list(eff.columns), DIV_CMAP,
             norm=divnorm, fmt="{:+.2f}",
             title="LUT efficiency vs cross-target median\n"
                   "(log2 ratio; blue = fewer LUTs, red = more)",
             cbar_label="log2(target / median)")

    fig.suptitle("Cross-target LUT comparison", color=INK, fontsize=13,
                 x=0.02, ha="left", fontweight="bold")
    fig.tight_layout(rect=(0, 0, 1, 0.96))
    _savefig(fig, outbase + "1_lut_comparison", exts)


# ---------------------------------------------------------------------------
# Chart 2: resource mix (DSP / BRAM)
# ---------------------------------------------------------------------------
def chart_resource_mix(df, targets, outbase, exts):
    def inference_counts(metric):
        sub = df[df["metric"] == metric]
        used = sub[sub["value"] > 0].groupby("target")["benchmark"].nunique()
        return [int(used.get(t, 0)) for t in targets]

    dsp_users = inference_counts("dsps")
    bram_users = inference_counts("brams")

    fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(15, 5.2),
                                   gridspec_kw={"width_ratios": [1.1, 1]})
    fig.patch.set_facecolor(SURFACE)

    x = np.arange(len(targets))
    w = 0.38
    ax1.bar(x - w / 2, dsp_users, w, color=CAT[0], label="uses DSP",
            zorder=3)
    ax1.bar(x + w / 2, bram_users, w, color=CAT[1], label="uses BRAM",
            zorder=3)
    _style_axes(ax1)
    ax1.set_xticks(x)
    ax1.set_xticklabels(targets, rotation=45, ha="right")
    ax1.set_ylabel("benchmarks (count)")
    ax1.set_title("Hard-block inference rate", fontsize=11)
    ax1.grid(axis="y", color=GRID, linewidth=0.8, zorder=0)
    ax1.legend(frameon=False, fontsize=8, labelcolor=INK2)
    for xi, (d, b) in enumerate(zip(dsp_users, bram_users)):
        ax1.text(xi - w / 2, d, str(d), ha="center", va="bottom",
                 fontsize=7, color=INK2)
        ax1.text(xi + w / 2, b, str(b), ha="center", va="bottom",
                 fontsize=7, color=INK2)

    dsp_tot = _pivot(df, "dsps", targets, "sum")
    _heatmap(ax2, dsp_tot.to_numpy(dtype=float), list(dsp_tot.index),
             list(dsp_tot.columns), AQUA_CMAP, fmt="{:.0f}",
             title="Total DSP blocks per group", cbar_label="DSPs")

    fig.suptitle("Resource mix: DSP and BRAM usage", color=INK, fontsize=13,
                 x=0.02, ha="left", fontweight="bold")
    fig.tight_layout(rect=(0, 0, 1, 0.96))
    _savefig(fig, outbase + "2_resource_mix", exts)


# ---------------------------------------------------------------------------
# Orchestration
# ---------------------------------------------------------------------------
def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--results", default=os.path.join("results", "syn", "fpga"),
                    help="directory of per-target *.json files "
                         "(default: results/syn/fpga)")
    ap.add_argument("--out", default=os.path.join("analysis", "fpga"),
                    help="output directory (default: analysis/fpga)")
    ap.add_argument("--format", choices=["png", "pdf", "both"], default="both",
                    help="chart file format (default: both)")
    ap.add_argument("--targets", nargs="+",
                    help="restrict to these targets")
    ap.add_argument("--groups", nargs="+",
                    help=f"benchmark groups to analyze (default: {GROUPS}; "
                         "koios/large excluded as incomplete)")
    args = ap.parse_args()

    df, files_meta = load_results(args.results, METRICS)
    if df.empty:
        raise SystemExit(f"no FPGA result files found under {args.results}")
    df = df[df["group"].isin(args.groups or GROUPS)]
    if args.targets:
        df = df[df["target"].isin(args.targets)]

    set_rcparams()
    targets = order_targets(df)
    os.makedirs(args.out, exist_ok=True)
    exts = ["png", "pdf"] if args.format == "both" else [args.format]
    base = os.path.join(args.out, "fpga_")

    df.sort_values(["metric", "group", "benchmark", "target"]).to_csv(
        os.path.join(args.out, "summary.csv"), index=False)

    chart_lut_comparison(df, targets, base, exts)
    chart_resource_mix(df, targets, base, exts)
    chart_metric_scatter(df, "luts", "logicdepth", targets, METRIC_META, base,
                         exts, "3_area_vs_depth",
                         title="Area vs logic-depth tradeoff "
                               "(all targets overlaid)")
    chart_synth_cost(df, targets, base, exts)
    chart_pair_scatter(df, "virtex7", "z1060", "luts", METRIC_META, base, exts)
    chart_pair_scatter(df, "virtex7", "z1060", "logicdepth", METRIC_META, base,
                       exts)
    chart_pair_scatter(df, "ice40", "z1015", "luts", METRIC_META, base, exts)
    chart_benchmark_bars(df, "picorv32", ["cells", "logicdepth"], METRIC_META,
                         targets, base, exts, "6_picorv32_cells_depth")
    chart_metric_scatter(df, "luts", "memory", targets, METRIC_META, base,
                         exts, "7_luts_vs_memory")
    chart_metric_scatter(df, "luts", "tasktime", targets, METRIC_META, base,
                         exts, "8_luts_vs_tasktime")
    write_report(df, files_meta, targets, METRICS,
                 os.path.join(args.out, "report.md"),
                 "FPGA results: data-quality report")

    n_bench = df.dropna(subset=["value"])["benchmark"].nunique()
    mixed = [s for s, m in files_meta.items()
             if len({v for v in m["shapes"].values() if v}) > 1]
    print(f"Loaded {len(files_meta)} target files, {n_bench} benchmarks -> "
          f"{args.out}")
    print(f"  charts: fpga_1..8.{'/'.join(exts)}  + summary.csv + report.md")
    if mixed:
        print(f"  WARNING: mixed-schema (corrupt) files: {', '.join(mixed)}")


if __name__ == "__main__":
    main()
