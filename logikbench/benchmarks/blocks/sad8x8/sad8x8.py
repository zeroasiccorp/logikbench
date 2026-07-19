from os.path import dirname, abspath
from siliconcompiler import Design
from logikbench.benchmarks.blocks.variants import BLOCKS_N


class Sad8x8(Design):
    def __init__(self):

        name = 'sad8x8'
        root = f'{name}_root'
        source = ['rtl/sad8x8.v']

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
            "N": BLOCKS_N,
        }


if __name__ == "__main__":
    d = Sad8x8()
    d.write_fileset("sad8x8.f", fileset="rtl")
