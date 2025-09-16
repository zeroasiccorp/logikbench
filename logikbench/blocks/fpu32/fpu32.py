from os.path import dirname, abspath
from siliconcompiler import Design


class Fpu32(Design):
    def __init__(self):

        name = 'fpu32'
        topmodule = 'fpu'
        root = f'{name}_root'
        source = ['rtl/fpu.v',
                  'rtl/post_norm.v',
	          'rtl/except.v',
                  'rtl/pre_norm_fmul.v',
                  'rtl/pre_norm.v',
                  'rtl/primitives.v']

        # create a Design object
        super().__init__(name)

        # set data home directory
        self.set_dataroot(root, dirname(abspath(__file__)))

        # rtl files
        fileset = 'rtl'
        for item in source:
            self.add_file(item, fileset, dataroot=root)

        # top module
        self.set_topmodule(topmodule, fileset)

if __name__ == "__main__":
   d = Fpu32()
   d.write_fileset(f"{d.name()}.f", fileset="rtl")
