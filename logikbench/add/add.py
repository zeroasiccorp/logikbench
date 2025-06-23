import os
from logicbenchy.design import Design

class Add(Design):

    def __init__(self):
        self.name = "add"
        super().__init__(self.name)
        root = os.path.dirname(__file__)
        self.source(os.path.join(root, 'rtl', f'{self.name}.v'))
        self.source(os.path.join(root, 'sdc', f'{self.name}.sdc'))

    def model(self, a, b):
        pass

if __name__ == "__main__":
    Add()
