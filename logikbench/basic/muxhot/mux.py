import os
from siliconcompiler.design import DesignSchema

class Mux(DesignSchema):
    def __init__(self):

        name = 'mux'
        super().__init__(name)

        # rtl
        fileset = 'rtl'
        self.add_file('rtl/{name}.v', fileset)
        self.set_topmodule(name, fileset)
        self.set_param('N', "8", fileset) # vector width
        self.set_param('M', "1", fileset) # number of inputs

        # constraints
        fileset = 'constraint'
        self.add_file('constraint/{name}.sdc', fileset)
