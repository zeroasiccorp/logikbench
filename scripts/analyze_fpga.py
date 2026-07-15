#!/usr/bin/env python3
"""Analyze and visualize the FPGA synthesis results in results/syn/fpga/.

Loads the per-target metric files written by 'lb syn --publish', normalizes
their schema (tolerating the mixed flat/nested shape a stale-schema merge can
leave behind), and emits charts plus a tidy summary CSV and a data-quality
report under analysis/fpga/.

Each input file is results/syn/fpga/<tool>_<target>.json with:
    {"meta": {"target", "tools", "units", ...},
     "metrics": {metric: {group: {benchmark: value}}}}
The clean shape nests metric -> group -> benchmark; a corrupt file may store
some metrics flat as metric -> benchmark. The loader handles both.

Charts (matplotlib, static PNG/PDF):
  1. cross-target LUT comparison   (magnitude + efficiency-vs-median heatmaps)
  2. resource mix                  (DSP/BRAM inference rate + DSP totals)
  3. area vs logic-depth tradeoff  (small-multiple scatter, one per target)
  4. synth cost                    (runtime + peak-memory distribution)
Plus report.md (coverage matrix, missing/NaN tally, schema-shape audit).

Color follows the validated data-viz reference palette (light surface): a
single blue ramp for magnitude, a blue<->red diverging pair for polarity, and
target identity carried by axis position / panel, never by 12 cycled hues.
"""

import argparse
import glob
import json
import os

import numpy as np
import pandas as pd
import matplotlib

matplotlib.use("Agg")
import matplotlib.pyplot as plt                                    # noqa: E402
from matplotlib.colors import LinearSegmentedColormap             # noqa: E402

# ---------------------------------------------------------------------------
# Palette (validated data-viz reference instance, light chart surface).
# ---------------------------------------------------------------------------
SEQ_STEPS = ["#cde2fb", "#9ec5f4", "#6da7ec", "#3987e5",
             "#256abf", "#184f95", "#0d366b"]           # blue, light->dark
DIV_LO, DIV_MID, DIV_HI = "#2a78d6", "#f0efec", "#e34948"   # blue<->gray<->red
CAT = ["#2a78d6", "#1baf7a", "#eda100", "#008300",
       "#4a3aa7", "#e34948", "#e87ba4", "#eb6834"]      # categorical, in order
INK = "#0b0b0b"          # primary ink
INK2 = "#52514e"         # secondary ink
MUTED = "#898781"        # axis / labels
GRID = "#e1e0d9"         # hairline gridline
BASE = "#c3c2b7"         # baseline / axis
SURFACE = "#fcfcfb"      # chart surface

SEQ_CMAP = LinearSegmentedColormap.from_list("seq_blue", SEQ_STEPS)
AQUA_CMAP = LinearSegmentedColormap.from_list(
    "seq_aqua", ["#d3f2e6", "#1baf7a", "#0c5f42"])
DIV_CMAP = LinearSegmentedColormap.from_list("div_br", [DIV_LO, DIV_MID, DIV_HI])

# Metric presentation (label, unit, better-is-lower). Mirrors the dashboard's
# METRIC_INFO but kept local so this script imports no non-package modules.
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


# ---------------------------------------------------------------------------
# Loading / normalization
# ---------------------------------------------------------------------------
def _is_payload(data):
    """True for a per-target metrics file: {meta{target}, metrics{...}}."""
    return (isinstance(data, dict)
            and isinstance(data.get("metrics"), dict)
            and isinstance(data.get("meta"), dict)
            and "target" in data["meta"])


def _shape(metric_dict):
    """'nested' if metric -> group -> {bench: val}; 'flat' if metric -> {bench:
    val}. Empty dict -> None."""
    if not metric_dict:
        return None
    sample = next(iter(metric_dict.values()))
    return "nested" if isinstance(sample, dict) else "flat"


