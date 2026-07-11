from os.path import dirname, abspath
from siliconcompiler import Design


class DlaLikeMedium(Design):
    def __init__(self):

        name = 'dla_like_medium'
        root = f'{name}_root'
        source = ['rtl/dla_like_medium.v']

        # create a Design object
        super().__init__(name)

        # set data home directory
        self.set_dataroot(root, dirname(abspath(__file__)))

        # rtl files
        fileset = 'rtl'
        for item in source:
            self.add_file(item, fileset, dataroot=root)

        # top module (upstream module name, kept verbatim)
        self.set_topmodule('DLA', fileset)


if __name__ == "__main__":
    d = DlaLikeMedium()
    d.write_fileset("dla_like_medium.f", fileset="rtl")
