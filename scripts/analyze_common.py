#!/usr/bin/env python3
"""Shared plumbing for the logikbench result-analysis front-ends.

Holds the mode-agnostic pieces used by both scripts/analyze_fpga.py and
scripts/analyze_asic.py: the validated data-viz palette, the results loader
(schema-normalizing, --label aware), styling/heatmap helpers, and the generic
charts (metric-vs-metric overlay scatter, per-target synth-cost boxes, pairwise
parity scatter, single-benchmark paired bars) plus the data-quality report.

Metric presentation is passed in as a `meta` dict keyed by metric name to a
(label, unit, lower_is_better) triple, and the metric list is passed explicitly,
so this module is independent of any one mode's metric set.
"""

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


def set_rcparams():
    """Apply the shared matplotlib rcParams (fonts + ink colors)."""
    plt.rcParams.update({
        "font.family": "sans-serif",
        "font.sans-serif": ["DejaVu Sans"],
        "text.color": INK, "axes.edgecolor": BASE,
        "axes.labelcolor": INK2, "figure.facecolor": SURFACE,
    })


def axis_label(meta, metric):
    """'<Label> (<unit>)' or '<Label>' from a METRIC_META (label, unit, dir)."""
    label, unit = (meta.get(metric, (metric, "", True)))[:2]
    return f"{label} ({unit})" if unit else label


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


def load_results(results_dir, metrics, keep=None):
    """Return (long_df, files_meta).

    long_df columns: file, target, tool, group, benchmark, metric, value.
    files_meta: {file_stem: {"target","tool","schema_version","shapes","path"}}
    where shapes maps each metric name to 'nested'/'flat'/None. 'metrics' is the
    list of metric names to extract. 'keep', if given, is a predicate on the
    payload dict; files for which it returns False are skipped.

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
        if keep is not None and not keep(data):
            continue
        stem = os.path.splitext(os.path.basename(path))[0]
        met = data["metrics"]
        meta = data["meta"]
        shapes = {m: _shape(met.get(m)) for m in metrics}
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
        for metric in metrics:
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


def order_targets(df, canon=None):
    """Targets in canonical order where known, else alphabetical. 'canon' is the
    preferred order; when None, fall back to logikbench's FPGA_TARGETS."""
    present = list(dict.fromkeys(df["target"]))
    if canon is None:
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


def _savefig(fig, base, exts):
    for ext in exts:
        fig.savefig(f"{base}.{ext}", dpi=150, facecolor=fig.get_facecolor(),
                    bbox_inches="tight")
    plt.close(fig)


# ---------------------------------------------------------------------------
# Generic charts
# ---------------------------------------------------------------------------
def chart_metric_scatter(df, xmetric, ymetric, targets, meta, outbase, exts,
                         out_id, title=None):
    """Per-benchmark scatter of one metric vs another, all targets overlaid and
    color-coded (legend carries identity). Log-log; points with x<=0 or y<=0 are
    dropped. Axis labels come from `meta`."""
    wide = df[df["metric"].isin([xmetric, ymetric])].pivot_table(
        index=["target", "group", "benchmark"], columns="metric",
        values="value").reset_index()
    if xmetric not in wide or ymetric not in wide:
        print(f"  scatter skipped: missing {xmetric}/{ymetric}")
        return
    wide = wide.dropna(subset=[xmetric, ymetric])
    wide = wide[(wide[xmetric] > 0) & (wide[ymetric] > 0)]
    if wide.empty:
        print(f"  scatter skipped: no {xmetric}/{ymetric} data")
        return

    # one stable color per target: the validated categorical palette for <= 8
    # targets, else a larger distinct set (identity comes from the legend).
    if len(targets) <= len(CAT):
        palette = CAT
    else:
        palette = [plt.cm.tab20(i % 20) for i in range(len(targets))]
    color = {t: palette[i] for i, t in enumerate(targets)}

    xlabel = axis_label(meta, xmetric)
    ylabel = axis_label(meta, ymetric)
    fig, ax = plt.subplots(figsize=(11, 7))
    fig.patch.set_facecolor(SURFACE)
    for target in targets:
        sub = wide[wide["target"] == target]
        if sub.empty:
            continue
        ax.scatter(sub[xmetric], sub[ymetric], s=16, color=color[target],
                   alpha=0.6, edgecolor=SURFACE, linewidth=0.3, zorder=3,
                   label=target)
    ax.set_xscale("log")
    ax.set_yscale("log")
    ax.set_xlabel(xlabel)
    ax.set_ylabel(ylabel)
    ax.set_title(title or f"{ylabel} vs {xlabel} (all targets overlaid)",
                 color=INK, fontsize=13, loc="left", fontweight="bold")
    _style_axes(ax)
    ax.grid(True, which="major", color=GRID, linewidth=0.7, zorder=0)
    ax.legend(frameon=False, fontsize=8, labelcolor=INK2, markerscale=1.6,
              loc="center left", bbox_to_anchor=(1.01, 0.5), title="target")
    fig.tight_layout()
    _savefig(fig, outbase + out_id, exts)


