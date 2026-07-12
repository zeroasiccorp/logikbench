from os.path import dirname, abspath, join, relpath
from glob import glob
from siliconcompiler import Design


class NvdlaFull(Design):
    def __init__(self):

        name = 'nvdlafull'
        topmodule = 'NV_nvdla'
        root = 'nvdlafull_root'
        here = dirname(abspath(__file__))

        # Full-precision NVDLA v1.0 (nvdlav1 branch). Unlike the nv_small
        # config, this release ships pre-resolved RTL with the configuration
        # baked in, so there is no generated project/config header to parse
        # first. The RTL, behavioral cell library (vlibs, incl. the HLS FP
        # units used instead of DesignWare) and synthesizable RAM models are
        # taken verbatim in sorted order. See README.md for provenance.
        # rams/synth holds the nv_ram_* wrappers; rams/model holds the
        # behavioral RAM primitives (RAMDP_*/RAMPDP_*) those wrappers
        # instantiate -- both layers are needed for a self-contained design.
        sources = []
        for pattern in ('rtl/**/*.v', 'vlibs/*.v',
                        'rams/synth/*.v', 'rams/model/*.v'):
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
                # hierarchical defparams (see README). DESIGNWARE_NOEXIST
                # selects the behavioral vlibs cells (NV_DW02_tree, ...) over
                # the Synopsys DesignWare cells we do not have.
                self.add_define('SYNTHESIS')
                self.add_define('VERILINT')
                self.add_define('NO_PLI_OR_EMU')
                self.add_define('DESIGNWARE_NOEXIST')
                self.add_idir('include')
                for item in sources:
                    self.add_file(item)


if __name__ == "__main__":
    d = NvdlaFull()
    d.write_fileset("nvdlafull.f", fileset="rtl")
