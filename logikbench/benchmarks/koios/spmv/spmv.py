from os.path import dirname, abspath
from siliconcompiler import Design


class Spmv(Design):
    def __init__(self):

        name = 'spmv'
        root = f'{name}_root'
        source = ['rtl/spmv.v']

        # create a Design object
        super().__init__(name)

        # set data home directory
        self.set_dataroot(root, dirname(abspath(__file__)))

        # rtl files
        fileset = 'rtl'
        for item in source:
            self.add_file(item, fileset, dataroot=root)

        # top module
        self.set_topmodule('spmv', fileset)


if __name__ == "__main__":
    d = Spmv()
    d.write_fileset("spmv.f", fileset="rtl")
