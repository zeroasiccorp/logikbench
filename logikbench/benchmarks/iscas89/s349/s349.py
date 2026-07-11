from os.path import dirname, abspath
from siliconcompiler import Design


class S349(Design):
    def __init__(self):

        name = 's349'
        root = f'{name}_root'
        source = ['rtl/s349.v']

        # create a Design object
        super().__init__(name)

        # set data home directory
        self.set_dataroot(root, dirname(abspath(__file__)))

        # rtl files
        fileset = 'rtl'
        for item in source:
            self.add_file(item, fileset, dataroot=root)

        # top module
        self.set_topmodule('s349', fileset)

        # timing constraints (clock port is 'CK'; see sdc/s349.sdc)
        self.add_file('sdc/s349.sdc', 'sdc', dataroot=root)


if __name__ == "__main__":
    d = S349()
    d.write_fileset("s349.f", fileset="rtl")
