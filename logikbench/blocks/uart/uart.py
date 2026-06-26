from os.path import dirname, abspath
from siliconcompiler import Design


class Uart(Design):
    def __init__(self):

        name = 'uart'

        # create design object
        super().__init__(name)

        # local files
        self.set_dataroot("local", dirname(abspath(__file__)))

        with self.active_dataroot("local"):
            with self.active_fileset("rtl"):
                # OpenTitan UART, pickled with morty (generic prims, default
                # top_pkg). See README for generation details.
                self.set_topmodule("uart")
                self.add_file("rtl/uart.sv")


if __name__ == "__main__":
    d = Uart()
    d.write_fileset(f"{d.name}.f", fileset="rtl")
