from os.path import dirname, abspath
from siliconcompiler import Design


class Dotprod(Design):
    def __init__(self):

        name = 'dotprod'
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

        # variants: combinational MAC tree (N multipliers + adder tree). INT8/16
        # with a modest tap count; wider/longer dot products are pipelined or
        # systolic in real hardware, not a single-cycle reduction.
        self.variants = {
            "DW": [8, 16],
            "N": [2, 4, 8, 16],
        }


if __name__ == "__main__":
    d = Dotprod()
    d.write_fileset("dotprod.f", fileset="rtl")
