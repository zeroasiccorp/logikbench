from os.path import dirname, abspath
from siliconcompiler import Design


class KoiosGemmLayer(Design):
    def __init__(self):

        name = 'koios_gemm_layer'
        root = f'{name}_root'
        source = ['rtl/gemm_layer.v']

        # create a Design object
        super().__init__(name)

        # set data home directory
        self.set_dataroot(root, dirname(abspath(__file__)))

        # rtl files
        fileset = 'rtl'
        for item in source:
            self.add_file(item, fileset, dataroot=root)

        # top module (upstream module name, differs from the koios_ design name)
        self.set_topmodule('gemm_layer', fileset)


if __name__ == "__main__":
    d = KoiosGemmLayer()
    d.write_fileset("koios_gemm_layer.f", fileset="rtl")
