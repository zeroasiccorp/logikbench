from os.path import dirname, abspath
from siliconcompiler import Design
from logikbench.benchmarks.blocks.codec8b10b.codec8b10b import Codec8b10b
from logikbench.benchmarks.blocks.wordalign.wordalign import Wordalign
from logikbench.benchmarks.blocks.linkmap.linkmap import Linkmap


class Jesd204b(Design):
    def __init__(self):

        name = 'jesd204b'
        root = f'{name}_root'
        source = [f'rtl/{name}_scramble.v',
                  f'rtl/{name}_tx.v',
                  f'rtl/{name}_rx.v',
                  f'rtl/{name}.v']

        # create a Design object
        super().__init__(name)

        # set data home directory
        self.set_dataroot(root, dirname(abspath(__file__)))

        # rtl files
        fileset = 'rtl'
        for item in source:
            self.add_file(item, fileset, dataroot=root)

        # reuse the serial-link modules
        self.add_depfileset(Codec8b10b(), fileset=fileset)
        self.add_depfileset(Wordalign(), fileset=fileset)
        self.add_depfileset(Linkmap(), fileset=fileset)

        # top module
        self.set_topmodule(name, fileset)

        # self-checking testbench (`lb sim`)
        self.add_file(f'testbench/test_{name}_smoke.v', 'testbench', dataroot=root)
        self.set_topmodule(f'test_{name}_smoke', 'testbench')


if __name__ == "__main__":
    d = Jesd204b()
    d.write_fileset("jesd204b.f", fileset="rtl")
