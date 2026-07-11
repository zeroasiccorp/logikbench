from os.path import dirname, abspath
from siliconcompiler import Design


class S1196(Design):
    def __init__(self):

        name = 's1196'
        root = f'{name}_root'
        source = ['rtl/s1196.v']

        # create a Design object
        super().__init__(name)

        # set data home directory
        self.set_dataroot(root, dirname(abspath(__file__)))

        # rtl files
        fileset = 'rtl'
        for item in source:
            self.add_file(item, fileset, dataroot=root)

        # top module
        self.set_topmodule('s1196', fileset)

        # timing constraints (clock port is 'CK'; see sdc/s1196.sdc)
        self.add_file('sdc/s1196.sdc', 'sdc', dataroot=root)


if __name__ == "__main__":
    d = S1196()
    d.write_fileset("s1196.f", fileset="rtl")
