from os.path import dirname, abspath
from siliconcompiler import Design


class C1908(Design):
    def __init__(self):

        name = 'c1908'
        root = f'{name}_root'
        source = ['rtl/c1908.v']

        # create a Design object
        super().__init__(name)

        # set data home directory
        self.set_dataroot(root, dirname(abspath(__file__)))

        # rtl files
        fileset = 'rtl'
        for item in source:
            self.add_file(item, fileset, dataroot=root)

        # top module
        self.set_topmodule('c1908', fileset)


if __name__ == "__main__":
    d = C1908()
    d.write_fileset("c1908.f", fileset="rtl")
