from os.path import dirname, abspath
from siliconcompiler import Design


class S38417(Design):
    def __init__(self):

        name = 's38417'
        root = f'{name}_root'
        source = ['rtl/s38417.v']

        # create a Design object
        super().__init__(name)

        # set data home directory
        self.set_dataroot(root, dirname(abspath(__file__)))

        # rtl files
        fileset = 'rtl'
        for item in source:
            self.add_file(item, fileset, dataroot=root)

        # top module
        self.set_topmodule('s38417', fileset)

        # timing constraints (clock port is 'CK'; see sdc/s38417.sdc)
        self.add_file('sdc/s38417.sdc', 'sdc', dataroot=root)


if __name__ == "__main__":
    d = S38417()
    d.write_fileset("s38417.f", fileset="rtl")
