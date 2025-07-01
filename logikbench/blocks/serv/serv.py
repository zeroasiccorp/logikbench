from os.path import dirname, abspath
from siliconcompiler.design import DesignSchema


class Serv(DesignSchema):
    def __init__(self):

        name = 'serv'
        topmodule = 'serv_top'
        root = f'{name}_root'
        source = ['rtl/serv_aligner.v',
                  'rtl/serv_alu.v',
                  'rtl/serv_bufreg2.v',
                  'rtl/serv_bufreg.v',
                  'rtl/serv_compdec.v',
                  'rtl/serv_csr.v',
                  'rtl/serv_ctrl.v',
                  'rtl/serv_debug.v',
                  'rtl/serv_decode.v',
                  'rtl/serv_immdec.v',
                  'rtl/serv_mem_if.v',
                  'rtl/serv_rf_if.v',
                  'rtl/serv_rf_ram_if.v',
                  'rtl/serv_rf_ram.v',
                  'rtl/serv_rf_top.v',
                  'rtl/serv_state.v',
                  'rtl/serv_synth_wrapper.v',
                  'rtl/serv_top.v']

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
   d = Serv()
   d.write_fileset(f"serv.f", fileset="rtl")
