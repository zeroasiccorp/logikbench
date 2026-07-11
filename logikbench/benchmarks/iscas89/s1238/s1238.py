from os.path import dirname, abspath
from siliconcompiler import Design


class S1238(Design):
    def __init__(self):

        name = 's1238'
        root = f'{name}_root'
        source = ['rtl/s1238.v']

        # create a Design object
        super().__init__(name)

        # set data home directory
        self.set_dataroot(root, dirname(abspath(__file__)))

        # rtl files
        fileset = 'rtl'
        for item in source:
            self.add_file(item, fileset, dataroot=root)

        # top module
        self.set_topmodule('s1238', fileset)

        # timing constraints (clock port is 'CK'; see sdc/s1238.sdc)
        self.add_file('sdc/s1238.sdc', 'sdc', dataroot=root)


if __name__ == "__main__":
    d = S1238()
    d.write_fileset("s1238.f", fileset="rtl")
