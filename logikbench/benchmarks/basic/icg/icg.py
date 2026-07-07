from os.path import dirname, abspath
from siliconcompiler import Design
from lambdalib.auxlib import Clkicgand


class Icg(Design):
    def __init__(self):

        name = 'icg'
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

        # lambdalib integrated clock-gating primitive (la_clkicgand)
        with self.active_fileset(fileset):
            self.add_depfileset(Clkicgand(), "rtl")


if __name__ == "__main__":
    d = Icg()
    d.write_fileset("icg.f", fileset="rtl")
