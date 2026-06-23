from siliconcompiler import Design
from umi.sumi import Crossbar
from umi.sumi import Arbiter
from lambdalib.veclib import Vmux


class Umicross(Design):
    def __init__(self):

        # umi_crossbar from the umi pip package. The RTL is referenced from the
        # installed package (resolved at import, not vendored); its parameters
        # are overridden here: 8x8 crossbar, narrow (64-bit) UMI.
        super().__init__('umicross')

        xbar = Crossbar()
        with self.active_fileset('rtl'):
            self.set_topmodule('umi_crossbar')
            for item in xbar.get_file(fileset='rtl'):
                self.add_file(item)
            for item in xbar.get_idir(fileset='rtl'):
                self.add_idir(item)
            self.add_depfileset(Vmux(), 'rtl')
            self.add_depfileset(Arbiter(), 'rtl')
            self.set_param('N', '8')
            self.set_param('DW', '64')
            self.set_param('AW', '64')
            self.set_param('CW', '32')


if __name__ == "__main__":
    d = Umicross()
    d.write_fileset(f"{d.name}.f", fileset="rtl")
