from os.path import dirname, abspath
from siliconcompiler import Design


class Chiplink(Design):
    def __init__(self):

        name = 'chiplink'
        root = f'{name}_root'
        # leaf modules first, top last (single compilation unit)
        source = ['rtl/chiplink_cdc_fifo.v', 'rtl/chiplink_train.v',
                  'rtl/chiplink_tx.v', 'rtl/chiplink_rx.v', 'rtl/chiplink.v']

        # create a Design object
        super().__init__(name)

        # set data home directory
        self.set_dataroot(root, dirname(abspath(__file__)))

        # rtl files
        fileset = 'rtl'
        for item in source:
            self.add_file(item, fileset, dataroot=root)

        # top module (self-contained TX + skew + RX)
        self.set_topmodule(name, fileset)

        # link configuration: NLANES parallel wires, DW-bit word
        # (SER = DW/NLANES bits per lane per frame). DW must be a multiple of
        # NLANES with SER >= 2. Params forwarded to the mapper by the flow.
        self.set_param('NLANES', '8', fileset)
        self.set_param('DW', '32', fileset)

        # self-checking testbench (`lb sim`)
        self.add_file(f'testbench/test_{name}_smoke.v', 'testbench', dataroot=root)
        self.set_topmodule(f'test_{name}_smoke', 'testbench')


if __name__ == "__main__":
    d = Chiplink()
    d.write_fileset("chiplink.f", fileset="rtl")