def chart_synth_cost(df, targets, outbase, exts):
    """Runtime + peak-memory distribution per target (two boxplot panels)."""
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


def chart_pair_scatter(df, xt, yt, metric, meta, outbase, exts):
    """Per-benchmark scatter of two targets on one metric, with a y=x parity
    line. Each point is the SAME design on both targets, so the comparison is
    valid (no aggregation across unrelated designs): points above the line have
    a larger value on <yt>, below on <xt>."""
    sub = df[df["metric"] == metric]
    wide = sub.pivot_table(index=["group", "benchmark"], columns="target",
                           values="value")
    if xt not in wide.columns or yt not in wide.columns:
        print(f"  pair-scatter skipped: missing target ({xt} or {yt})")
        return
    pair = wide[[xt, yt]].dropna()
    pair = pair[(pair[xt] > 0) & (pair[yt] > 0)]
    if pair.empty:
        print(f"  pair-scatter skipped: no shared {metric} data for {xt}/{yt}")
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
    label = meta[metric][0]
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


def chart_benchmark_bars(df, name, metric_pair, meta, targets, outbase, exts,
                         out_id):
    """Two measures for a single benchmark across all targets, as two
    side-by-side horizontal bar panels (different scales -> separate panels,
    never a dual axis). Targets are sorted by the first metric; the order is
    shared so the two measures read across."""
    m0, m1 = metric_pair
    sub = df[(df["benchmark"] == name)
             & (df["metric"].isin(metric_pair))]
    wide = sub.pivot_table(index="target", columns="metric", values="value")
    wide = wide.reindex([t for t in targets if t in wide.index])
    if m0 not in wide:
        print(f"  benchmark-bars skipped: no {m0} data for {name}")
        return
    wide = wide.dropna(subset=[m0]).sort_values(m0)  # largest on top
    if wide.empty:
        print(f"  benchmark-bars skipped: no data for {name}")
        return
    ys = list(range(len(wide)))
    labels = list(wide.index)

    fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(13, 6.5), sharey=True)
    fig.patch.set_facecolor(SURFACE)
    panels = [(ax1, m0, CAT[0]), (ax2, m1, CAT[1])]
    for ax, metric, col in panels:
        vals = wide[metric].fillna(0) if metric in wide else \
            pd.Series(0, index=wide.index)
        ax.barh(ys, vals, height=0.66, color=col, zorder=3)
        vmax = vals.max() or 1
        for y, v in zip(ys, vals):
            ax.text(v + vmax * 0.01, y, f"{v:g}", va="center", ha="left",
                    fontsize=8, color=INK2)
        ax.set_xlim(0, vmax * 1.15)
        ax.set_title(axis_label(meta, metric), fontsize=11)
        _style_axes(ax)
        ax.grid(axis="x", color=GRID, linewidth=0.8, zorder=0)
    ax1.set_yticks(ys)
    ax1.set_yticklabels(labels)

    fig.suptitle(f"{name}: {meta[m0][0]} and {meta[m1][0]} by target",
                 color=INK, fontsize=13, x=0.02, ha="left", fontweight="bold")
    fig.tight_layout(rect=(0, 0, 1, 0.96))
    _savefig(fig, outbase + out_id, exts)


# ---------------------------------------------------------------------------
# Report
# ---------------------------------------------------------------------------
def write_report(df, files_meta, targets, metrics, path, title):
    lines = [f"# {title}", ""]

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
    for metric in metrics:
        sub = df[df["metric"] == metric]
        n_null = int(sub["value"].isna().sum())
        n_tot = int(len(sub))
        lines.append(f"- **{metric}**: {n_null} null of {n_tot} entries")

    lines.append("")
    with open(path, "w") as fh:
        fh.write("\n".join(lines))
