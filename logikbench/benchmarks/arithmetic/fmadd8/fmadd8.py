from os.path import dirname, abspath
from siliconcompiler import Design
from logikbench.benchmarks.arithmetic.fmadd32.fmadd32 import Fmadd32


class Fmadd8(Design):
    def __init__(self):

        name = 'fmadd8'
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

        # datapath: reuse the fmadd32 block (overrides its params to E4M3 fp8)
        self.add_depfileset(Fmadd32(), fileset=fileset)

        # top module
        self.set_topmodule(name, fileset)


if __name__ == "__main__":
    d = Fmadd8()
    d.write_fileset("fmadd8.f", fileset="rtl")
