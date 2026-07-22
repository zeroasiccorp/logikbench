from os.path import dirname, abspath
from siliconcompiler import Design
from logikbench.benchmarks.basic.variants import BASIC_DW_2D, BASIC_N


class Muxhot(Design):
    def __init__(self):

        name = 'muxhot'
        root = f'{name}_root'
        source = [f'rtl/{name}.v']

        # create a Design object
        super().__init__(name)

        # set data home directory
        self.set_dataroot(root, dirname(abspath(__file__)))

        # rtl files
        fileset = 'rtl'
        for item in source:
            self.add_file(item, fileset, dataroot=root)

        # top module
        self.set_topmodule(name, fileset)

        # self-checking testbench (`lb sim`)
        self.add_file(f'testbench/test_{name}_smoke.v', 'testbench', dataroot=root)
        self.set_topmodule(f'test_{name}_smoke', 'testbench')

        # variants
        self.variants = {
            "DW": BASIC_DW_2D,
            "N": BASIC_N,
        }


if __name__ == "__main__":
    d = Muxhot()
    d.write_fileset("muxhot.f", fileset="rtl")
