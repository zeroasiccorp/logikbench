from os.path import dirname, abspath
from siliconcompiler import Design


class Lstm(Design):
    def __init__(self):

        name = 'lstm'
        root = f'{name}_root'
        source = ['rtl/lstm.v']

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
    d = Lstm()
    d.write_fileset("lstm.f", fileset="rtl")
