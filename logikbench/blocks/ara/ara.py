from os.path import dirname, abspath
from siliconcompiler import Design


class Ara(Design):
    def __init__(self):

        name = 'ara'

        # create design object
        super().__init__(name)

        # local files
        self.set_dataroot("local", dirname(abspath(__file__)))

        with self.active_dataroot("local"):
            with self.active_fileset("rtl"):
                # thin wrapper fixing a concrete config (NrLanes=2, VLEN=4096)
                # around Ara's vector unit; see README for provenance/versions
                self.set_topmodule("ara_wrap")
                self.add_file("rtl/ara.sv")
                # slang options (relax enum conversions for Ara's struct
                # literals); see rtl/ara.slang.f
                self.add_file("rtl/ara.slang.f", filetype="commandfile")


if __name__ == "__main__":
    d = Ara()
    d.write_fileset(f"{d.name}.f", fileset="rtl")
