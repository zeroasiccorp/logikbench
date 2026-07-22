from os.path import dirname, abspath
from siliconcompiler import Design
from logikbench.benchmarks.blocks.variants import BLOCKS_DW


class Colorconv(Design):
    def __init__(self):

        name = 'colorconv'
        root = f'{name}_root'
        # leaf modules first, top last (single compilation unit)
        source = ['rtl/colorconv_matrix.v', 'rtl/colorconv_clamp.v',
                  'rtl/colorconv.v']

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

        # pixel component width
        self.set_param('DW', '8', fileset)

        # self-checking testbench (`lb sim`)
        self.add_file(f'testbench/test_{name}_smoke.v', 'testbench', dataroot=root)
        self.set_topmodule(f'test_{name}_smoke', 'testbench')

        # variants
        self.variants = {
            "DW": BLOCKS_DW,
        }


if __name__ == "__main__":
    d = Colorconv()
    d.write_fileset("colorconv.f", fileset="rtl")
