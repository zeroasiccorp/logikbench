from os.path import dirname, abspath
from siliconcompiler import Design


class Dnnweaver(Design):
    def __init__(self):

        name = 'dnnweaver'
        root = f'{name}_root'
        source = ['rtl/dnnweaver.v']

        # create a Design object
        super().__init__(name)

        # set data home directory
        self.set_dataroot(root, dirname(abspath(__file__)))

        # rtl files
        fileset = 'rtl'
        for item in source:
            self.add_file(item, fileset, dataroot=root)

        # top module (upstream module name, kept verbatim)
        self.set_topmodule('cl_wrapper', fileset)


if __name__ == "__main__":
    d = Dnnweaver()
    d.write_fileset("dnnweaver.f", fileset="rtl")
