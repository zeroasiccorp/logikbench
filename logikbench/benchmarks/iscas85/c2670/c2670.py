from os.path import dirname, abspath
from siliconcompiler import Design


class C2670(Design):
    def __init__(self):

        name = 'c2670'
        root = f'{name}_root'
        source = ['rtl/c2670.v']

        # create a Design object
        super().__init__(name)

        # set data home directory
        self.set_dataroot(root, dirname(abspath(__file__)))

        # rtl files
        fileset = 'rtl'
        for item in source:
            self.add_file(item, fileset, dataroot=root)

        # top module
        self.set_topmodule('c2670', fileset)


if __name__ == "__main__":
    d = C2670()
    d.write_fileset("c2670.f", fileset="rtl")
