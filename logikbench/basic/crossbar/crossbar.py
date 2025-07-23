from os.path import dirname, abspath
from siliconcompiler.design import DesignSchema


class Crossbar(DesignSchema):
    def __init__(self):

        name = 'crossbar'
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
    d = Crossbar()
    d.write_fileset("crossbar.f", fileset="rtl")
