from os.path import dirname, abspath
from siliconcompiler import Design


class Ddc(Design):
    def __init__(self):

        name = 'ddc'
        root = f'{name}_root'
        source = [f'rtl/{name}_nco.v',
                  f'rtl/{name}_mixer.v',
                  f'rtl/{name}_cic.v',
                  f'rtl/{name}_fir.v',
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
    d = Ddc()
    d.write_fileset("ddc.f", fileset="rtl")
