import common
import subprocess

def run_icarus(dlist):
    for item in dlist:
        name = item.name
        ifile = f'{name}.f'
        ofile = f'{name}.vvp'
        item.write_fileset(ifile, fileset='rtl')
        subprocess.run(["iverilog", "-f", ifile, "-o", ofile,], check=True)

def test_icarus_basic():
    run_icarus(common.basic_list)

def test_icarus_memory():
    run_icarus(common.memory_list)

def test_icarus_arithmetic():
    run_icarus(common.arithmetic_list)

def test_icarus_block():
    run_icarus(common.block_list)
