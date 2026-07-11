from os.path import dirname, abspath
from siliconcompiler import Design


class Memctrl(Design):
    def __init__(self):

        name = 'memctrl'
        root = f'{name}_root'
        source = ['rtl/memctrl.v']

        # create a Design object
        super().__init__(name)

        # set data home directory
        self.set_dataroot(root, dirname(abspath(__file__)))

        # rtl files
        fileset = 'rtl'
        for item in source:
            self.add_file(item, fileset, dataroot=root)

        # top module
        self.set_topmodule('memctrl', fileset)


if __name__ == "__main__":
    d = Memctrl()
    d.write_fileset("memctrl.f", fileset="rtl")
