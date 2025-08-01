from os.path import dirname, abspath
from siliconcompiler.design import DesignSchema


class Add(DesignSchema):
    def __init__(self):

        name = 'add'
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
    d = Add()
    d.write_fileset("add.f", fileset="rtl")
