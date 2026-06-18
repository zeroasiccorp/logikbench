import subprocess

import pytest
from jinja2 import Template

# Generic yosys synthesis script: read the benchmark's RTL via the slang
# frontend, elaborate, run a generic synthesis pass, and write a netlist.
_SCRIPT = Template("""
read_slang -f {{ cmdfile }} --top {{ topmodule }}
hierarchy -top {{ topmodule }}
proc; opt; flatten; opt
stat
write_verilog {{ netlist }}
""")


@pytest.mark.eda
def test_yosys(benchmark):
    """Each benchmark synthesizes through yosys (slang frontend)."""
    name = benchmark.name
    cmdfile, netlist, script = f"{name}.f", f"{name}.vg", f"{name}.ys"

    benchmark.write_fileset(cmdfile, fileset='rtl')
    topmodule = benchmark.get_topmodule(fileset='rtl')
    with open(script, 'w') as f:
        f.write(_SCRIPT.render(cmdfile=cmdfile, topmodule=topmodule,
                               netlist=netlist))

    subprocess.run(["yosys", "-m", "slang", "-s", script],
                   check=True, capture_output=True, text=True)
