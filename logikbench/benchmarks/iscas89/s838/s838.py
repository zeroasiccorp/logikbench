from os.path import dirname, abspath
from siliconcompiler import Design


class S838(Design):
    def __init__(self):

        name = 's838'
        root = f'{name}_root'
        source = ['rtl/s838.v']

        # create a Design object
        super().__init__(name)

        # set data home directory
        self.set_dataroot(root, dirname(abspath(__file__)))

        # rtl files
        fileset = 'rtl'
        for item in source:
            self.add_file(item, fileset, dataroot=root)

        # top module
        self.set_topmodule('s838', fileset)

        # timing constraints (clock port is 'CK'; see sdc/s838.sdc)
        self.add_file('sdc/s838.sdc', 'sdc', dataroot=root)


if __name__ == "__main__":
    d = S838()
    d.write_fileset("s838.f", fileset="rtl")
