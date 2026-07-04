from os.path import dirname, abspath
from siliconcompiler import Design


class S1196(Design):
    def __init__(self):

        name = 's1196'
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

        # timing constraints (clock port is 'CK'; see sdc/<name>.sdc)
        self.add_file(f'sdc/{name}.sdc', 'sdc', dataroot=root)


if __name__ == "__main__":
    d = S1196()
    d.write_fileset("s1196.f", fileset="rtl")
