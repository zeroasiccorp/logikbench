from os.path import dirname, abspath
from siliconcompiler import Design


class S9234(Design):
    def __init__(self):

        name = 's9234'
        root = f'{name}_root'
        source = ['rtl/s9234.v']

        # create a Design object
        super().__init__(name)

        # set data home directory
        self.set_dataroot(root, dirname(abspath(__file__)))

        # rtl files
        fileset = 'rtl'
        for item in source:
            self.add_file(item, fileset, dataroot=root)

        # top module
        self.set_topmodule('s9234', fileset)

        # timing constraints (clock port is 'CK'; see sdc/s9234.sdc)
        self.add_file('sdc/s9234.sdc', 'sdc', dataroot=root)


if __name__ == "__main__":
    d = S9234()
    d.write_fileset("s9234.f", fileset="rtl")
