import os
from siliconcompiler.design import DesignSchema

class Add(DesignSchema):
    def __init__(self):

        name = 'add'
        super().__init__(name)

        # rtl
        fileset = 'rtl'
        self.add_file('rtl/{name}.v', fileset)
        self.set_topmodule(name, fileset)
        self.set_param('N', "64", fileset)

        # constraints
        fileset = 'constraint'
        self.add_file('constraint/{name}.sdc', fileset)
