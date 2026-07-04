#!/usr/bin/env python3
"""Re-run a full dashboard pipeline end to end.

FPGA flow (--flow fpga, default):
  1. synthesize every benchmark on every FPGA target              (lb run)
  2. collect metrics into results/fpga/<config>/<target>.json     (lb collect)
  3. rebuild the per-config database(s)                           (build_db.py)
  4. regenerate the static site under site/                       (generate.py)
  5. refresh the README ranking table                             (ranking.py)

ASIC flow (--flow asic):
  1. synthesize every benchmark on the demo PDK target(s), through place.global
     (the first node that yields fmax), with single-corner libs    (lb run)
  2. collect ASIC metrics into results/asic/<config>/<target>.json (lb collect)
  3. rebuild the per-config database with the ASIC metric set       (build_db.py)
  4. regenerate the static site under site/asic/                    (generate.py)
  (ranking.py is FPGA/LUT-specific and is skipped.)

Run from anywhere -- paths resolve relative to the repo root.

    python scripts/rerun.py                       # all FPGA targets, config 'small'
    python scripts/rerun.py --config fast -j 8
    python scripts/rerun.py -t xilinx_virtex7 lattice_ice40   # subset
    python scripts/rerun.py --flow asic -j 8      # all benchmarks on asap7_demo

Synthesis is the slow part; each step's command is echoed. 'lb run' is allowed
to return nonzero (a few benchmark/target pairs always fail) so the pipeline
still collects and publishes the results that did complete.
"""

import argparse
import subprocess
import sys
from pathlib import Path

from logikbench.runner import FPGA_TARGETS

REPO = Path(__file__).resolve().parent.parent

# default target(s) per flow; ASIC uses one demo PDK column (extend with -t)
_ASIC_TARGETS = ["asap7_demo"]
# Stop at floorplan.init: with the patched OpenROAD task (init_floorplan reports
# fmax), this is the earliest/cheapest node that yields all four ASIC metrics
# incl. fmax (a pre-placement estimate). Older SC without that patch needs
# place.global instead.
_ASIC_STOP = "floorplan.init"


def run(cmd, check=True):
    """Echo and run a command from the repo root."""
    print("+ " + " ".join(cmd), flush=True)
    return subprocess.run(cmd, cwd=REPO, check=check)


def main():
    ap = argparse.ArgumentParser(
        description=__doc__,
        formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--flow", choices=["fpga", "asic"], default="fpga",
                    help="dashboard to refresh: 'fpga' (FPGA targets) or 'asic' "
                         "(demo PDK via asicflow) (default: fpga)")
    ap.add_argument("--config", default="small",
                    help="config name; results land in results/<flow>/<config> "
                         "and render as the <config> page (default: small)")
    ap.add_argument("-j", "--jobs", type=int, default=16,
                    help="benchmarks to synthesize in parallel (default: 16)")
    ap.add_argument("-t", "--target", nargs="+", default=None,
                    metavar="TARGET",
                    help="targets to sweep (default: all FPGA targets for "
                         "--flow fpga, asap7_demo for --flow asic)")
    args = ap.parse_args()

    asic = args.flow == "asic"
    targets = args.target or (_ASIC_TARGETS if asic else list(FPGA_TARGETS))
    resultsdir = f"results/{args.flow}"
    outdir = f"{resultsdir}/{args.config}"
    sitedir = "site/asic" if asic else "site"
    lb = [sys.executable, "-m", "logikbench.apps.lb"]

    print(f"Refreshing {args.flow} '{args.config}' over {len(targets)} "
          f"target(s): {', '.join(targets)}\n")

    # 1. synthesize all benchmarks on all targets (partial failures are OK).
    #    ASIC runs through place.global so fmax is captured.
    run_cmd = lb + ["run", "-t", *targets, "-j", str(args.jobs)]
    if asic:
        run_cmd += ["--to", _ASIC_STOP]
    result = run(run_cmd, check=False)
    if result.returncode != 0:
        print("\n(note: some benchmark/target pairs failed; collecting the "
              "rest)\n", file=sys.stderr)

    # 2. collect metrics into the per-config directory
    run(lb + ["collect", "-t", *targets, "-o", outdir])

    # 3. rebuild the per-config database(s) with the right metric set
    run([sys.executable, "dashboard/build_db.py", "--results", resultsdir,
         "--metrics", args.flow])

    # 4. regenerate the static site
    title = "ASIC Synthesis (ASAP7)" if asic else "FPGA Synthesis"
    run([sys.executable, "dashboard/generate.py",
         "--db", resultsdir, "--out", sitedir, "--title", title])

    # 5. (FPGA only) update the README ranking table; ranking is LUT-specific
    if not asic:
        run([sys.executable, "scripts/ranking.py", "--config", args.config])

    print(f"\nDone. Open {sitedir}/{args.config}.html")


if __name__ == "__main__":
    main()
