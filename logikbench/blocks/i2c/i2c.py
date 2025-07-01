from os.path import dirname, abspath
from siliconcompiler.design import DesignSchema


class I2c(DesignSchema):
    def __init__(self):

        name = 'i2c'
        root = f'{name}_root'
        source = ['rtl/la_dsync.v',
                  'rtl/i2c_byte_ctrl.v',
                  'rtl/i2c_bit_ctrl.v',
                  'rtl/i2c.v',]

        # create a Design object
        super().__init__(name)

        # set data home directory
        self.register_package(root, dirname(abspath(__file__)))

        # rtl files
        fileset = 'rtl'
        for item in source:
            self.add_file(item, fileset, package=root)

        # include files
        self.add_idir('rtl', fileset, package=root)

        # top module
        self.set_topmodule(name, fileset)

if __name__ == "__main__":
   d = I2c()
   d.write_fileset(f"i2c.f", fileset="rtl")
