import os
from siliconcompiler.design import DesignSchema


class Muladd(DesignSchema):
    def __init__(self):

        name = 'ramsp'
        super().__init__(name)

        # rtl
        fileset = 'rtl'
        self.add_file(f'rtl/{name}.v', fileset)
        self.set_topmodule(name, fileset)
        self.set_param('DW', "16", fileset)
        self.set_param('AW', "6", fileset)

        # constraints
        fileset = 'constraint'
        self.add_file(f'constraint/{name}.sdc', fileset)
