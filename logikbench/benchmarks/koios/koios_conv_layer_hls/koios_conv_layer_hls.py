from os.path import dirname, abspath
from siliconcompiler import Design


class KoiosConvLayerHls(Design):
    def __init__(self):

        name = 'koios_conv_layer_hls'
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

        # top module (upstream module name, differs from the koios_ design name)
        self.set_topmodule('top', fileset)


if __name__ == "__main__":
    d = KoiosConvLayerHls()
    d.write_fileset("koios_conv_layer_hls.f", fileset="rtl")