def load_fpga_results(results_dir):
    """Return (long_df, files_meta).

    long_df columns: file, target, tool, group, benchmark, metric, value.
    files_meta: {file_stem: {"target","tool","schema_version","shapes","path"}}
    where shapes maps each metric name to 'nested'/'flat'/None.

    A benchmark -> group map is built from every nested metric across all files
    (self-contained and complete over all groups), then used to recover the
    group for any metric stored flat (the corruption case).
    """
    paths = sorted(glob.glob(os.path.join(results_dir, "*.json")))
    parsed = []
    name2group = {}
    for path in paths:
        if not os.path.isfile(path):
            continue
        with open(path) as fh:
            data = json.load(fh)
        if not _is_payload(data):
            continue
        stem = os.path.splitext(os.path.basename(path))[0]
        met = data["metrics"]
        meta = data["meta"]
        shapes = {m: _shape(met.get(m)) for m in METRICS}
        for metric, shape in shapes.items():
            if shape == "nested":
                for group, names in met[metric].items():
                    for bench in names:
                        name2group.setdefault(bench, group)
        parsed.append((stem, path, meta, met, shapes))

    rows = []
    files_meta = {}
    for stem, path, meta, met, shapes in parsed:
        # a --label run variant is its own identity (e.g. z1015_optdelay) so it
        # forms a distinct column instead of colliding with the default target.
        target = meta.get("target", stem)
        label = meta.get("label")
        if label:
            target = f"{target}_{label}"
        tool = ",".join(sorted(meta.get("tools", {}))) or "unknown"
        files_meta[stem] = {
            "target": target, "tool": tool, "path": path, "shapes": shapes,
            "schema_version": meta.get("schema_version"),
        }
        for metric in METRICS:
            md = met.get(metric)
            shape = shapes.get(metric)
            if not md:
                continue
            if shape == "nested":
                for group, names in md.items():
                    for bench, val in names.items():
                        rows.append((stem, target, tool, group,
                                     bench, metric, val))
            else:  # flat: recover the group from the global map
                for bench, val in md.items():
                    group = name2group.get(bench, "unknown")
                    rows.append((stem, target, tool, group,
                                 bench, metric, val))

    df = pd.DataFrame(rows, columns=["file", "target", "tool", "group",
                                     "benchmark", "metric", "value"])
    df["value"] = pd.to_numeric(df["value"], errors="coerce")
    return df, files_meta


def order_targets(df):
    """Targets in canonical FPGA_TARGETS order where known, else alphabetical."""
    present = list(dict.fromkeys(df["target"]))
    try:
        from logikbench.runner import FPGA_TARGETS
        canon = list(FPGA_TARGETS)
    except Exception:
        canon = []
    head = [t for t in canon if t in present]
    tail = sorted(t for t in present if t not in head)
    return head + tail


# ---------------------------------------------------------------------------
# Shared plotting helpers
# ---------------------------------------------------------------------------
def _style_axes(ax):
    ax.set_facecolor(SURFACE)
    for spine in ("top", "right"):
        ax.spines[spine].set_visible(False)
    for spine in ("left", "bottom"):
        ax.spines[spine].set_color(BASE)
    ax.tick_params(colors=MUTED, labelsize=8)
    ax.xaxis.label.set_color(INK2)
    ax.yaxis.label.set_color(INK2)
    ax.title.set_color(INK)


def _annot_color(norm_value):
    """Ink for light cells, white for dark cells (approx luminance split)."""
    return "#ffffff" if norm_value >= 0.55 else INK


def _heatmap(ax, matrix, row_labels, col_labels, cmap, norm=None,
             fmt="{:.0f}", title="", cbar_label=""):
    """Draw an annotated heatmap. matrix is a 2D numpy array (rows x cols)."""
    im = ax.imshow(matrix, aspect="auto", cmap=cmap, norm=norm)
    ax.set_xticks(range(len(col_labels)))
    ax.set_xticklabels(col_labels, rotation=45, ha="right")
    ax.set_yticks(range(len(row_labels)))
    ax.set_yticklabels(row_labels)
    ax.set_title(title, fontsize=11, pad=8)
    finite = matrix[np.isfinite(matrix)]
    lo = float(finite.min()) if finite.size else 0.0
    hi = float(finite.max()) if finite.size else 1.0
    span = (hi - lo) or 1.0
    for i in range(matrix.shape[0]):
        for j in range(matrix.shape[1]):
            v = matrix[i, j]
            if not np.isfinite(v):
                ax.text(j, i, "-", ha="center", va="center",
                        color=MUTED, fontsize=7)
                continue
            frac = (v - lo) / span
            ax.text(j, i, fmt.format(v), ha="center", va="center",
                    color=_annot_color(frac), fontsize=7)
    cbar = ax.figure.colorbar(im, ax=ax, fraction=0.046, pad=0.02)
    cbar.set_label(cbar_label, color=INK2, fontsize=8)
    cbar.ax.tick_params(colors=MUTED, labelsize=7)
    ax.tick_params(colors=MUTED, labelsize=8)
    ax.title.set_color(INK)
    return im


