#!/usr/bin/env python3
"""Re-run a full dashboard pipeline end to end.

FPGA flow (--flow fpga, default):
  1. synthesize every benchmark on every FPGA target              (lb run)
  2. collect metrics into results/fpga/<config>/<target>.json     (lb collect)
  3. rebuild the per-config database(s)                           (build_db.py)
  4. regenerate the static site under site/                       (generate.py)
  5. refresh the README ranking table                             (ranking.py)

ASIC flow (--flow asic):
  1. synthesize every benchmark on the ASIC target(s) (lb run):
       - a bare PDK name (e.g. freepdk45): the fast lbflow path -- Yosys synth +
         OpenSTA timing, no place-and-route (fmax from the timing step);
       - a <pdk>_demo (e.g. asap7_demo): the SC asicflow, stopped at
         floorplan.init (earliest node that yields fmax), single-corner libs.
     --clk sets the target clock period in ns (default: lb's own default).
  2. collect ASIC metrics into results/asic/<config>/<target>.json (lb collect)
  3. rebuild the per-config database with the ASIC metric set       (build_db.py)
  4. regenerate the static site under site/asic/                    (generate.py)
  (ranking.py is FPGA/LUT-specific and is skipped.)

Run from anywhere -- paths resolve relative to the repo root.

    python scripts/rerun.py                       # all FPGA targets, config 'small'
    python scripts/rerun.py --config fast -j 8
    python scripts/rerun.py -t xilinx_virtex7 lattice_ice40   # subset
    python scripts/rerun.py --flow asic -j 8      # all benchmarks on asap7_demo
    python scripts/rerun.py --flow asic -t freepdk45 --clk 2  # fast lbflow path

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
    ap.add_argument("--clk", type=float, default=None, metavar="PERIOD",
                    help="ASIC clock period in ns passed to 'lb run' (default: "
                         "lb's own default). Ignored for --flow fpga.")
    ap.add_argument("--timeout", type=float, default=None, metavar="SEC",
                    help="per-step wall-clock cap in seconds passed to 'lb run' "
                         "(default: lb's own default)")
    ap.add_argument("--clean", action="store_true",
                    help="pass --clean to 'lb run': delete each benchmark's "
                         "synthesis artifacts as it finishes, keeping only the "
                         "manifest 'lb collect' needs. Bounds peak disk over a "
                         "full sweep (collect still runs next as usual)")
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
    #    Only the SC asicflow (<pdk>_demo) has a floorplan.init node to stop at;
    #    bare-PDK lbflow targets run synth + timing to completion (fmax from the
    #    timing step), so no --to is passed for them.
    demo = asic and all(t.endswith("_demo") for t in targets)
    if asic and not demo and any(t.endswith("_demo") for t in targets):
        print("warning: mixing _demo (asicflow) and bare-PDK (lbflow) ASIC "
              "targets; run them separately so the --to floorplan.init cutoff "
              "applies to the demo targets.", file=sys.stderr)
    run_cmd = lb + ["run", "-t", *targets, "-j", str(args.jobs)]
    if demo:
        run_cmd += ["--to", _ASIC_STOP]
    if asic and args.clk is not None:
        run_cmd += ["--clk", str(args.clk)]
    if args.timeout is not None:
        run_cmd += ["--timeout", str(args.timeout)]
    if args.clean:
        run_cmd += ["--clean"]
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
    title = (f"ASIC Synthesis ({', '.join(targets)})" if asic
             else "FPGA Synthesis")
    run([sys.executable, "dashboard/generate.py",
         "--db", resultsdir, "--out", sitedir, "--title", title])

    # 5. (FPGA only) update the README ranking table; ranking is LUT-specific
    if not asic:
        run([sys.executable, "scripts/ranking.py", "--config", args.config])

    print(f"\nDone. Open {sitedir}/{args.config}.html")


if __name__ == "__main__":
    main()
