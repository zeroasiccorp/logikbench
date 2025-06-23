import os
from siliconcompiler.design import DesignSchema


class Mult(DesignSchema):
    def __init__(self):

        name = 'mult'
        super().__init__(name)

        # rtl
        fileset = 'rtl'
        self.add_file('rtl/{name}.v', fileset)
        self.set_topmodule(name, fileset)
        self.set_param('N', "16", fileset)
        self.set_param('M', "32", fileset)

        # constraints
        fileset = 'constraint'
        self.add_file('constraint/{name}.sdc', fileset)
