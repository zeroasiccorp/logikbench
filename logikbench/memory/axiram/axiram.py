from os.path import dirname, abspath
from siliconcompiler import Design


class Axiram(Design):
    def __init__(self):

        name = 'axiram'
        root = f'{name}_root'
        topmodule = 'axil_ram'
        source = [f'rtl/axil_ram.v']

        # create a Design object
        super().__init__(name)

        # set data home directory
        self.set_dataroot(root, dirname(abspath(__file__)))

        # rtl files
        fileset = 'rtl'
        for item in source:
            self.add_file(item, fileset, dataroot=root)

        # top module
        self.set_topmodule(topmodule, fileset)


if __name__ == "__main__":
    d = Axiram()
    d.write_fileset(f"{d.name()}.f", fileset="rtl")
