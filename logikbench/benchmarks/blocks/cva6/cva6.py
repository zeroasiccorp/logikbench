from os.path import dirname, abspath
from siliconcompiler import Design


class Cva6(Design):
    def __init__(self):

        name = 'cva6'

        # create design object
        super().__init__(name)

        # local files
        self.set_dataroot("local", dirname(abspath(__file__)))

        with self.active_dataroot("local"):
            with self.active_fileset("rtl"):
                # CORE-V CVA6 (cv64a6_imafdc_sv39, write-through cache),
                # pickled with morty from openhwgroup/cva6 v5.3.0. See README.
                self.set_topmodule("cva6")
                self.add_file("rtl/cva6.sv")


if __name__ == "__main__":
    d = Cva6()
    d.write_fileset(f"{d.name}.f", fileset="rtl")
