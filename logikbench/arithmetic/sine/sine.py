from os.path import dirname, abspath
from siliconcompiler import Design
import math

def sinetable(N):

    # create table
    AMP = N/2-1 # amplitude
    OFFSET = N/2 # shift to make all values positive
    values = []
    for i in range(N):
        angle = 2 * math.pi * i / N
        val = int(round(AMP * math.sin(angle) + OFFSET))
        values.append(val)

    # print as localparam with reversed order
    print(f"localparam [{int(math.log2(N))}*{N}-1:0] SINETABLE_{N} = {{")
    for i, v in enumerate(reversed(values)):  # reversed so addr=0 is first
        sep = "," if i != N-1 else ""
        print(f"    {int(math.log2(N))}'d{v}{sep}")
    print("};")


class Sine(Design):
    def __init__(self):

        name = 'sine'
        root = f'{name}_root'
        source = [f'rtl/{name}.v']

        # create a Design object
        super().__init__(name)

        # set data home directory
        self.set_dataroot(root, dirname(abspath(__file__)))

        # rtl files
        fileset = 'rtl'
        for item in source:
            self.add_file(item, fileset, dataroot=root)

        # include dir
        self.add_idir("rtl", fileset, dataroot=root)

        # top module
        self.set_topmodule(name, fileset)


if __name__ == "__main__":
    d = Sine()
    d.write_fileset("sine.f", fileset="rtl")
    #sinetable(256)
