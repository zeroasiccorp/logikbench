from os.path import dirname, abspath
from siliconcompiler import Design


class KoiosDlaLikeSmall(Design):
    def __init__(self):

        name = 'koios_dla_like_small'
        root = f'{name}_root'
        source = ['rtl/dla_like.small.v']

        # create a Design object
        super().__init__(name)

        # set data home directory
        self.set_dataroot(root, dirname(abspath(__file__)))

        # rtl files
        fileset = 'rtl'
        for item in source:
            self.add_file(item, fileset, dataroot=root)

        # top module (upstream module name, differs from the koios_ design name)
        self.set_topmodule('DLA', fileset)


if __name__ == "__main__":
    d = KoiosDlaLikeSmall()
    d.write_fileset("koios_dla_like_small.f", fileset="rtl")
