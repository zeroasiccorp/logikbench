from os.path import dirname, abspath
from siliconcompiler import Design


class KoiosClstmLikeSmall(Design):
    def __init__(self):

        name = 'koios_clstm_like_small'
        root = f'{name}_root'
        source = ['rtl/clstm_like.small.v']

        # create a Design object
        super().__init__(name)

        # set data home directory
        self.set_dataroot(root, dirname(abspath(__file__)))

        # rtl files
        fileset = 'rtl'
        for item in source:
            self.add_file(item, fileset, dataroot=root)

        # top module (upstream module name, differs from the koios_ design name)
        self.set_topmodule('C_LSTM_datapath', fileset)


if __name__ == "__main__":
    d = KoiosClstmLikeSmall()
    d.write_fileset("koios_clstm_like_small.f", fileset="rtl")
