from os.path import dirname, abspath
from siliconcompiler import Design
from lambdalib.padring.la_padring.la_padring import Padring as LaPadring


class Padring(Design):
    def __init__(self):

        # Minimal, technology-independent GPIO padring. Wraps lambdalib's
        # la_padring, configured as a square, uniform ring of bidirectional
        # GPIO cells (plus minimal supply cells) on all four sides. The
        # per-side cellmap is a static header in include/padring.vh.
        super().__init__('padring')
        self.set_dataroot('padring', dirname(abspath(__file__)))

        with self.active_fileset('rtl'):
            with self.active_dataroot('padring'):
                self.set_topmodule('padring')
                self.add_idir('include')
                self.add_idir('rtl')
                self.add_file('rtl/padring.v')
            # la_padring (+ la_padside + iolib) and its la_padring.vh idir
            self.add_depfileset(LaPadring(), 'rtl')

        with self.active_fileset('testbench'):
            with self.active_dataroot('padring'):
                self.set_topmodule('test_padring_smoke')
                self.add_file('testbench/test_padring_smoke.v')


if __name__ == "__main__":
    d = Padring()
    d.write_fileset(f"{d.name}.f", fileset="rtl")
