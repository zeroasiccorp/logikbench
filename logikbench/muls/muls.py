import os
from siliconcompiler.design import DesignSchema


class Muls(DesignSchema):
    def __init__(self):

        name = 'muls'
        super().__init__(name)

        # rtl
        fileset = 'rtl'
        self.add_file(f'rtl/{name}.v', fileset)
        self.set_topmodule(name, fileset)
        self.set_param('N', "16", fileset)
        self.set_param('M', "32", fileset)

        # constraints
        fileset = 'constraint'
        self.add_file(f'constraint/{name}.sdc', fileset)
