from os.path import dirname, abspath
from siliconcompiler import Design


class Reedsolomon(Design):
    def __init__(self):

        name = 'reedsolomon'
        root = f'{name}_root'
        source = ['rtl/rs_gfmul.v',
                  'rtl/rs_gfinv.v',
                  'rtl/rs_syndrome.v',
                  'rtl/rs_kes.v',
                  'rtl/rs_enc.v',
                  'rtl/rs_dec.v',
                  'rtl/reedsolomon.v']

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


if __name__ == "__main__":
    d = Reedsolomon()
    d.write_fileset("reedsolomon.f", fileset="rtl")
