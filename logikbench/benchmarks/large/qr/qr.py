from os.path import dirname, abspath
from siliconcompiler import Design


class Qr(Design):
    def __init__(self):

        name = 'qr'
        root = f'{name}_root'
        # leaf modules first, top last (single compilation unit)
        source = ['rtl/qr_cordic.v', 'rtl/qr_boundary.v', 'rtl/qr_internal.v',
                  'rtl/qr_array.v', 'rtl/qr.v']

        # create a Design object
        super().__init__(name)

        # set data home directory
        self.set_dataroot(root, dirname(abspath(__file__)))

        # rtl files
        fileset = 'rtl'
        for item in source:
            self.add_file(item, fileset, dataroot=root)

        # top module (CORDIC-Givens systolic QR)
        self.set_topmodule(name, fileset)

        # matrix dimension (N x N) and signed I/O word width
        self.set_param('N', '16', fileset)
        self.set_param('DW', '16', fileset)

        # self-checking testbench (`lb sim`)
        self.add_file(f'testbench/test_{name}_smoke.v', 'testbench', dataroot=root)
        self.set_topmodule(f'test_{name}_smoke', 'testbench')

        # variants
        self.variants = {
            "DW": [8, 16, 32],
            "N": [2, 4, 8, 16, 32],
        }


if __name__ == "__main__":
    d = Qr()
    d.write_fileset("qr.f", fileset="rtl")
