from os.path import dirname, abspath
from siliconcompiler.design import DesignSchema


class Cavlc(DesignSchema):
    def __init__(self):

        name = 'cavlc'
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
        self.set_topmodule(name, fileset)


if __name__ == "__main__":
    d = Cavlc()
    d.write_fileset("cavlc.f", fileset="rtl")
