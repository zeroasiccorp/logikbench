from os.path import dirname, abspath
from siliconcompiler import Design


class C3540(Design):
    def __init__(self):

        name = 'c3540'
        root = f'{name}_root'
        source = ['rtl/c3540.v']

        # create a Design object
        super().__init__(name)

        # set data home directory
        self.set_dataroot(root, dirname(abspath(__file__)))

        # rtl files
        fileset = 'rtl'
        for item in source:
            self.add_file(item, fileset, dataroot=root)

        # top module
        self.set_topmodule('c3540', fileset)


if __name__ == "__main__":
    d = C3540()
    d.write_fileset("c3540.f", fileset="rtl")
