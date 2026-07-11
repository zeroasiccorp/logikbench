from os.path import dirname, abspath
from siliconcompiler import Design


class ClstmLikeMedium(Design):
    def __init__(self):

        name = 'clstm_like_medium'
        root = f'{name}_root'
        source = ['rtl/clstm_like_medium.v']

        # create a Design object
        super().__init__(name)

        # set data home directory
        self.set_dataroot(root, dirname(abspath(__file__)))

        # rtl files
        fileset = 'rtl'
        for item in source:
            self.add_file(item, fileset, dataroot=root)

        # top module (upstream module name, kept verbatim)
        self.set_topmodule('C_LSTM_datapath', fileset)


if __name__ == "__main__":
    d = ClstmLikeMedium()
    d.write_fileset("clstm_like_medium.f", fileset="rtl")
