#!/usr/bin/env python3
"""Rank synthesis targets by total LUTs and write the table into README.md.

For one config (default 'small'), this reads the dashboard database
results/fpga/<config>.json and, for each target column, sums the LUT counts
across every benchmark into a single number. Targets are ranked first (lowest
total LUTs, most efficient) to last.

When a benchmark result is unavailable for a target (missing or null), that
benchmark's value for the target is set to the highest LUT count any target
achieved on that benchmark -- a worst-case penalty so an absent result cannot
flatter a target.

Only the table is written into README.md, between the markers

    <!-- RANKING:START -->  ...  <!-- RANKING:END -->

so re-running just refreshes the table in place. The section heading and any
surrounding prose live outside the markers and are left untouched (put anything
you want to keep before START or after END).
"""

import argparse
import json
import os

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
START = "<!-- RANKING:START -->"
END = "<!-- RANKING:END -->"

# Native logic-cell architecture per target (device datasheet), keyed by base
# target name. Suffix variants (e.g. zeroasic_z1015opt) inherit their base.
ARCH = {
    "achronix_speedster": "LUT6",
    "adi_flex16ffc": "LUT6",
    "efinix_trion": "LUT4",
    "fabulous_generic": "LUT4",
    "gatemate_cologne": "LUT8",
    "gowin_gw5a": "LUT4",
    "lattice_ecp5": "LUT4",
    "lattice_ice40": "LUT4",
    "microchip_polarfire": "LUT4",
    "quicklogic_polarpro": "LUT4/MUX",
    "xilinx_virtex7": "LUT6",
    "zeroasic_z1015": "LUT4",
    "zeroasic_z1060": "LUT6",
}


def arch_for(target):
    """Architecture for a ranking column. Exact match, else the longest base
    target it is a variant of (e.g. zeroasic_z1015opt -> zeroasic_z1015)."""
    if target in ARCH:
        return ARCH[target]
    bases = [k for k in ARCH if target.startswith(k)]
    return ARCH[max(bases, key=len)] if bases else "?"


def compute_totals(section):
    """Return [(target, total_luts, n_missing)] for every target column.

    Missing/None LUT values are replaced by the per-benchmark maximum across
    all targets before summing.
    """
    targets = section["targets"]
    data = section["data"]

    totals = {t: 0 for t in targets}
    missing = {t: 0 for t in targets}
    for bench, per_target in data.items():
        vals = {}
        for t in targets:
            v = per_target.get(t, {}).get("luts")
            if v is not None:
                vals[t] = v
        if not vals:
            continue  # nobody has a value for this benchmark; skip it
        worst = max(vals.values())
        for t in targets:
            if t in vals:
                totals[t] += vals[t]
            else:
                totals[t] += worst  # worst-case penalty for an absent result
                missing[t] += 1
    return [(t, totals[t], missing[t]) for t in targets]


def render_table(section):
    """Build just the ranking table between the START/END markers.

    Only the table is managed by this script; the section heading and any
    descriptive prose live outside the markers in README.md and are left alone.
    """
    ranked = sorted(compute_totals(section), key=lambda r: r[1])
    lines = [
        START,
        "| Rank | Target | Arch | Total LUTs | Missing |",
        "|-----:|--------|------|-----------:|--------:|",
    ]
    for rank, (target, total, miss) in enumerate(ranked, start=1):
        lines.append(
            f"| {rank} | {target} | {arch_for(target)} | {total:,} | {miss} |")
    lines.append(END)
    return "\n".join(lines)


def update_readme(block):
    """Replace the marker block in README.md, or insert it before Contributing."""
    path = os.path.join(REPO, "README.md")
    with open(path) as f:
        text = f.read()

    if START in text and END in text:
        pre = text[:text.index(START)]
        post = text[text.index(END) + len(END):]
        text = pre + block + post
    else:
        anchor = "## Contributing"
        insert = block + "\n\n"
        if anchor in text:
            text = text.replace(anchor, insert + anchor, 1)
        else:
            text = text.rstrip() + "\n\n" + insert
    with open(path, "w") as f:
        f.write(text)


def main():
    ap = argparse.ArgumentParser(
        description=__doc__,
        formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--config", default="small",
                    help="config to rank (results/fpga/<config>.json; "
                         "default: small)")
    args = ap.parse_args()

    db = os.path.join(REPO, "results", "fpga", f"{args.config}.json")
    if not os.path.isfile(db):
        ap.error(f"database not found: {db} (run scripts/rerun.py first)")
    with open(db) as f:
        section = json.load(f)

    block = render_table(section)
    update_readme(block)

    # echo the ranking to stdout too
    print(block.replace(START, "").replace(END, "").strip())


if __name__ == "__main__":
    main()
