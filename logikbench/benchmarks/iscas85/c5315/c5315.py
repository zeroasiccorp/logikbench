from os.path import dirname, abspath
from siliconcompiler import Design


class C5315(Design):
    def __init__(self):

        name = 'c5315'
        root = f'{name}_root'
        source = ['rtl/c5315.v']

        # create a Design object
        super().__init__(name)

        # set data home directory
        self.set_dataroot(root, dirname(abspath(__file__)))

        # rtl files
        fileset = 'rtl'
        for item in source:
            self.add_file(item, fileset, dataroot=root)

        # top module
        self.set_topmodule('c5315', fileset)


if __name__ == "__main__":
    d = C5315()
    d.write_fileset("c5315.f", fileset="rtl")
