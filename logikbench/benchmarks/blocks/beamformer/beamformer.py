from os.path import dirname, abspath
from siliconcompiler import Design
from lambdalib.ramlib import Dpram


class Beamformer(Design):
    def __init__(self):

        name = 'beamformer'
        root = f'{name}_root'
        # leaf modules first, top last (single compilation unit)
        source = ['rtl/beamformer_channel.v', 'rtl/beamformer_sum.v',
                  'rtl/beamformer.v']

        # create a Design object
        super().__init__(name)

        # set data home directory
        self.set_dataroot(root, dirname(abspath(__file__)))

        # rtl files
        fileset = 'rtl'
        for item in source:
            self.add_file(item, fileset, dataroot=root)

        # RAM-based per-channel delay lines: reuse the lambdalib dual-port RAM
        # (la_dpram) rather than a flop shift register
        self.add_depfileset(Dpram(), fileset=fileset)

        # top module
        self.set_topmodule(name, fileset)

        # N-channel delay-and-sum; scale via NCHAN, delay depth via DEPTH
        self.set_param('NCHAN', '8', fileset)
        self.set_param('DW', '12', fileset)
        self.set_param('WW', '12', fileset)
        self.set_param('DEPTH', '64', fileset)

        # self-checking testbench (`lb sim`)
        self.add_file(f'testbench/test_{name}_smoke.v', 'testbench', dataroot=root)
        self.set_topmodule(f'test_{name}_smoke', 'testbench')

        # variants
        self.variants = {
            "DW": [8, 16, 32, 64],
            "NCHAN": [2, 4, 8, 16, 32, 64],
        }


if __name__ == "__main__":
    d = Beamformer()
    d.write_fileset("beamformer.f", fileset="rtl")
