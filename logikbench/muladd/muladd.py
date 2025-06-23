import os
from siliconcompiler.design import DesignSchema


class Muladd(DesignSchema):
    def __init__(self):

        name = 'muladd'
        super().__init__(name)

        # rtl
        fileset = 'rtl'
        self.add_file('rtl/{name}.v', fileset)
        self.set_topmodule(name, fileset)
        self.set_param('N', "16", fileset)
        self.set_param('M', "48", fileset)

        # constraints
        fileset = 'constraint'
        self.add_file('constraint/{name}.sdc', fileset)
