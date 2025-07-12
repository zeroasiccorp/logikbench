from os.path import dirname, abspath
from siliconcompiler.design import DesignSchema


class Apbdev(DesignSchema):
    def __init__(self):

        name = 'apbdev'
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
   d = Apbdev()
   d.write_fileset(f"apbdev.f", fileset="rtl")