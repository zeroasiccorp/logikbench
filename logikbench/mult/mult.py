import os
from logicbenchy.design import Design

class Mult(Design):
    def __init__(self):
        self.name = "mult"
        super().__init__(self.name)
        root = os.path.dirname(__file__)
        self.source(os.path.join(root, 'rtl', f'{self.name}.v'))
        self.source(os.path.join(root, 'sdc', f'{self.name}.sdc'))
