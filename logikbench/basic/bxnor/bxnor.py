from os.path import dirname, abspath
from siliconcompiler import Design


class Bxnor(Design):
    def __init__(self):
        name = 'bxnor'
        root = dirname(abspath(__file__))
        super().__init__(name)
        self.add_file(f"{root}/rtl/{name}.v", 'rtl')
        self.set_topmodule(name, 'rtl')
        self.add_file(f"{root}/sdc/{name}.sdc", 'sdc')


if __name__ == "__main__":
    d = Bxnor()
    d.write_fileset("bxnor.f", fileset="rtl")
