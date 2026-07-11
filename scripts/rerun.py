#!/usr/bin/env python3
"""Re-run the full LogikBench dashboard pipeline end to end.

Sweeps every benchmark across every target -- all FPGA targets and all ASIC
targets (both the 'sc_<pdk>' asicflow columns and the 'yosys_<pdk>' lbflow
columns; tardigrade is excluded) -- then collects metrics, rebuilds the
databases, and regenerates the static sites plus the README ranking table.

The sweep is hardcoded: -j 16, config 'small'. Each benchmark's synthesis
artifacts are deleted as it finishes so a full run cannot fill the disk -- only
the manifests collect needs survive. The two knobs are --resume (skip
benchmarks whose build already completed) and --keep (retain the full
artifacts); both are passed through to the sweep.

    python scripts/rerun.py            # full sweep from scratch
    python scripts/rerun.py --resume   # continue an interrupted sweep
    python scripts/rerun.py --keep     # retain artifacts (uses more disk)

Run from anywhere -- paths resolve relative to the repo root. Synthesis is the
slow part; each command is echoed. the sweep is allowed to return nonzero (a few
benchmark/target pairs always fail) so the pipeline still collects and
publishes the results that did complete.
"""

import argparse
import subprocess
import sys
from pathlib import Path

from logikbench.runner import FPGA_TARGETS, SC_TARGETS, YOSYS_TARGETS

REPO = Path(__file__).resolve().parent.parent

# hardcoded sweep configuration
JOBS = 16
CONFIG = "small"
# earliest/cheapest asicflow node that yields all four ASIC metrics incl. fmax
# (a pre-placement estimate); yosys_<pdk> lbflow targets run to completion.
ASIC_STOP = "floorplan.init"

# target sets: all FPGA targets, all 'sc_<pdk>' asicflow columns, all
# 'yosys_<pdk>' lbflow columns. Tardigrade is simply not referenced, so the
# hardcoded sweep excludes it.
# Targets as new-CLI --target values (PDK stems / FPGA parts), not the old
# '<tool>_<pdk>' tokens: 'lb syn'/'lb pnr' take --target + --tool.
FPGA = list(FPGA_TARGETS)                             # FPGA parts (lb syn)
ASIC_SC = [t.split("_", 1)[1] for t in SC_TARGETS]    # PDK stems (lb pnr)
ASIC_LB = [t.split("_", 1)[1] for t in YOSYS_TARGETS]  # PDK stems (lb syn)

LB = [sys.executable, "-m", "logikbench.apps.lb"]


def run(cmd, check=True):
    """Echo and run a command from the repo root."""
    print("+ " + " ".join(cmd), flush=True)
    return subprocess.run(cmd, cwd=REPO, check=check)


def lb_run(verb, targets, resume, keep, tool=None, extra=None):
    """One 'lb <verb>' sweep (partial failures are OK). 'verb' is a task
    subcommand (syn|pnr); 'targets' are --target values (PDK stems / FPGA
    parts)."""
    cmd = LB + [verb, "-t", *targets, "-j", str(JOBS)]
    if tool:
        cmd += ["--tool", tool]
    if resume:
        cmd += ["--resume"]
    if keep:
        cmd += ["--keep"]
    if extra:
        cmd += extra
    result = run(cmd, check=False)
    if result.returncode != 0:
        print("\n(note: some benchmark/target pairs failed; continuing)\n",
              file=sys.stderr)


def refresh(flow, targets, sitedir, title):
    """collect -> build_db -> generate for one flow's whole target set."""
    resultsdir = f"results/{flow}"
    outdir = f"{resultsdir}/{CONFIG}"
    run(LB + ["collect", "-t", *targets, "-o", outdir])
    run([sys.executable, "dashboard/build_db.py", "--results", resultsdir,
         "--metrics", flow])
    run([sys.executable, "dashboard/generate.py", "--db", resultsdir,
         "--out", sitedir, "--title", title])


def main():
    ap = argparse.ArgumentParser(
        description=__doc__,
        formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--resume", action="store_true",
                    help="pass --resume to the sweep: skip benchmarks whose "
                         "build already completed successfully")
    ap.add_argument("--keep", action="store_true",
                    help="pass --keep to the sweep: retain the full synthesis "
                         "artifacts instead of deleting them per benchmark "
                         "(uses much more disk)")
    args = ap.parse_args()

    # NOTE: the refresh() steps below (metric collection + dashboard rebuild)
    # predate the task-verb redesign. `lb collect` was removed and results now
    # live in results/<task>/<class>/<token>.json (written by `lb <verb>
    # --publish`), so build_db/generate need updating to the new layout. The
    # synthesis sweeps themselves use the current commands.

    # ---- FPGA: all FPGA parts (lb syn, yosys) ----
    print(f"Refreshing FPGA over {len(FPGA)} target(s)\n")
    lb_run("syn", FPGA, args.resume, args.keep)
    refresh("fpga", FPGA, "site", "FPGA Synthesis")
    # the ranking table is LUT-specific, so it is FPGA-only
    run([sys.executable, "scripts/ranking.py", "--config", CONFIG])

    # ---- ASIC: PDKs through pnr (asicflow, --to floorplan.init) + syn (lbflow)
    asic_targets = ASIC_SC + ASIC_LB
    lb_run("pnr", ASIC_SC, args.resume, args.keep, extra=["--to", ASIC_STOP])
    lb_run("syn", ASIC_LB, args.resume, args.keep, tool="yosys")
    refresh("asic", asic_targets, "site/asic", "ASIC Synthesis")

    print(f"\nDone. Open site/{CONFIG}.html and site/asic/{CONFIG}.html")


if __name__ == "__main__":
    main()
