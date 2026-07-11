from os.path import dirname, abspath
from siliconcompiler import Design


class S820(Design):
    def __init__(self):

        name = 's820'
        root = f'{name}_root'
        source = ['rtl/s820.v']

        # create a Design object
        super().__init__(name)

        # set data home directory
        self.set_dataroot(root, dirname(abspath(__file__)))

        # rtl files
        fileset = 'rtl'
        for item in source:
            self.add_file(item, fileset, dataroot=root)

        # top module
        self.set_topmodule('s820', fileset)

        # timing constraints (clock port is 'CK'; see sdc/s820.sdc)
        self.add_file('sdc/s820.sdc', 'sdc', dataroot=root)


if __name__ == "__main__":
    d = S820()
    d.write_fileset("s820.f", fileset="rtl")
