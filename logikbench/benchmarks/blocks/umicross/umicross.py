from os.path import dirname, abspath
from siliconcompiler import Design
from logikbench.benchmarks.blocks.variants import BLOCKS_N
from lambdalib.veclib import Vmux


class Umicross(Design):
    def __init__(self):

        # umi_crossbar from the UMI project, vendored locally (previously
        # referenced from the installed umi pip package). Configured as an
        # 8x8 crossbar, narrow (64-bit) UMI. Vmux (lambdalib) stays a dependency.
        super().__init__('umicross')
        self.set_dataroot('umicross', dirname(abspath(__file__)))

        with self.active_fileset('rtl'):
            with self.active_dataroot('umicross'):
                self.set_topmodule('umi_crossbar')
                self.add_idir('rtl')
                self.add_file([
                    'rtl/umi_crossbar.v',
                    'rtl/umi_arbiter.v'])
                self.add_depfileset(Vmux(), 'rtl')
                self.set_param('N', '8')
                self.set_param('DW', '64')
                self.set_param('AW', '64')
                self.set_param('CW', '32')

        # variants
        self.variants = {
            "N": BLOCKS_N,
        }


if __name__ == "__main__":
    d = Umicross()
    d.write_fileset(f"{d.name}.f", fileset="rtl")
