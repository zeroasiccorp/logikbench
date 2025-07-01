from os.path import dirname, abspath
from siliconcompiler.design import DesignSchema


class Uart(DesignSchema):
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
   d = Uart()
   d.write_fileset(f"uart.f", fileset="rtl")
