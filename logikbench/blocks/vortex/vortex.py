from os.path import dirname, abspath
from siliconcompiler import Design


class Vortex(Design):
    def __init__(self):

        name = 'vortex'

        # create design object
        super().__init__(name)

        # local files
        self.set_dataroot("local", dirname(abspath(__file__)))

        with self.active_dataroot("local"):
            with self.active_fileset("rtl"):
                # single Vortex GPU core (VX_core) at the default config
                # (RV32IMF, 4 warps, 4 threads), flattened with sv2v from the
                # SystemVerilog sources. Top is a thin plain-port wrapper around
                # VX_core's interface ports. See README for generation details.
                self.set_topmodule("vortex_core_wrap")
                self.add_file("rtl/vortex.v")
        self.add_file("sdc/vortex.sdc", "sdc", dataroot="local")


if __name__ == "__main__":
    d = Vortex()
    d.write_fileset(f"{d.name}.f", fileset="rtl")
