from os.path import dirname, abspath
from siliconcompiler import Design


class Simdmul(Design):
    def __init__(self):

        name = 'simdmul'
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

        # variants: SIMD packed multiply. DW x N up to 512 bits emulates
        # AVX-512 (32-bit elements x 16 lanes); DW in {8,16,32} are the real
        # SIMD element widths.
        self.variants = {
            "DW": [8, 16, 32],
            "N": [2, 4, 8, 16],
        }


if __name__ == "__main__":
    d = Simdmul()
    d.write_fileset("simdmul.f", fileset="rtl")
