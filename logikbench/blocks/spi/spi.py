from os.path import dirname, abspath
from siliconcompiler import Design


class Spi(Design):
    def __init__(self):

        name = 'spi'

        # create design object
        super().__init__(name)

        # local files
        self.set_dataroot("local", dirname(abspath(__file__)))

        with self.active_dataroot("local"):
            with self.active_fileset("rtl"):
                # OpenTitan SPI host, pickled with morty (generic prims,
                # default top_pkg). See README for generation details.
                self.set_topmodule("spi_host")
                self.add_file("rtl/spi.sv")


if __name__ == "__main__":
    d = Spi()
    d.write_fileset(f"{d.name}.f", fileset="rtl")
