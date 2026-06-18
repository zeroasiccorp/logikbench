import os

import pytest

import logikbench


# Benchmarks tested elsewhere or not standalone-buildable. Keyed by class name.
SKIP = set()


@pytest.fixture(autouse=True)
def test_wrapper(tmp_path):
    """Run each test in its own temporary directory to avoid clutter (the
    benchmark filelists/netlists/scripts are written to cwd)."""
    topdir = os.getcwd()
    os.chdir(tmp_path)
    yield
    os.chdir(topdir)


@pytest.fixture(params=[
    (modname, name)
    for modname in logikbench.__all__
    for name in getattr(getattr(logikbench, modname), "__all__", [])
], ids=lambda x: f"{x[0]}-{x[1]}")
def benchmark(request):
    """One instantiated benchmark design per (group, class), auto-discovered
    from the logikbench package. pytest generates one test per benchmark with
    ids like 'arithmetic-Add'; run a single one with, e.g.:

        pytest tests/test_setup.py::test_setup[arithmetic-Add] -v
    """
    modname, name = request.param
    if name in SKIP:
        pytest.skip(f"Skipping {name}.")
    cls = getattr(getattr(logikbench, modname), name)
    return cls()