def _pivot(df, metric, targets, aggfunc="median"):
    """group x target matrix of a metric (DataFrame), rows sorted by name."""
    sub = df[df["metric"] == metric]
    table = sub.pivot_table(index="group", columns="target", values="value",
                            aggfunc=aggfunc)
    cols = [t for t in targets if t in table.columns]
    return table.reindex(columns=cols).sort_index()


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
# Chart 3: area vs logic-depth tradeoff (small multiples)
# ---------------------------------------------------------------------------
def chart_area_vs_depth(df, targets, outbase, exts):
    wide = df[df["metric"].isin(["luts", "logicdepth"])].pivot_table(
        index=["target", "group", "benchmark"], columns="metric",
        values="value").reset_index()
    wide = wide.dropna(subset=["luts", "logicdepth"])
    wide = wide[(wide["luts"] > 0) & (wide["logicdepth"] > 0)]

    ncols = 4
    nrows = int(np.ceil(len(targets) / ncols))
    fig, axes = plt.subplots(nrows, ncols, figsize=(4 * ncols, 3.3 * nrows),
                             sharex=True, sharey=True)
    fig.patch.set_facecolor(SURFACE)
    axes = np.atleast_1d(axes).ravel()

    xmax = wide["luts"].max() if len(wide) else 10
    ymax = wide["logicdepth"].max() if len(wide) else 10
    for idx, target in enumerate(targets):
        ax = axes[idx]
        sub = wide[wide["target"] == target]
        ax.scatter(sub["luts"], sub["logicdepth"], s=14, color=CAT[0],
                   alpha=0.55, edgecolor=SURFACE, linewidth=0.4, zorder=3)
        # annotate the two largest designs by LUTs
        for _, r in sub.nlargest(2, "luts").iterrows():
            ax.annotate(r["benchmark"], (r["luts"], r["logicdepth"]),
                        fontsize=6, color=INK2, xytext=(3, 3),
                        textcoords="offset points")
        ax.set_xscale("log")
        ax.set_yscale("log")
        ax.set_xlim(1, xmax * 1.6)
        ax.set_ylim(1, ymax * 1.6)
        _style_axes(ax)
        ax.set_title(target, fontsize=10)
        ax.grid(True, which="major", color=GRID, linewidth=0.7, zorder=0)
        if idx % ncols == 0:
            ax.set_ylabel("logic depth")
        if idx >= len(targets) - ncols:
            ax.set_xlabel("LUTs")
    for j in range(len(targets), len(axes)):
        axes[j].set_visible(False)

    fig.suptitle("Area vs logic-depth tradeoff (per target)", color=INK,
                 fontsize=13, x=0.02, ha="left", fontweight="bold")
    fig.tight_layout(rect=(0, 0, 1, 0.97))
    _savefig(fig, outbase + "3_area_vs_depth", exts)


# ---------------------------------------------------------------------------
# Chart 4: synthesis cost (runtime + memory)
# ---------------------------------------------------------------------------
def chart_synth_cost(df, targets, outbase, exts):
    fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(15, 5.2))
    fig.patch.set_facecolor(SURFACE)

    def box(ax, metric, title, unit):
        data = []
        for t in targets:
            vals = df[(df["metric"] == metric) & (df["target"] == t)]["value"]
            vals = vals[np.isfinite(vals) & (vals > 0)]
            data.append(vals.to_numpy())
        bp = ax.boxplot(data, patch_artist=True,
                        widths=0.6, showfliers=True)
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
        ax.set_ylabel(f"{title} ({unit})" if unit else title)
        ax.set_title(f"{title} per benchmark", fontsize=11)
        _style_axes(ax)
        ax.grid(axis="y", color=GRID, linewidth=0.8, zorder=0)

    box(ax1, "tasktime", "Synthesis runtime", "s")
    box(ax2, "memory", "Peak memory", "MB")

    fig.suptitle("Synthesis cost per target", color=INK, fontsize=13,
                 x=0.02, ha="left", fontweight="bold")
    fig.tight_layout(rect=(0, 0, 1, 0.96))
    _savefig(fig, outbase + "4_synth_cost", exts)


