from os.path import dirname, abspath
from siliconcompiler.design import DesignSchema

class Axicrossbar(DesignSchema):
    def __init__(self):

        name = 'axicrossbar'
        topmodule = 'axi_crossbar'
        root = f'{name}_root'
        source = ['rtl/arbiter.v',
                  'rtl/axi_crossbar_addr.v',
	          'rtl/axi_crossbar_rd.v',
                  'rtl/axi_crossbar.v',
                  'rtl/axi_crossbar_wr.v',
                  'rtl/axi_register_rd.v',
                  'rtl/axi_register_wr.v',
                  'rtl/priority_encoder.v']

        # create a Design object
        super().__init__(name)

        # set data home directory
        self.register_package(root, dirname(abspath(__file__)))

        # rtl files
        fileset = 'rtl'
        for item in source:
            self.add_file(item, fileset, package=root)

        # top module
        self.set_topmodule(topmodule, fileset)

if __name__ == "__main__":
   d = Axicrossbar()
   d.write_fileset(f"axicrossbar.f", fileset="rtl")
