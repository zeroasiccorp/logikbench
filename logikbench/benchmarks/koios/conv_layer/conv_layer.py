from os.path import dirname, abspath
from siliconcompiler import Design


class ConvLayer(Design):
    def __init__(self):

        name = 'conv_layer'
        root = f'{name}_root'
        source = ['rtl/conv_layer.v']

        # create a Design object
        super().__init__(name)

        # set data home directory
        self.set_dataroot(root, dirname(abspath(__file__)))

        # rtl files
        fileset = 'rtl'
        for item in source:
            self.add_file(item, fileset, dataroot=root)

        # top module
        self.set_topmodule('conv_layer', fileset)


if __name__ == "__main__":
    d = ConvLayer()
    d.write_fileset("conv_layer.f", fileset="rtl")
