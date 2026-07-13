from os.path import dirname, abspath
from siliconcompiler import Design


class Sha256(Design):
    def __init__(self):

        name = 'sha256'
        root = f'{name}_root'
        # leaf modules first, top last (single compilation unit)
        source = ['rtl/sha256_k_constants.v', 'rtl/sha256_w_mem.v',
                  'rtl/sha256_core.v', 'rtl/sha256.v']

        # create a Design object
        super().__init__(name)

        # set data home directory
        self.set_dataroot(root, dirname(abspath(__file__)))

        # rtl files
        fileset = 'rtl'
        for item in source:
            self.add_file(item, fileset, dataroot=root)

        # top module (full core + 32-bit register interface)
        self.set_topmodule(name, fileset)

        # self-checking testbench (`lb sim`)
        self.add_file(f'testbench/test_{name}_smoke.v', 'testbench', dataroot=root)
        self.set_topmodule(f'test_{name}_smoke', 'testbench')


if __name__ == "__main__":
    d = Sha256()
    d.write_fileset("sha256.f", fileset="rtl")
