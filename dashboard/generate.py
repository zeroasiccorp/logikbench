#!/usr/bin/env python3
"""Render the results dashboard from a self-describing db.json.

This is the only step the GitHub Action runs. It depends on Jinja2 alone -- no
logikbench, no SiliconCompiler -- so Pages can rebuild from the committed
db.json without any EDA tooling. db.json carries everything needed (targets,
metric metadata, group layout, values); see dashboard/build_db.py.

One page is emitted per flow present in db.json (fpga.html, asic.html), plus an
index.html that redirects to the first one.
"""

import argparse
import json
import os

from jinja2 import Environment, FileSystemLoader

_HERE = os.path.dirname(os.path.abspath(__file__))
FLOW_LABEL = {"fpga": "FPGA", "asic": "ASIC"}

_REDIRECT = """<!doctype html>
<meta charset="utf-8">
<meta http-equiv="refresh" content="0; url={target}">
<title>LogikBench Results</title>
<a href="{target}">LogikBench results</a>
"""


def main():
    ap = argparse.ArgumentParser(description=__doc__,
                                 formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--db", default=os.path.join("results", "db.json"),
                    metavar="FILE", help="Database file (default: results/db.json)")
    ap.add_argument("-o", "--out", default="site", metavar="DIR",
                    help="Output directory for the static site (default: site)")
    args = ap.parse_args()

    with open(args.db) as f:
        db = json.load(f)

    flows = [f for f in ("fpga", "asic") if f in db]
    if not flows:
        ap.error(f"{args.db} contains no flows")

    nav = [{"key": f, "label": FLOW_LABEL[f], "href": f"{f}.html"} for f in flows]

    env = Environment(loader=FileSystemLoader(os.path.join(_HERE, "templates")),
                      autoescape=False)
    template = env.get_template("dashboard.html.j2")

    os.makedirs(args.out, exist_ok=True)
    for flow in flows:
        section = db[flow]
        n = len(section["data"])
        subtitle = (f"{n} benchmark(s) across {len(section['targets'])} "
                    f"{FLOW_LABEL[flow]} target(s)")
        html = template.render(
            flow=flow,
            flow_label=FLOW_LABEL[flow],
            flows=nav,
            subtitle=subtitle,
            section_json=json.dumps(section),
        )
        path = os.path.join(args.out, f"{flow}.html")
        with open(path, "w") as fh:
            fh.write(html)
        print(f"Wrote {path} ({n} benchmarks).")

    index = os.path.join(args.out, "index.html")
    with open(index, "w") as fh:
        fh.write(_REDIRECT.format(target=f"{flows[0]}.html"))
    print(f"Wrote {index} (redirect to {flows[0]}.html).")


if __name__ == "__main__":
    main()
