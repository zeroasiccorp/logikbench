import subprocess

import pytest


@pytest.mark.eda
def test_icarus(benchmark):
    """Each benchmark elaborates through Icarus Verilog."""
    name = benchmark.name
    ifile, ofile = f"{name}.f", f"{name}.vvp"
    benchmark.write_fileset(ifile, fileset='rtl')
    subprocess.run(["iverilog", "-f", ifile, "-o", ofile], check=True)
