from os.path import dirname, abspath
from siliconcompiler import Design


class S38584(Design):
    def __init__(self):

        name = 's38584'
        root = f'{name}_root'
        source = ['rtl/s38584.v']

        # create a Design object
        super().__init__(name)

        # set data home directory
        self.set_dataroot(root, dirname(abspath(__file__)))

        # rtl files
        fileset = 'rtl'
        for item in source:
            self.add_file(item, fileset, dataroot=root)

        # top module
        self.set_topmodule('s38584', fileset)

        # timing constraints (clock port is 'CK'; see sdc/s38584.sdc)
        self.add_file('sdc/s38584.sdc', 'sdc', dataroot=root)


if __name__ == "__main__":
    d = S38584()
    d.write_fileset("s38584.f", fileset="rtl")
