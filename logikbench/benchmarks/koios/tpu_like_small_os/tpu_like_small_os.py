from os.path import dirname, abspath
from siliconcompiler import Design


class TpuLikeSmallOs(Design):
    def __init__(self):

        name = 'tpu_like_small_os'
        root = f'{name}_root'
        source = ['rtl/tpu_like_small_os.v']

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
    d = TpuLikeSmallOs()
    d.write_fileset("tpu_like_small_os.f", fileset="rtl")
