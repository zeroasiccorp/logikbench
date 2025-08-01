from os.path import dirname, abspath
from siliconcompiler.design import DesignSchema


class Ethmac(DesignSchema):
    def __init__(self):

        name = 'ethmac'
        root = f'{name}_root'
        source = [f'rtl/{name}.v']

        # create a Design object
        super().__init__(name)

        # set data home directory
        self.set_dataroot(root, dirname(abspath(__file__)))

        # rtl files
        fileset = 'rtl'
        for item in ('rtl/ethmac.v',
                     'rtl/eth_mac_1g.v',
                     'rtl/axis_gmii_rx.v',
                     'rtl/axis_gmii_tx.v',
                     'rtl/eth_lfsr.v'):
            self.add_file(item, fileset, dataroot=root)

        # top module
        self.set_topmodule(name, fileset)

if __name__ == "__main__":
   d = Ethmac()
   d.write_fileset(f"ethmac.f", fileset="rtl")
