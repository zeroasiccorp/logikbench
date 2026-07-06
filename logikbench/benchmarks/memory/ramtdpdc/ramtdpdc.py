from os.path import dirname, abspath
from siliconcompiler import Design
from lambdalib.ramlib import Tdpram


class Ramtdpdc(Design):
    def __init__(self):

        name = 'ramtdpdc'
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
        self.add_depfileset(Tdpram(), fileset=fileset)

        # top module
        self.set_topmodule(name, fileset)


if __name__ == "__main__":
    d = Ramtdpdc()
    d.write_fileset("ramtdpdc.f", fileset="rtl")
