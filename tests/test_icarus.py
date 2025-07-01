import common
import subprocess


def run_icarus(dlist):
    for item in dlist:
        name = item.name()
        ifile = f'{name}.f'
        ofile = f'{name}.vvp'
        item.write_fileset(ifile, fileset='rtl')
        subprocess.run(["iverilog", "-f", ifile, "-o", ofile,], check=True)

def test_basic_compile():
    run_icarus(common.basic_list)

def test_memory_compile():
    run_icarus(common.memory_list)

def test_arithmetic_compile():
    run_icarus(common.arithmetic_list)

def test_block_compile():
    run_icarus(common.block_list)
