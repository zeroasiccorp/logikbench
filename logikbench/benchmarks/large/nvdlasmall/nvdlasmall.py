from os.path import dirname, abspath, join, relpath
from glob import glob
from siliconcompiler import Design


class NvdlaSmall(Design):
    def __init__(self):

        name = 'nvdlasmall'
        topmodule = 'NV_nvdla'
        root = 'nvdlasmall_root'
        here = dirname(abspath(__file__))

        # Config defines must be parsed first so the macros propagate to the
        # rest of the (single compilation unit) sources. The remaining RTL,
        # cell library (vlibs) and FPGA RAM models follow in sorted order.
        # See README.md for how this nv_small tree was generated.
        sources = ['include/nvdla_config.vh']
        for pattern in ('rtl/**/*.v', 'vlibs/*.v', 'rams/fpga/small_rams/*.v'):
            for path in sorted(glob(join(here, pattern), recursive=True)):
                sources.append(relpath(path, here))

        # create a Design object
        super().__init__(name)
        self.set_dataroot(root, here)

        with self.active_dataroot(root):
            with self.active_fileset('rtl'):
                self.set_topmodule(topmodule)
                # SYNTHESIS: drop sim-only code; VERILINT / NO_PLI_OR_EMU:
                # NVDLA lint/synth guards that exclude assertions and PLI/emu
                # hierarchical defparams (see README)
                self.add_define('SYNTHESIS')
                self.add_define('VERILINT')
                self.add_define('NO_PLI_OR_EMU')
                self.add_idir('include')
                for item in sources:
                    self.add_file(item)


if __name__ == "__main__":
    d = NvdlaSmall()
    d.write_fileset("nvdlasmall.f", fileset="rtl")
