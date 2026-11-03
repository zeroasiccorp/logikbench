from os.path import dirname, abspath
from siliconcompiler import Design
from logikbench.benchmarks.arithmetic.variants import ADDER_DW


class Addkoggestone(Design):
    def __init__(self):

        name = 'addkoggestone'
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
            "DW": ADDER_DW,
        }


if __name__ == "__main__":
    d = Addkoggestone()
    d.write_fileset("addkoggestone.f", fileset="rtl")