# ---------------------------------------------------------------------------
# Chart 5: pairwise parity scatter (two targets, one metric)
# ---------------------------------------------------------------------------
def chart_pair_scatter(df, xt, yt, metric, outbase, exts):
    """Per-benchmark scatter of two targets on one metric, with a y=x parity
    line. Each point is the SAME design on both fabrics, so the comparison is
    valid (no aggregation across unrelated designs): points above the line use
    more on <yt>, below use more on <xt>."""
    sub = df[df["metric"] == metric]
    wide = sub.pivot_table(index=["group", "benchmark"], columns="target",
                           values="value")
    if xt not in wide.columns or yt not in wide.columns:
        print(f"  chart 5 skipped: missing target ({xt} or {yt})")
        return
    pair = wide[[xt, yt]].dropna()
    pair = pair[(pair[xt] > 0) & (pair[yt] > 0)]
    if pair.empty:
        print(f"  chart 5 skipped: no shared {metric} data for {xt}/{yt}")
        return
    x = pair[xt].to_numpy(dtype=float)
    y = pair[yt].to_numpy(dtype=float)
    ratio = y / x

    fig, ax = plt.subplots(figsize=(7.5, 7))
    fig.patch.set_facecolor(SURFACE)
    lo = min(x.min(), y.min()) * 0.7
    hi = max(x.max(), y.max()) * 1.4
    ax.plot([lo, hi], [lo, hi], color=MUTED, ls="--", lw=1.2, zorder=1,
            label="parity (y = x)")
    ax.scatter(x, y, s=24, color=CAT[0], alpha=0.6, edgecolor=SURFACE,
               linewidth=0.4, zorder=3)
    # label the benchmarks that diverge most from parity (either direction)
    for k in np.argsort(np.abs(np.log2(ratio)))[::-1][:8]:
        ax.annotate(pair.index[k][1], (x[k], y[k]), fontsize=6, color=INK2,
                    xytext=(3, 3), textcoords="offset points")

    ax.set_xscale("log")
    ax.set_yscale("log")
    ax.set_xlim(lo, hi)
    ax.set_ylim(lo, hi)
    ax.set_aspect("equal")
    label = METRIC_META[metric][0]
    ax.set_xlabel(f"{xt}  {label}")
    ax.set_ylabel(f"{yt}  {label}")
    ax.text(0.03, 0.97, f"{yt} uses more", transform=ax.transAxes, va="top",
            ha="left", color=INK2, fontsize=9)
    ax.text(0.97, 0.03, f"{xt} uses more", transform=ax.transAxes,
            va="bottom", ha="right", color=INK2, fontsize=9)
    _style_axes(ax)
    ax.grid(True, which="major", color=GRID, linewidth=0.7, zorder=0)
    ax.legend(frameon=False, fontsize=8, labelcolor=INK2, loc="lower right")

    gm = float(np.exp(np.mean(np.log(ratio))))
    ax.set_title(
        f"{yt} vs {xt}: {label} per benchmark (n={len(pair)})\n"
        f"geomean {yt}/{xt} = {gm:.2f}x   |   {yt} larger: "
        f"{int((ratio > 1).sum())}, {xt} larger: {int((ratio < 1).sum())}",
        color=INK, fontsize=11)
    fig.tight_layout()
    _savefig(fig, outbase + f"5_{xt}_vs_{yt}_{metric}", exts)


