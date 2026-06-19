LogikBench results dashboard
============================

A static, GitHub Pages dashboard of synthesis quality-of-results. One page per
flow (`fpga.html`, `asic.html`): a benchmark x target matrix with a metric tab
selector and ROYGBIV heatmap cells -- per benchmark, blue is the best target,
red the worst, with the exact value printed.

Pipeline
--------

Synthesis is heavy and runs **offline**; CI only renders committed data.

```
lb run     ->  build/<target>/<benchmark>/...        # synthesize (offline)
lb collect ->  results/<target>.json                 # per-target metrics (offline)
build_db.py -> results/db.json                        # merge, self-describing (offline)
generate.py -> site/{fpga,asic,index}.html            # render (offline OR in CI)
```

`results/db.json` is committed. The GitHub Action (`.github/workflows/pages.yml`)
runs only `generate.py`, which needs **Jinja2 only** -- no `logikbench`, no
SiliconCompiler -- so Pages can rebuild from the committed database alone.

Refresh the data (offline)
--------------------------

```bash
# 1. synthesize the benchmarks you want, on the targets you want
lb run     -g basic arithmetic memory blocks --target zeroasic xilinx ice40

# 2. collect per-target metrics into results/
lb collect -g basic arithmetic memory blocks --target zeroasic xilinx ice40 -o results

# 3. merge into the committed database
python dashboard/build_db.py --results results        # writes results/db.json

# 4. (optional) preview locally
python dashboard/generate.py                          # writes site/
open site/fpga.html

# 5. commit results/db.json -> push -> Pages rebuilds automatically
```

Where things live
------------------

- `build_db.py` -- merges `results/<target>.json` into `results/db.json`. Owns
  metric **presentation** metadata (`METRIC_INFO`: label, better-is-lower/higher,
  display unit) and the benchmark group layout. Imports `logikbench`, so run it
  offline.
- `generate.py` -- renders `db.json` into static HTML. Jinja2 only.
- `templates/dashboard.html.j2` -- the page (inline CSS + vanilla JS; the tab
  selector and heatmap coloring run client-side off the embedded data).

`logikbench` itself only knows metric *names* (`METRICS` / `ASIC_METRICS`); how
to display them is a dashboard concern and lives here.

One-time repo setup
-------------------

Enable Pages: **Settings -> Pages -> Build and deployment -> Source: GitHub
Actions**.
