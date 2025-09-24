from os.path import dirname, abspath
from siliconcompiler import Design


class Uart(Design):
    def __init__(self):

        name = 'uart'
        root = f'{name}_root'
        source = ['rtl/la_dsync.v',
                  'rtl/uart_raminfr.v',
                  'rtl/uart_receiver.v',
                  'rtl/uart_rfifo.v',
                  'rtl/uart_tfifo.v',
                  'rtl/uart_transmitter.v',
                  'rtl/uart.v',]

        # create a Design object
        super().__init__(name)

        # set data home directory
        self.set_dataroot(root, dirname(abspath(__file__)))

        # rtl files
        fileset = 'rtl'
        for item in source:
            self.add_file(item, fileset, dataroot=root)

        # include files
        self.add_idir('rtl', fileset, dataroot=root)

        # top module
        self.set_topmodule(name, fileset)

if __name__ == "__main__":
   d = Uart()
   d.write_fileset(f"uart.f", fileset="rtl")
