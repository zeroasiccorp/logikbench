from os.path import dirname, abspath
from siliconcompiler import Design


class ReductionLayer(Design):
    def __init__(self):

        name = 'reduction_layer'
        root = f'{name}_root'
        source = ['rtl/reduction_layer.v']

        # create a Design object
        super().__init__(name)

        # set data home directory
        self.set_dataroot(root, dirname(abspath(__file__)))

        # rtl files
        fileset = 'rtl'
        for item in source:
            self.add_file(item, fileset, dataroot=root)

        # top module
        self.set_topmodule('reduction_layer', fileset)


if __name__ == "__main__":
    d = ReductionLayer()
    d.write_fileset("reduction_layer.f", fileset="rtl")
