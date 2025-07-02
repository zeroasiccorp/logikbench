import numpy as np
from os.path import dirname, abspath
from siliconcompiler.design import DesignSchema


class Fft(DesignSchema):
    def __init__(self):

        name = 'fft'
        root = f'{name}_root'
        source = [f'rtl/{name}.v']

        # create a Design object
        super().__init__(name)

        # set data home directory
        self.register_package(root, dirname(abspath(__file__)))

        # rtl files
        fileset = 'rtl'
        for item in source:
            self.add_file(item, fileset, package=root)

        # top module
        self.set_topmodule(name, fileset)

    def sin_table(self, width=16, size=256):
        '''
        Generates sin table with:
        1 sign bit, N-1 fractional bits

        '''
        maxval = (2**(width-1)-1)

        for i in range(size):
            val = int(np.sin(2 * np.pi * i / size) * maxval)
            if val < 0:
                print(f"sine_lut[{i}] = -16'sd{abs(val)};")
            else:
                print(f"sine_lut[{i}] = 16'sd{val};")

if __name__ == "__main__":
   d = Fft()
   d.write_fileset(f"fft.f", fileset="rtl")
   d.sin_table()
