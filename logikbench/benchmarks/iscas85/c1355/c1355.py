from os.path import dirname, abspath
from siliconcompiler import Design


class C1355(Design):
    def __init__(self):

        name = 'c1355'
        root = f'{name}_root'
        source = ['rtl/c1355.v']

        # create a Design object
        super().__init__(name)

        # set data home directory
        self.set_dataroot(root, dirname(abspath(__file__)))

        # rtl files
        fileset = 'rtl'
        for item in source:
            self.add_file(item, fileset, dataroot=root)

        # top module
        self.set_topmodule('c1355', fileset)


if __name__ == "__main__":
    d = C1355()
    d.write_fileset("c1355.f", fileset="rtl")
