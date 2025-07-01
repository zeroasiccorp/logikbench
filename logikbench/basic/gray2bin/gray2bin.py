from os.path import dirname, abspath
from siliconcompiler.design import DesignSchema


class Gray2bin(DesignSchema):
    def __init__(self):

        name = 'gray2bin'
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
   d = Gray2bin()
   d.write_fileset(f"gray2bin.f", fileset="rtl")