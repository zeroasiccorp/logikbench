from os.path import dirname, abspath
from siliconcompiler.design import DesignSchema


class Multiplier(DesignSchema):
    def __init__(self):

        name = 'multiplier'
        root = f'{name}_root'
        source = [f'rtl/{name}.v']

        # create a Design object
        super().__init__(name)

        # set data home directory
        self.register_package(root, dirname(abspath(__file__)))

        # rtl files
        fileset = 'rtl'
        for item in source:
            self.add_file(item, fileset, package=root)

        # top module
        self.set_topmodule("top", fileset)


if __name__ == "__main__":
    d = Multiplier()
    d.write_fileset("multiplier.f", fileset="rtl")
