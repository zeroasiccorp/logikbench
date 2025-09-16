from os.path import dirname, abspath
from siliconcompiler import Design


class Max(Design):
    def __init__(self):

        name = 'max'
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
        self.set_topmodule("top", fileset)


if __name__ == "__main__":
    d = Max()
    d.write_fileset("max.f", fileset="rtl")
