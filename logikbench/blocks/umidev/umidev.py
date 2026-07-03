from os.path import dirname, abspath
from siliconcompiler import Design
from umi.sumi import Endpoint
from umi.sumi import Decode, Pack, Unpack


class Umidev(Design):
    def __init__(self):

        # umi_endpoint from the umi pip package. The RTL is referenced from the
        # installed package (resolved at import, not vendored); its parameters
        # are overridden here: FULL endpoint, registered, narrow (64-bit) UMI.
        super().__init__('umidev')

        ep = Endpoint()
        with self.active_fileset('rtl'):
            self.set_topmodule('umi_endpoint')
            for item in ep.get_file(fileset='rtl'):
                self.add_file(item)
            for item in ep.get_idir(fileset='rtl'):
                self.add_idir(item)
            self.add_depfileset(Decode(), 'rtl')
            self.add_depfileset(Pack(), 'rtl')
            self.add_depfileset(Unpack(), 'rtl')
            self.set_param('TYPE', '"FULL"')
            self.set_param('REG', '1')
            self.set_param('DW', '64')
            self.set_param('AW', '64')
            self.set_param('CW', '32')


if __name__ == "__main__":
    d = Umidev()
    d.write_fileset(f"{d.name}.f", fileset="rtl")
