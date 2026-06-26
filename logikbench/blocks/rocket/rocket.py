from os.path import dirname, abspath
from siliconcompiler import Design
from lambdalib.auxlib import Drsync, Dsync
from lambdalib.ramlib import Spram


class Rocket(Design):
    def __init__(self):

        name = 'rocket'
        root = f'{name}_root'
        source = [f'rtl/{name}.v', 'rtl/riscv_bootrom.v']
        deps = [Drsync(), Dsync(), Spram()]

        # create a Design object
        super().__init__(name)

        # set data home directory
        self.set_dataroot(root, dirname(abspath(__file__)))

        # rtl files
        fileset = 'rtl'
        for item in source:
            self.add_file(item, fileset, dataroot=root)

        # lambdalib cells instantiated by the pickled core
        for dep in deps:
            self.add_depfileset(dep, fileset=fileset)

        # top module
        self.set_topmodule(name, fileset)


if __name__ == "__main__":
    d = Rocket()
    d.write_fileset("rocket.f", fileset="rtl")
