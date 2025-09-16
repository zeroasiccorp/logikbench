import common
import subprocess
from jinja2 import Template

def run_yosys(dlist):

    yosys_template =  """
# Read the Verilog source file
read_slang -f {{ cmdfile }} --top {{ topmodule }}

# Set the top module
hierarchy -top {{ topmodule }}

# Generic synthesis
proc; opt; flatten; opt

# Get stats
stat

# Write synthesized netlist in Verilog
write_verilog {{ netlist }}
"""

    template = Template(yosys_template)

    for item in dlist:
        name = item.name
        cmdfile = f'{name}.f'
        netlist =  f'{name}.vg'

        # create -f cmd file
        item.write_fileset(cmdfile, fileset='rtl')
        topmodule = item.get_topmodule(fileset='rtl')

        # create yosys script from template
        context = {
            'topmodule': topmodule,
            'cmdfile': cmdfile,
            'netlist' : netlist
        }
        output = template.render(context)
        script = f"{name}.ys"
        with open(script, 'w') as f:
            f.write(output)

        # run yosys
        cmd = ["yosys",
               "-m", "slang",
               "-s", script]
        print(' '.join(cmd))
        result = subprocess.run(cmd,
                                check=True,
                                capture_output=True,
                                text=True)

        #grab stats here if you like
        #print(result)

def test_yosys_basic():
    run_yosys(common.basic_list)

def test_yosys_memory():
    run_yosys(common.memory_list)

def test_yosys_arithmetic():
    run_yosys(common.arithmetic_list)

def test_yosys_blocks():
    run_yosys(common.block_list)
