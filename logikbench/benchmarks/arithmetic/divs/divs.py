from os.path import dirname, abspath
from siliconcompiler import Design


class Divs(Design):
    def __init__(self):

        name = 'divs'
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

        # sweepable parameter ranges (defaults live in the RTL)
        self.parameters = {
            "DW": {"sweep": range(1, 65)},
        }

        # self-checking testbench (`lb sim`)
        self.add_file(f'testbench/test_{name}_smoke.v', 'testbench', dataroot=root)
        self.set_topmodule(f'test_{name}_smoke', 'testbench')


if __name__ == "__main__":
    d = Divs()
    d.write_fileset("divs.f", fileset="rtl")
