from os.path import dirname, abspath
from siliconcompiler import Design


class S641(Design):
    def __init__(self):

        name = 's641'
        root = f'{name}_root'
        source = ['rtl/s641.v']

        # create a Design object
        super().__init__(name)

        # set data home directory
        self.set_dataroot(root, dirname(abspath(__file__)))

        # rtl files
        fileset = 'rtl'
        for item in source:
            self.add_file(item, fileset, dataroot=root)

        # top module
        self.set_topmodule('s641', fileset)

        # timing constraints (clock port is 'CK'; see sdc/s641.sdc)
        self.add_file('sdc/s641.sdc', 'sdc', dataroot=root)


if __name__ == "__main__":
    d = S641()
    d.write_fileset("s641.f", fileset="rtl")
