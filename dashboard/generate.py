#!/usr/bin/env python3
"""Render one dashboard page per config from the per-config databases.

build_db.py writes results/fpga/<config>.json (one self-describing section
each, e.g. small.json, fast.json). This renders site/<config>.html for each,
with a switcher across configs plus an index.html redirect. Depends on Jinja2
alone -- no logikbench, no SiliconCompiler -- so Pages can rebuild from the
committed databases without any EDA tooling.
"""

import argparse
import glob
import json
import os

from jinja2 import Environment, FileSystemLoader

_HERE = os.path.dirname(os.path.abspath(__file__))

_REDIRECT = """<!doctype html>
<meta charset="utf-8">
<meta http-equiv="refresh" content="0; url={target}">
<title>LogikBench Results</title>
<a href="{target}">LogikBench results</a>
"""


def _is_section(data):
    """A build_db section/db (vs a collect payload, which has a "target" key)."""
    return isinstance(data, dict) and "data" in data and "targets" in data


def load_configs(db_dir):
    """[(config, section)] from the <config>.json databases in db_dir."""
    configs = []
    for path in sorted(glob.glob(os.path.join(db_dir, "*.json"))):
        with open(path) as f:
            data = json.load(f)
        if _is_section(data):
            configs.append((os.path.splitext(os.path.basename(path))[0], data))
    return configs


def main():
    ap = argparse.ArgumentParser(description=__doc__,
                                 formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--db", default=os.path.join("results", "fpga"),
                    metavar="DIR",
                    help="Directory with per-config <config>.json databases "
                         "(default: results/fpga)")
    ap.add_argument("-o", "--out", default="site", metavar="DIR",
                    help="Output directory for the static site (default: site)")
    args = ap.parse_args()

    configs = load_configs(args.db)
    if not configs:
        ap.error(f"no <config>.json databases found under {args.db}")

    env = Environment(loader=FileSystemLoader(os.path.join(_HERE, "templates")),
                      autoescape=False)
    template = env.get_template("dashboard.html.j2")

    os.makedirs(args.out, exist_ok=True)
    for name, section in configs:
        n = len(section["data"])
        html = template.render(section_json=json.dumps(section))
        path = os.path.join(args.out, f"{name}.html")
        with open(path, "w") as fh:
            fh.write(html)
        print(f"Wrote {path} ({n} benchmarks).")

    index = os.path.join(args.out, "index.html")
    with open(index, "w") as fh:
        fh.write(_REDIRECT.format(target=f"{configs[0][0]}.html"))
    print(f"Wrote {index} (redirect to {configs[0][0]}.html).")


if __name__ == "__main__":
    main()
