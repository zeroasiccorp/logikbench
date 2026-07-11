from os.path import dirname, abspath
from siliconcompiler import Design


class KoiosConvLayer(Design):
    def __init__(self):

        name = 'koios_conv_layer'
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

        # top module (upstream module name, differs from the koios_ design name)
        self.set_topmodule('conv_layer', fileset)


if __name__ == "__main__":
    d = KoiosConvLayer()
    d.write_fileset("koios_conv_layer.f", fileset="rtl")
