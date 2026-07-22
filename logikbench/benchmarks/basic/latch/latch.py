from os.path import dirname, abspath
from siliconcompiler import Design
from logikbench.benchmarks.basic.variants import BASIC_DW
from lambdalib.veclib import Vlatq


class Latch(Design):
    def __init__(self):

        name = 'latch'
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

        # self-checking testbench (`lb sim`)
        self.add_file(f'testbench/test_{name}_smoke.v', 'testbench', dataroot=root)
        self.set_topmodule(f'test_{name}_smoke', 'testbench')

        # lambdalib transparent-latch primitive (la_vlatq)
        with self.active_fileset(fileset):
            self.add_depfileset(Vlatq(), "rtl")

        # variants
        self.variants = {
            "DW": BASIC_DW,
        }


if __name__ == "__main__":
    d = Latch()
    d.write_fileset("latch.f", fileset="rtl")
