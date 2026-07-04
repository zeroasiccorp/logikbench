from os.path import dirname, abspath
from siliconcompiler import Design


class I2c(Design):
    def __init__(self):

        name = 'i2c'

        # create design object
        super().__init__(name)

        # local files
        self.set_dataroot("local", dirname(abspath(__file__)))

        with self.active_dataroot("local"):
            with self.active_fileset("rtl"):
                # OpenTitan I2C, pickled with morty (generic prims, default
                # top_pkg). See README for generation details.
                self.set_topmodule("i2c")
                self.add_file("rtl/i2c.sv")


if __name__ == "__main__":
    d = I2c()
    d.write_fileset(f"{d.name}.f", fileset="rtl")
