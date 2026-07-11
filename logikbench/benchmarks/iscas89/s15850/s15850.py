from os.path import dirname, abspath
from siliconcompiler import Design


class S15850(Design):
    def __init__(self):

        name = 's15850'
        root = f'{name}_root'
        source = ['rtl/s15850.v']

        # create a Design object
        super().__init__(name)

        # set data home directory
        self.set_dataroot(root, dirname(abspath(__file__)))

        # rtl files
        fileset = 'rtl'
        for item in source:
            self.add_file(item, fileset, dataroot=root)

        # top module
        self.set_topmodule('s15850', fileset)

        # timing constraints (clock port is 'CK'; see sdc/s15850.sdc)
        self.add_file('sdc/s15850.sdc', 'sdc', dataroot=root)


if __name__ == "__main__":
    d = S15850()
    d.write_fileset("s15850.f", fileset="rtl")
