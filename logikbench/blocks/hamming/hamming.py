from os.path import dirname, abspath
from siliconcompiler import Design


class Hamming(Design):
    def __init__(self):

        name = 'hamming'
        root = f'{name}_root'
        source = ['rtl/hamming_enc.v', 'rtl/hamming_dec.v', 'rtl/hamming.v']

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

        # timing constraints
        self.add_file(f'sdc/{name}.sdc', 'sdc', dataroot=root)


if __name__ == "__main__":
    d = Hamming()
    d.write_fileset("hamming.f", fileset="rtl")
