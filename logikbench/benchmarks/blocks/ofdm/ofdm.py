from os.path import dirname, abspath
from siliconcompiler import Design
from logikbench.benchmarks.blocks.fft.fft import Fft


class Ofdm(Design):
    def __init__(self):

        name = 'ofdm'
        root = f'{name}_root'
        source = ['rtl/ofdm_tx.v', 'rtl/ofdm_rx.v', 'rtl/ofdm.v']

        # create a Design object
        super().__init__(name)

        # set data home directory
        self.set_dataroot(root, dirname(abspath(__file__)))

        # rtl files
        fileset = 'rtl'
        for item in source:
            self.add_file(item, fileset, dataroot=root)

        # transform engine: reuse the fft block
        self.add_depfileset(Fft(), fileset=fileset)

        # top module
        self.set_topmodule(name, fileset)

        # self-checking testbench (`lb sim`)
        self.add_file(f'testbench/test_{name}_smoke.v', 'testbench', dataroot=root)
        self.set_topmodule(f'test_{name}_smoke', 'testbench')


if __name__ == "__main__":
    d = Ofdm()
    d.write_fileset("ofdm.f", fileset="rtl")
