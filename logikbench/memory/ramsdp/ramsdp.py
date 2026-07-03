from os.path import dirname, abspath
from siliconcompiler import Design
from lambdalib.ramlib import Dpram


class Ramsdp(Design):
    def __init__(self):

        name = 'ramsdp'
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
        self.add_depfileset(Dpram(), fileset=fileset)

        # top module
        self.set_topmodule(name, fileset)

        # timing constraints
        self.add_file(f'sdc/{name}.sdc', 'sdc', dataroot=root)


if __name__ == "__main__":
    d = Ramsdp()
    d.write_fileset("ramsdp.f", fileset="rtl")
