from os.path import dirname, abspath
from siliconcompiler import Design


class S526(Design):
    def __init__(self):

        name = 's526'
        root = f'{name}_root'
        source = ['rtl/s526.v']

        # create a Design object
        super().__init__(name)

        # set data home directory
        self.set_dataroot(root, dirname(abspath(__file__)))

        # rtl files
        fileset = 'rtl'
        for item in source:
            self.add_file(item, fileset, dataroot=root)

        # top module
        self.set_topmodule('s526', fileset)

        # timing constraints (clock port is 'CK'; see sdc/s526.sdc)
        self.add_file('sdc/s526.sdc', 'sdc', dataroot=root)


if __name__ == "__main__":
    d = S526()
    d.write_fileset("s526.f", fileset="rtl")
