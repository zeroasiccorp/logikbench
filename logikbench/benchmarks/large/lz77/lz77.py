from os.path import dirname, abspath
from siliconcompiler import Design
from lambdalib.ramlib import Spram


class Lz77(Design):
    def __init__(self):

        name = 'lz77'
        root = f'{name}_root'
        source = ['rtl/lz77_hash.v',
                  'rtl/lz77_cand.v',
                  'rtl/lz77_hbank.v',
                  'rtl/lz77_enc.v',
                  'rtl/lz77_dec.v',
                  'rtl/lz77.v']

        # create a Design object
        super().__init__(name)

        # set data home directory
        self.set_dataroot(root, dirname(abspath(__file__)))

        # rtl files
        fileset = 'rtl'
        for item in source:
            self.add_file(item, fileset, dataroot=root)

        # single-port SRAM macros (history, hash table, decoder buffer)
        self.add_depfileset(Spram(), "rtl", fileset=fileset)

        # top module
        self.set_topmodule(name, fileset)

        # self-checking testbench (`lb sim`)
        self.add_file(f'testbench/test_{name}_smoke.v', 'testbench', dataroot=root)
        self.set_topmodule(f'test_{name}_smoke', 'testbench')

        # variants
        self.variants = {
            "WW": [16, 32, 64, 128],
            "WIN": [4096, 16384, 32768],
        }


if __name__ == "__main__":
    d = Lz77()
    d.write_fileset("lz77.f", fileset="rtl")
