from os.path import dirname, abspath
from siliconcompiler import Design
from lambdalib.ramlib import Spram


class Rambit(Design):
    def __init__(self):

        name = 'rambit'
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

        # lambdalib memory primitive
        self.add_depfileset(Spram(), fileset=fileset)

        # top module
        self.set_topmodule(name, fileset)

        # timing constraints
        self.add_file(f'sdc/{name}.sdc', 'sdc', dataroot=root)


if __name__ == "__main__":
    d = Rambit()
    d.write_fileset("rambit.f", fileset="rtl")
