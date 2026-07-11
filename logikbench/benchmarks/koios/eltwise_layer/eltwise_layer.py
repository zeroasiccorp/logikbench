from os.path import dirname, abspath
from siliconcompiler import Design


class EltwiseLayer(Design):
    def __init__(self):

        name = 'eltwise_layer'
        root = f'{name}_root'
        source = ['rtl/eltwise_layer.v']

        # create a Design object
        super().__init__(name)

        # set data home directory
        self.set_dataroot(root, dirname(abspath(__file__)))

        # rtl files
        fileset = 'rtl'
        for item in source:
            self.add_file(item, fileset, dataroot=root)

        # top module
        self.set_topmodule('eltwise_layer', fileset)


if __name__ == "__main__":
    d = EltwiseLayer()
    d.write_fileset("eltwise_layer.f", fileset="rtl")
