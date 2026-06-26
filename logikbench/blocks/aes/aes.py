from os.path import dirname, abspath
from siliconcompiler import Design


class Aes(Design):
    def __init__(self):

        name = 'aes'

        # create design object
        super().__init__(name)

        # local files
        self.set_dataroot("local", dirname(abspath(__file__)))

        with self.active_dataroot("local"):
            with self.active_fileset("rtl"):
                # OpenTitan AES (DOM-masked default config), pickled with morty
                # (generic prims, default top_pkg). See README for generation.
                self.set_topmodule("aes")
                self.add_file("rtl/aes.sv")


if __name__ == "__main__":
    d = Aes()
    d.write_fileset(f"{d.name}.f", fileset="rtl")
