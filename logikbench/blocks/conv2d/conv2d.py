from os.path import dirname, abspath
from siliconcompiler import Design
from lambdalib.ramlib import Spram


class Conv2d(Design):
    def __init__(self):

        name = 'conv2d'
        root = f'{name}_root'
        source = ['rtl/conv2d.v']

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

        # timing constraints
        self.add_file(f'sdc/{name}.sdc', 'sdc', dataroot=root)


if __name__ == "__main__":
    d = Conv2d()
    d.write_fileset("conv2d.f", fileset="rtl")
