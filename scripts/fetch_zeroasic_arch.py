import argparse
import json
import os
import shutil
import sys
import tarfile
import tempfile
import urllib.error
import urllib.request
from pathlib import Path

# Vendor the FPGA architecture files needed by 'synth_fpga -config' from the
# siliconcompiler/logiklib GitHub releases into the LogikBench source tree.
#
# Each release ships one '<part>_cad.tar.gz' per FPGA part. Every tarball
# unpacks to '<part>/cad/...' and contains a '<part>_yosys_config.json' that is
# the file passed to wildebeest's 'synth_fpga -config'. We copy that JSON plus
# only the files it references (flop/BRAM/DSP techmaps and memory libmaps) into
# one directory per part: <dest>/<part>/. wildebeest resolves the JSON's
# relative paths against the JSON's own directory, and all referenced files live
# flat alongside it in 'cad/', so no rewriting of the JSON is needed.

REPO = "siliconcompiler/logiklib"
RELEASES_URL = f"https://api.github.com/repos/{REPO}/releases"
ASSET_SUFFIX = "_cad.tar.gz"

# Default destination relative to the repo root (parent of this scripts/ dir).
DEFAULT_DEST = Path(__file__).resolve().parent.parent / \
    "logikbench" / "targets" / "fpga" / "zeroasic"


def _request(url):
    # GitHub API request, authenticated with GITHUB_TOKEN when present to avoid
    # the low unauthenticated rate limit in CI.
    headers = {
        "Accept": "application/vnd.github+json",
        "User-Agent": "logikbench-fetch-zeroasic-arch",
    }
    token = os.environ.get("GITHUB_TOKEN")
    if token:
        headers["Authorization"] = f"Bearer {token}"
    req = urllib.request.Request(url, headers=headers)
    with urllib.request.urlopen(req) as resp:
        return resp.read()


def resolve_release(tag):
    # Return the release dict for 'tag', or the newest non-prerelease release.
    releases = json.loads(_request(RELEASES_URL))
    if tag:
        for rel in releases:
            if rel.get("tag_name") == tag:
                return rel
        sys.exit(f"error: release tag '{tag}' not found in {REPO}")
    for rel in releases:
        if not rel.get("prerelease") and not rel.get("draft"):
            return rel
    sys.exit(f"error: no stable (non-prerelease) release found in {REPO}")


def download(url, path):
    with urllib.request.urlopen(
            urllib.request.Request(
                url,
                headers={"User-Agent": "logikbench-fetch-zeroasic-arch"})) as resp:
        path.write_bytes(resp.read())


def referenced_files(config):
    # Collect the relative paths the config references and that synth_fpga reads:
    # flipflops.techmap, brams.memory_libmap[], brams.techmap[], dsps.techmap.
    # The flipflops.models block is intentionally ignored: synth_fpga does not
    # read it. Empty strings and empty lists are skipped.
    refs = []

    def add(value):
        if isinstance(value, str) and value.strip():
            refs.append(value)
        elif isinstance(value, list):
            for item in value:
                add(item)

    flipflops = config.get("flipflops", {})
    add(flipflops.get("techmap"))

    brams = config.get("brams", {})
    add(brams.get("memory_libmap"))
    add(brams.get("techmap"))

    dsps = config.get("dsps", {})
    add(dsps.get("techmap"))

    return refs


def vendor_part(tar_path, dest):
    # Extract one '<part>_cad.tar.gz', then copy its yosys config plus the files
    # it references into '<dest>/<part>/'. Returns the part name.
    with tempfile.TemporaryDirectory() as tmp:
        with tarfile.open(tar_path) as tf:
            tf.extractall(tmp)

        cad_dirs = list(Path(tmp).glob("*/cad"))
        if not cad_dirs:
            sys.exit(f"error: {tar_path.name} has no '<part>/cad' directory")
        cad = cad_dirs[0]
        part = cad.parent.name

        config_path = cad / f"{part}_yosys_config.json"
        if not config_path.is_file():
            sys.exit(f"error: {tar_path.name} missing {config_path.name}")
        config = json.loads(config_path.read_text())

        out_dir = dest / part
        if out_dir.exists():
            shutil.rmtree(out_dir)
        out_dir.mkdir(parents=True)

        # The config JSON itself.
        shutil.copy2(config_path, out_dir / config_path.name)

        # Each referenced file. Paths may be absolute-looking ('/tech_bram.v')
        # or relative ('tech_flops.v'); all live flat in cad/, so match by
        # basename.
        written = [config_path.name]
        for ref in referenced_files(config):
            name = os.path.basename(ref.lstrip("/"))
            src = cad / name
            if not src.is_file():
                sys.exit(
                    f"error: {part}: config references '{ref}' but "
                    f"'{name}' is not in the tarball")
            shutil.copy2(src, out_dir / name)
            written.append(name)

        return part, written


def main():
    parser = argparse.ArgumentParser(description="""\

LogikBench zeroasic FPGA architecture fetcher.
-Downloads per-part '<part>_cad.tar.gz' assets from a siliconcompiler/logiklib
 release and vendors the files needed by 'synth_fpga -config' into one
 directory per part under the destination.
-Without -tag, the newest stable (non-prerelease) release is used.

Example Usage:
fetch_zeroasic_arch.py --clean
fetch_zeroasic_arch.py --tag v0.3.0 --dest /tmp/zarch
""", formatter_class=argparse.RawDescriptionHelpFormatter)

    parser.add_argument(
        "--tag", help="logiklib release tag to fetch (default: latest stable)")
    parser.add_argument(
        "--dest", type=Path, default=DEFAULT_DEST,
        help="destination directory (default: targets/fpga/zeroasic)")
    parser.add_argument(
        "--clean", action="store_true",
        help="remove part directories no longer present in the release")

    args = parser.parse_args()

    release = resolve_release(args.tag)
    tag = release.get("tag_name")
    assets = [a for a in release.get("assets", [])
              if a["name"].endswith(ASSET_SUFFIX)]
    if not assets:
        sys.exit(f"error: release '{tag}' has no '*{ASSET_SUFFIX}' assets")

    print(f"Fetching zeroasic architectures from {REPO} release {tag}")
    args.dest.mkdir(parents=True, exist_ok=True)

    parts = []
    with tempfile.TemporaryDirectory() as tmp:
        for asset in sorted(assets, key=lambda a: a["name"]):
            tar_path = Path(tmp) / asset["name"]
            download(asset["browser_download_url"], tar_path)
            part, written = vendor_part(tar_path, args.dest)
            parts.append(part)
            print(f"  {part}: {', '.join(written)}")

    if args.clean:
        for child in sorted(args.dest.iterdir()):
            if child.is_dir() and child.name not in parts:
                shutil.rmtree(child)
                print(f"  removed stale part directory: {child.name}")

    # Provenance manifest so the release version is visible in the diff.
    manifest = {
        "source_repo": REPO,
        "release_tag": tag,
        "parts": sorted(parts),
        "assets": sorted(a["name"] for a in assets),
    }
    (args.dest / "SOURCE.json").write_text(
        json.dumps(manifest, indent=2) + "\n")

    print(f"Vendored {len(parts)} part(s) into {args.dest}")


if __name__ == "__main__":
    main()
