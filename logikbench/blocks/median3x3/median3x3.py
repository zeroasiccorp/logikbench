from os.path import dirname, abspath
from siliconcompiler import Design
from lambdalib.ramlib import Spram


class Median3x3(Design):
    def __init__(self):

        name = 'median3x3'
        root = f'{name}_root'
        source = ['rtl/median3x3.v']

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


if __name__ == "__main__":
    d = Median3x3()
    d.write_fileset("median3x3.f", fileset="rtl")
