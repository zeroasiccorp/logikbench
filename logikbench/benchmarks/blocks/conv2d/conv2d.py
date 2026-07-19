from os.path import dirname, abspath
from siliconcompiler import Design
from logikbench.benchmarks.blocks.variants import BLOCKS_DW
from lambdalib.ramlib import Spram


class Conv2d(Design):
    def __init__(self):

        name = 'conv2d'
        root = f'{name}_root'
        source = ['rtl/conv2d.v']

        # create a Design object
        super().__init__(name)

        # set data home directory
        self.set_dataroot(root, dirname(abspath(__file__)))

        # rtl files
        fileset = 'rtl'
        for item in source:
            self.add_file(item, fileset, dataroot=root)

        # line-buffer BRAM
        self.add_depfileset(Spram(), "rtl", fileset=fileset)

        # top module
        self.set_topmodule(name, fileset)

        # self-checking testbench (`lb sim`)
        self.add_file(f'testbench/test_{name}_smoke.v', 'testbench', dataroot=root)
        self.set_topmodule(f'test_{name}_smoke', 'testbench')

        # variants
        self.variants = {
            "DW": BLOCKS_DW,
        }


if __name__ == "__main__":
    d = Conv2d()
    d.write_fileset("conv2d.f", fileset="rtl")
