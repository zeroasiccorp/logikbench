from os.path import dirname, abspath
from siliconcompiler import Design
from lambdalib.ramlib import Spram


class CoralNPU(Design):
    def __init__(self):

        name = 'coralnpu'

        # create design object
        super().__init__(name)

        # local files
        self.set_dataroot("local", dirname(abspath(__file__)))

        with self.active_dataroot("local"):
            with self.active_fileset("rtl"):
                self.set_topmodule("CoralNPUChiselSubsystem")
                self.add_define("SYNTHESIS")
                self.add_file("rtl/coralnpu.sv")
                self.add_file("rtl/lambda.v")
                self.add_depfileset(Spram(), "rtl")
        self.add_file("sdc/coralnpu.sdc", "sdc", dataroot="local")


if __name__ == "__main__":
    d = CoralNPU()
    d.write_fileset(f"{d.name}.f", fileset="rtl")
