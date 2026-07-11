from os.path import dirname, abspath
from siliconcompiler import Design


class AttentionLayer(Design):
    def __init__(self):

        name = 'attention_layer'
        root = f'{name}_root'
        source = ['rtl/attention_layer.v']

        # create a Design object
        super().__init__(name)

        # set data home directory
        self.set_dataroot(root, dirname(abspath(__file__)))

        # rtl files
        fileset = 'rtl'
        for item in source:
            self.add_file(item, fileset, dataroot=root)

        # top module
        self.set_topmodule('attention_layer', fileset)


if __name__ == "__main__":
    d = AttentionLayer()
    d.write_fileset("attention_layer.f", fileset="rtl")
