from os.path import dirname, abspath
from siliconcompiler import Design


class BwaveLikeFloatSmall(Design):
    def __init__(self):

        name = 'bwave_like_float_small'
        root = f'{name}_root'
        source = ['rtl/bwave_like_float_small.v']

        # create a Design object
        super().__init__(name)

        # set data home directory
        self.set_dataroot(root, dirname(abspath(__file__)))

        # rtl files
        fileset = 'rtl'
        for item in source:
            self.add_file(item, fileset, dataroot=root)

        # top module (upstream module name, kept verbatim)
        self.set_topmodule('NPU', fileset)


if __name__ == "__main__":
    d = BwaveLikeFloatSmall()
    d.write_fileset("bwave_like_float_small.f", fileset="rtl")
