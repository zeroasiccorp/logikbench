from os.path import dirname, abspath
from siliconcompiler import Design


class Dds(Design):
    def __init__(self):

        name = 'dds'
        root = f'{name}_root'
        # leaf modules first, top last (single compilation unit)
        source = ['rtl/dds_phase_acc.v', 'rtl/dds_lut.v', 'rtl/dds.v']

        # create a Design object
        super().__init__(name)

        # set data home directory
        self.set_dataroot(root, dirname(abspath(__file__)))

        # rtl files
        fileset = 'rtl'
        for item in source:
            self.add_file(item, fileset, dataroot=root)

        # top module
        self.set_topmodule(name, fileset)

        # PW: phase accumulator width; AW: sine ROM address bits; OW: output
        # width. The quarter-wave ROM in dds_lut.v is generated for AW/OW below.
        self.set_param('PW', '24', fileset)
        self.set_param('AW', '10', fileset)
        self.set_param('OW', '12', fileset)

        # self-checking testbench (`lb sim`)
        self.add_file(f'testbench/test_{name}_smoke.v', 'testbench', dataroot=root)
        self.set_topmodule(f'test_{name}_smoke', 'testbench')


if __name__ == "__main__":
    d = Dds()
    d.write_fileset("dds.f", fileset="rtl")
