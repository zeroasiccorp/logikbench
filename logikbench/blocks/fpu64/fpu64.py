from os.path import dirname, abspath
from siliconcompiler.design import DesignSchema


class Fpu32(DesignSchema):
    def __init__(self):

        name = 'fpu64'
        topmodule = 'ct_vfdsu_double'
        root = f'{name}_root'
        source = ['rtl/ct_vfdsu_ctrl.v',
                  'rtl/ct_vfdsu_pack.v',
                  'rtl/ct_vfdsu_scalar_dp.v',
		  'rtl/ct_vfdsu_srt_radix16_with_sqrt.v',
                  'rtl/gated_clk_cell.v',
                  'rtl/ct_vfdsu_double.v',
                  'rtl/ct_vfdsu_prepare.v',
                  'rtl/ct_vfdsu_srt_radix16_bound_table.v',
                  'rtl/ct_vfdsu_srt.v',
                  'rtl/ct_vfdsu_ff1.v',
                  'rtl/ct_vfdsu_round.v',
                  'rtl/ct_vfdsu_srt_radix16_only_div.v',
                  'rtl/ct_vfdsu_top.v']

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
   d = Fpu32()
   d.write_fileset(f"{d.name()}.f", fileset="rtl")
