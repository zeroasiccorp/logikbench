from os.path import dirname, abspath
from siliconcompiler import Design
from logikbench.benchmarks.arithmetic.variants import ARITH_DW


class Sqrt(Design):
    def __init__(self):

        name = 'sqrt'
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

        # variants (input width must be even: root is DW/2)
        self.variants = {
            "DW": [w for w in ARITH_DW if w % 2 == 0],
        }


if __name__ == "__main__":
    d = Sqrt()
    d.write_fileset("sqrt.f", fileset="rtl")
