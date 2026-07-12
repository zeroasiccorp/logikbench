from os.path import dirname, abspath
from siliconcompiler import Design


class Umidev(Design):
    def __init__(self):

        # umi_endpoint from the UMI project, vendored locally (previously
        # referenced from the installed umi pip package). Configured as a FULL
        # endpoint, registered, narrow (64-bit) UMI.
        super().__init__('umidev')
        self.set_dataroot('umidev', dirname(abspath(__file__)))

        with self.active_fileset('rtl'):
            with self.active_dataroot('umidev'):
                self.set_topmodule('umi_endpoint')
                self.add_idir('rtl')
                self.add_file([
                    'rtl/umi_endpoint.v',
                    'rtl/umi_decode.v',
                    'rtl/umi_pack.v',
                    'rtl/umi_unpack.v'])
                self.set_param('TYPE', '"FULL"')
                self.set_param('REG', '1')
                self.set_param('DW', '64')
                self.set_param('AW', '64')
                self.set_param('CW', '32')


if __name__ == "__main__":
    d = Umidev()
    d.write_fileset(f"{d.name}.f", fileset="rtl")
