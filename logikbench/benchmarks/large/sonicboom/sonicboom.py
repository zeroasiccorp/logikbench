from os.path import dirname, abspath
from siliconcompiler import Design
from lambdalib.ramlib import Spram, Dpram


class Sonicboom(Design):
    def __init__(self):

        name = 'sonicboom'
        root = f'{name}_root'
        # rtl/sonicboom.sv         : flattened DigitalTop (SonicBOOM/MegaBoomV3)
        # rtl/sonicboom_srams.v    : lambdalib-backed wrappers for the SRAM
        #                            blackboxes (see generation/make_srams.py)
        source = [f'rtl/{name}.sv', f'rtl/{name}_srams.v']
        # SRAM primitives instantiated by the wrappers: single-port (la_spram)
        # and one-read/one-write (la_dpram).
        deps = [Spram(), Dpram()]

        # create a Design object
        super().__init__(name)

        # set data home directory
        self.set_dataroot(root, dirname(abspath(__file__)))

        # rtl files
        fileset = 'rtl'
        for item in source:
            self.add_file(item, fileset, dataroot=root)

        # lambdalib cells instantiated by the SRAM wrappers
        for dep in deps:
            self.add_depfileset(dep, fileset=fileset)

        # top module (the flattened digital top, prefix-namespaced by morty)
        self.set_topmodule(f'{name}_DigitalTop', fileset)


if __name__ == "__main__":
    d = Sonicboom()
    d.write_fileset("sonicboom.f", fileset="rtl")
