from os.path import dirname, abspath
from siliconcompiler import Design


class Mux(Design):
    def __init__(self):

        name = 'mux'
        root = f'{name}_root'
        source = [f'rtl/{name}.v']

        # create a Design object
        super().__init__(name)

        # set data home directory
        self.set_dataroot(root, dirname(abspath(__file__)))

        # rtl files
        fileset = 'rtl'
        for item in source:
            self.add_file(item, fileset, dataroot=root)

        # top module
        self.set_topmodule(name, fileset)

        # self-checking testbench (its own fileset; top instantiates the DUT
        # and prints PASSED/FAILED). Used by `lb sim`.
        tb = 'testbench'
        self.add_file(f'testbench/test_{name}_smoke.v', tb, dataroot=root)
        self.set_topmodule(f'test_{name}_smoke', tb)


if __name__ == "__main__":
    d = Mux()
    d.write_fileset("mux.f", fileset="rtl")
