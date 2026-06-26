import os
import shutil
import subprocess

import pytest

#######################################################
# Compile + run each benchmark's self-checking smoke
# testbench (testbench/test_<name>_smoke.v) with
# iverilog and assert it prints PASSED.
#
# Run a single benchmark, e.g.:
#   pytest tests/test_smoke.py::test_smoke[arithmetic-Add] -v
#######################################################

# seconds allowed per simulation
SIM_TIMEOUT = 180

# Benchmarks whose smoke testbench is too slow to elaborate under iverilog for
# CI (run them manually instead). Keyed by lowercase benchmark name.
SLOW = {"reedsolomon"}


def _rtl_files(design, workdir):
    """Resolve the benchmark's rtl fileset (incl. dependency filesets such as
    lambdalib RAM primitives) to a flat list of absolute source paths."""
    fpath = os.path.join(workdir, f"{design.name}.f")
    design.write_fileset(fpath, fileset="rtl")
    files = []
    with open(fpath) as fh:
        for line in fh:
            line = line.strip()
            # a filelist may carry +incdir+/+define+/comment lines; keep sources
            if line and not line.startswith(("+", "-", "//", "#")):
                files.append(line)
    return files


@pytest.mark.eda
def test_smoke(benchmark):
    """Self-checking iverilog smoke test for benchmarks that ship one."""
    if shutil.which("iverilog") is None or shutil.which("vvp") is None:
        pytest.skip("iverilog/vvp not on PATH")

    name = benchmark.name
    if name in SLOW:
        pytest.skip(f"{name}: iverilog elaboration too slow for CI (run manually)")
    workdir = os.getcwd()                      # conftest chdirs us into tmp_path
    files = _rtl_files(benchmark, workdir)
    if not files:
        pytest.skip(f"{name}: no rtl files")

    # block dir is the parent of the rtl/ dir holding the design's own source
    block_dir = os.path.dirname(os.path.dirname(files[0]))
    tb = os.path.join(block_dir, "testbench", f"test_{name}_smoke.v")
    if not os.path.exists(tb):
        pytest.skip(f"{name}: no smoke testbench")

    # include dirs (covers `include of e.g. sine's ROM table)
    incdirs = sorted({os.path.dirname(f) for f in files})
    vvp_out = os.path.join(workdir, f"{name}.vvp")

    cmd = ["iverilog", "-g2005", "-o", vvp_out]
    for d in incdirs:
        cmd += ["-I", d]
    cmd += files + [tb]
    comp = subprocess.run(cmd, capture_output=True, text=True)
    assert comp.returncode == 0, \
        f"{name}: iverilog compile failed:\n{comp.stdout}\n{comp.stderr}"

    run = subprocess.run(["vvp", vvp_out], capture_output=True, text=True,
                         timeout=SIM_TIMEOUT)
    log = run.stdout + run.stderr
    assert "PASSED" in log and "FAILED" not in log, \
        f"{name}: smoke test did not pass:\n{log}"
