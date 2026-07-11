from os.path import dirname, abspath
from siliconcompiler import Design


class Div(Design):
    def __init__(self):

        name = 'div'
        root = f'{name}_root'
        source = ['rtl/div.v']

        # create a Design object
        super().__init__(name)

        # set data home directory
        self.set_dataroot(root, dirname(abspath(__file__)))

        # rtl files
        fileset = 'rtl'
        for item in source:
            self.add_file(item, fileset, dataroot=root)

        # top module
        self.set_topmodule('div', fileset)


if __name__ == "__main__":
    d = Div()
    d.write_fileset("div.f", fileset="rtl")
