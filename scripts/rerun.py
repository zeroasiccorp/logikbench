#!/usr/bin/env python3
"""Re-run the full FPGA dashboard pipeline end to end:

  1. synthesize every benchmark (all groups) on every FPGA target  (lb run)
  2. collect metrics into results/fpga/<config>/<target>.json       (lb collect)
  3. rebuild the per-config database(s)                             (build_db.py)
  4. regenerate the static site under site/                        (generate.py)

Run from anywhere -- paths resolve relative to the repo root.

    python scripts/rerun.py                  # all targets, config 'small'
    python scripts/rerun.py --config fast -j 8
    python scripts/rerun.py -t xilinx_virtex7 lattice_ice40   # subset

Synthesis is the slow part; each step's command is echoed. 'lb run' is allowed
to return nonzero (a few benchmark/target pairs always fail on some fabrics) so
the pipeline still collects and publishes the results that did complete.
"""

import argparse
import subprocess
import sys
from pathlib import Path

from logikbench.benchmark import FPGA_TARGETS

REPO = Path(__file__).resolve().parent.parent


def run(cmd, check=True):
    """Echo and run a command from the repo root."""
    print("+ " + " ".join(cmd), flush=True)
    return subprocess.run(cmd, cwd=REPO, check=check)


def main():
    ap = argparse.ArgumentParser(
        description=__doc__,
        formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--config", default="small",
                    help="config name; results land in results/fpga/<config> "
                         "and render as the <config> page (default: small)")
    ap.add_argument("-j", "--jobs", type=int, default=16,
                    help="benchmarks to synthesize in parallel (default: 16)")
    ap.add_argument("-t", "--target", nargs="+", default=list(FPGA_TARGETS),
                    metavar="TARGET",
                    help="targets to sweep (default: all FPGA targets)")
    args = ap.parse_args()

    targets = args.target
    outdir = f"results/fpga/{args.config}"
    lb = [sys.executable, "-m", "logikbench.apps.lb"]

    print(f"Refreshing '{args.config}' over {len(targets)} target(s): "
          f"{', '.join(targets)}\n")

    # 1. synthesize all benchmarks on all targets (partial failures are OK)
    result = run(lb + ["run", "-t", *targets, "-j", str(args.jobs)], check=False)
    if result.returncode != 0:
        print("\n(note: some benchmark/target pairs failed; collecting the "
              "rest)\n", file=sys.stderr)

    # 2. collect metrics into the per-config directory
    run(lb + ["collect", "-t", *targets, "-o", outdir])

    # 3. rebuild the per-config database(s) from results/fpga/*/
    run([sys.executable, "dashboard/build_db.py", "--results", "results/fpga"])

    # 4. regenerate the static site
    run([sys.executable, "dashboard/generate.py",
         "--db", "results/fpga", "--out", "site"])

    print(f"\nDone. Open site/{args.config}.html")


if __name__ == "__main__":
    main()
