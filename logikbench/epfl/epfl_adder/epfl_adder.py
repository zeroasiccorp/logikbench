from os.path import dirname, abspath
from siliconcompiler import Design


class EPFLAdder(Design):
    def __init__(self):

        name = 'epfl_adder'
        root = f'{name}_root'
        source = [f'rtl/{name}.v']

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

        # timing constraints
        self.add_file(f'sdc/{name}.sdc', 'sdc', dataroot=root)


if __name__ == "__main__":
    d = EPFLAdder()
    d.write_fileset("epfl_adder.f", fileset="rtl")
