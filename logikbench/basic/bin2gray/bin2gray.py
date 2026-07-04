from os.path import dirname, abspath
from siliconcompiler import Design


class Bin2gray(Design):
    def __init__(self):

        name = 'bin2gray'
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


if __name__ == "__main__":
    d = Bin2gray()
    d.write_fileset("bin2gray.f", fileset="rtl")