# ---------------------------------------------------------------------------
# Report
# ---------------------------------------------------------------------------
def write_report(df, files_meta, targets, path):
    lines = ["# FPGA results: data-quality report", ""]

    # schema-shape audit
    lines += ["## Schema-shape audit", "",
              "Each metric should nest `group -> benchmark`. A metric stored "
              "flat (`benchmark` directly) is a stale-schema merge artifact.",
              "", "| file | target | tool | mixed? | flat metrics |",
              "|---|---|---|---|---|"]
    for stem in sorted(files_meta):
        m = files_meta[stem]
        shapes = m["shapes"]
        kinds = {s for s in shapes.values() if s}
        flat = sorted(k for k, v in shapes.items() if v == "flat")
        mixed = "**YES**" if len(kinds) > 1 else "no"
        lines.append(f"| {stem} | {m['target']} | {m['tool']} | {mixed} | "
                     f"{', '.join(flat) or '-'} |")

    # coverage matrix: benchmarks with any non-null metric, per group x target
    lines += ["", "## Coverage (benchmarks with data) per group x target", ""]
    have = df.dropna(subset=["value"])
    cov = have.pivot_table(index="group", columns="target",
                           values="benchmark", aggfunc="nunique",
                           fill_value=0)
    cov = cov.reindex(columns=[t for t in targets if t in cov.columns])
    cov = cov.sort_index()
    lines.append("| group | " + " | ".join(cov.columns) + " |")
    lines.append("|" + "---|" * (len(cov.columns) + 1))
    for group, row in cov.iterrows():
        lines.append(f"| {group} | "
                     + " | ".join(str(int(v)) for v in row) + " |")
    total = have.groupby("target")["benchmark"].nunique()
    lines.append("| **total** | "
                 + " | ".join(str(int(total.get(t, 0)))
                              for t in cov.columns) + " |")

    # missing benchmarks (present somewhere, absent for a target)
    lines += ["", "## Missing benchmarks per target", ""]
    allbench = set(zip(have["group"], have["benchmark"]))
    for t in targets:
        tb = set(zip(have[have["target"] == t]["group"],
                     have[have["target"] == t]["benchmark"]))
        miss = sorted(f"{g}/{n}" for g, n in (allbench - tb))
        shown = ", ".join(miss[:12]) + (" ..." if len(miss) > 12 else "")
        lines.append(f"- **{t}**: {len(miss)} missing"
                     + (f" ({shown})" if miss else ""))

    # NaN / null tally per metric
    lines += ["", "## Null values per metric (recorded but empty)", ""]
    for metric in METRICS:
        sub = df[df["metric"] == metric]
        n_null = int(sub["value"].isna().sum())
        n_tot = int(len(sub))
        lines.append(f"- **{metric}**: {n_null} null of {n_tot} entries")

    lines.append("")
    with open(path, "w") as fh:
        fh.write("\n".join(lines))


# ---------------------------------------------------------------------------
# Orchestration
# ---------------------------------------------------------------------------
def _savefig(fig, base, exts):
    for ext in exts:
        fig.savefig(f"{base}.{ext}", dpi=150, facecolor=fig.get_facecolor(),
                    bbox_inches="tight")
    plt.close(fig)


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--results", default=os.path.join("results", "syn", "fpga"),
                    help="directory of per-target *.json files "
                         "(default: results/syn/fpga)")
    ap.add_argument("--out", default=os.path.join("analysis", "fpga"),
                    help="output directory (default: analysis/fpga)")
    ap.add_argument("--format", choices=["png", "pdf", "both"], default="png",
                    help="chart file format (default: png)")
    ap.add_argument("--targets", nargs="+",
                    help="restrict to these targets")
    ap.add_argument("--groups", nargs="+",
                    help="restrict to these benchmark groups")
    args = ap.parse_args()

    df, files_meta = load_fpga_results(args.results)
    if df.empty:
        raise SystemExit(f"no FPGA result files found under {args.results}")
    if args.groups:
        df = df[df["group"].isin(args.groups)]
    if args.targets:
        df = df[df["target"].isin(args.targets)]

    plt.rcParams.update({
        "font.family": "sans-serif",
        "font.sans-serif": ["DejaVu Sans"],
        "text.color": INK, "axes.edgecolor": BASE,
        "axes.labelcolor": INK2, "figure.facecolor": SURFACE,
    })

    targets = order_targets(df)
    os.makedirs(args.out, exist_ok=True)
    exts = ["png", "pdf"] if args.format == "both" else [args.format]
    base = os.path.join(args.out, "fpga_")

    df.sort_values(["metric", "group", "benchmark", "target"]).to_csv(
        os.path.join(args.out, "summary.csv"), index=False)

    chart_lut_comparison(df, targets, base, exts)
    chart_resource_mix(df, targets, base, exts)
    chart_area_vs_depth(df, targets, base, exts)
    chart_synth_cost(df, targets, base, exts)
    chart_pair_scatter(df, "virtex7", "z1060", "luts", base, exts)
    chart_pair_scatter(df, "virtex7", "z1060", "logicdepth", base, exts)
    chart_pair_scatter(df, "ice40", "z1015", "luts", base, exts)
    write_report(df, files_meta, targets, os.path.join(args.out, "report.md"))

    n_bench = df.dropna(subset=["value"])["benchmark"].nunique()
    mixed = [s for s, m in files_meta.items()
             if len({v for v in m["shapes"].values() if v}) > 1]
    print(f"Loaded {len(files_meta)} target files, {n_bench} benchmarks -> "
          f"{args.out}")
    print(f"  charts: fpga_1..5.{'/'.join(exts)}  + summary.csv + report.md")
    if mixed:
        print(f"  WARNING: mixed-schema (corrupt) files: {', '.join(mixed)}")


if __name__ == "__main__":
    main()
