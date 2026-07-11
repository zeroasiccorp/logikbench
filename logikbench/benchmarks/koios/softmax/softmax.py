from os.path import dirname, abspath
from siliconcompiler import Design


class Softmax(Design):
    def __init__(self):

        name = 'softmax'
        root = f'{name}_root'
        source = ['rtl/softmax.v']

        # create a Design object
        super().__init__(name)

        # set data home directory
        self.set_dataroot(root, dirname(abspath(__file__)))

        # rtl files
        fileset = 'rtl'
        for item in source:
            self.add_file(item, fileset, dataroot=root)

        # top module
        self.set_topmodule('softmax', fileset)


if __name__ == "__main__":
    d = Softmax()
    d.write_fileset("softmax.f", fileset="rtl")
