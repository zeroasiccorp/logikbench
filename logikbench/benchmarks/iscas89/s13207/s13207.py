from os.path import dirname, abspath
from siliconcompiler import Design


class S13207(Design):
    def __init__(self):

        name = 's13207'
        root = f'{name}_root'
        source = ['rtl/s13207.v']

        # create a Design object
        super().__init__(name)

        # set data home directory
        self.set_dataroot(root, dirname(abspath(__file__)))

        # rtl files
        fileset = 'rtl'
        for item in source:
            self.add_file(item, fileset, dataroot=root)

        # top module
        self.set_topmodule('s13207', fileset)

        # timing constraints (clock port is 'CK'; see sdc/s13207.sdc)
        self.add_file('sdc/s13207.sdc', 'sdc', dataroot=root)


if __name__ == "__main__":
    d = S13207()
    d.write_fileset("s13207.f", fileset="rtl")
