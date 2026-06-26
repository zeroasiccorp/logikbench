from os.path import dirname, abspath
from siliconcompiler import Design
from lambdalib.ramlib import Spram


class BlackParrot(Design):
    def __init__(self):

        name = 'blackparrot'

        # create design object
        super().__init__(name)

        # local files
        self.set_dataroot("local", dirname(abspath(__file__)))

        with self.active_dataroot("local"):
            with self.active_fileset("rtl"):
                self.set_topmodule("black_parrot")
                self.add_define("SYNTHESIS")
                # pickled (preprocessed single-file) black-parrot core, plus a
                # lambda shim mapping its hard memories onto lambdalib Spram
                self.add_file("rtl/pickled.v")
                self.add_file("rtl/lambda.v")
                self.add_depfileset(Spram(), "rtl")


if __name__ == "__main__":
    d = BlackParrot()
    d.write_fileset(f"{d.name}.f", fileset="rtl")
