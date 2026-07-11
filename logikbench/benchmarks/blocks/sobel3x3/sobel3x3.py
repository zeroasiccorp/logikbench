from os.path import dirname, abspath
from siliconcompiler import Design
from lambdalib.ramlib import Spram


class Sobel3x3(Design):
    def __init__(self):

        name = 'sobel3x3'
        root = f'{name}_root'
        source = ['rtl/sobel3x3.v']

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


if __name__ == "__main__":
    d = Sobel3x3()
    d.write_fileset("sobel3x3.f", fileset="rtl")
