import common
import subprocess
from jinja2 import Environment, FileSystemLoader

def run_yosys(dlist):

    env = Environment(loader=FileSystemLoader('.'))
    template = env.get_template('template.ys.j2')

    for item in dlist:
        name = item.name()
        cmdfile = f'{name}.f'
        netlist =  f'{name}.vg'
        # create .f cmd file
        item.write_fileset(cmdfile, fileset='rtl')
        topmodule = item.get_topmodule(fileset='rtl')

        # clean up cmd file (yosys bug)
        cleanfile = cmdfile + ".clean"

        with open(cmdfile, "r") as f_in, open(cleanfile, "w") as f_out:
            for line in f_in:
                if "//" not in line.strip():
                    f_out.write(line)

        # create yosys script
        context = {
            'topmodule': topmodule,
            'cmdfile': cleanfile,
            'netlist' : netlist
        }
        output = template.render(context)
        script = f"{name}.ys"
        with open(script, 'w') as f:
            f.write(output)
        # run
        subprocess.run(["yosys", "-s", script], check=True)

def test_yosys_basic():
    run_yosys(common.basic_list)

def test_yosys_memory():
    run_yosys(common.memory_list)

def test_icarus_arithmetic():
    run_yosys(common.arithmetic_list)
