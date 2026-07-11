from os.path import dirname, abspath
from siliconcompiler import Design


class S5378(Design):
    def __init__(self):

        name = 's5378'
        root = f'{name}_root'
        source = ['rtl/s5378.v']

        # create a Design object
        super().__init__(name)

        # set data home directory
        self.set_dataroot(root, dirname(abspath(__file__)))

        # rtl files
        fileset = 'rtl'
        for item in source:
            self.add_file(item, fileset, dataroot=root)

        # top module
        self.set_topmodule('s5378', fileset)

        # timing constraints (clock port is 'CK'; see sdc/s5378.sdc)
        self.add_file('sdc/s5378.sdc', 'sdc', dataroot=root)


if __name__ == "__main__":
    d = S5378()
    d.write_fileset("s5378.f", fileset="rtl")
