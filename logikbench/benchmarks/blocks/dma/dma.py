from os.path import dirname, abspath
from siliconcompiler import Design


class Dma(Design):
    def __init__(self):

        name = 'dma'
        root = f'{name}_root'
        # leaf modules first, top last (single compilation unit)
        source = ['rtl/dma_fifo.v', 'rtl/dma_read.v', 'rtl/dma_write.v',
                  'rtl/dma_sg.v', 'rtl/dma.v']

        # create a Design object
        super().__init__(name)

        # set data home directory
        self.set_dataroot(root, dirname(abspath(__file__)))

        # rtl files
        fileset = 'rtl'
        for item in source:
            self.add_file(item, fileset, dataroot=root)

        # top module (single AXI4 master, scatter-gather controller)
        self.set_topmodule(name, fileset)
        self.set_param('DW', '64', fileset)      # AXI data width
        self.set_param('AW', '32', fileset)      # address width
        self.set_param('IDW', '4', fileset)      # AXI id width
        self.set_param('DEPTH', '32', fileset)   # internal FIFO depth (pow2)

        # self-checking testbench (`lb sim`)
        self.add_file(f'testbench/test_{name}_smoke.v', 'testbench', dataroot=root)
        self.set_topmodule(f'test_{name}_smoke', 'testbench')

        # variants
        self.variants = {
            "DW": [32, 64, 128, 256],
            "DEPTH": [16, 64, 256, 1024],
        }


if __name__ == "__main__":
    d = Dma()
    d.write_fileset("dma.f", fileset="rtl")
