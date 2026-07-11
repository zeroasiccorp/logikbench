from os.path import dirname, abspath
from siliconcompiler import Design


class Hft(Design):
    def __init__(self):

        name = 'hft'
        root = f'{name}_root'
        source = [f'rtl/{name}_parser.v',
                  f'rtl/{name}_book.v',
                  f'rtl/{name}_feature.v',
                  f'rtl/{name}_strategy.v',
                  f'rtl/{name}_risk.v',
                  f'rtl/{name}_encoder.v',
                  f'rtl/{name}.v']

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


if __name__ == "__main__":
    d = Hft()
    d.write_fileset("hft.f", fileset="rtl")
