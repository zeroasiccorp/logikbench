from os.path import dirname, abspath
from siliconcompiler import Design


class ConvLayerHls(Design):
    def __init__(self):

        name = 'conv_layer_hls'
        root = f'{name}_root'
        source = ['rtl/conv_layer_hls.v']

        # create a Design object
        super().__init__(name)

        # set data home directory
        self.set_dataroot(root, dirname(abspath(__file__)))

        # rtl files
        fileset = 'rtl'
        for item in source:
            self.add_file(item, fileset, dataroot=root)

        # top module (upstream module name, kept verbatim)
        self.set_topmodule('top', fileset)


if __name__ == "__main__":
    d = ConvLayerHls()
    d.write_fileset("conv_layer_hls.f", fileset="rtl")
