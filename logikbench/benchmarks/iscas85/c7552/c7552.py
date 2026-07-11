from os.path import dirname, abspath
from siliconcompiler import Design


class C7552(Design):
    def __init__(self):

        name = 'c7552'
        root = f'{name}_root'
        source = ['rtl/c7552.v']

        # create a Design object
        super().__init__(name)

        # set data home directory
        self.set_dataroot(root, dirname(abspath(__file__)))

        # rtl files
        fileset = 'rtl'
        for item in source:
            self.add_file(item, fileset, dataroot=root)

        # top module
        self.set_topmodule('c7552', fileset)


if __name__ == "__main__":
    d = C7552()
    d.write_fileset("c7552.f", fileset="rtl")
