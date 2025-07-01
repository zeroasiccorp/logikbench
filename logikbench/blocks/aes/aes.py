from os.path import dirname, abspath
from siliconcompiler.design import DesignSchema


class Aes(DesignSchema):
    def __init__(self):

        name = 'aes'
        root = f'{name}_root'
        source = [f'rtl/{name}.v']

        # create a Design object
        super().__init__(name)

        # set data home directory
        self.register_package(root, dirname(abspath(__file__)))

        # rtl files
        fileset = 'rtl'
        for item in ('rtl/aes.v',
                     'rtl/aes_inv_cipher_top.v',
                     'rtl/aes_inv_sbox.v',
                     'rtl/aes_key_expand_128.v',
                     'rtl/aes_rcon.v',
                     'rtl/aes_sbox.v'):
            self.add_file(item, fileset, package=root)

        # top module
        self.set_topmodule(name, fileset)

if __name__ == "__main__":
   d = Aes()
   d.write_fileset(f"aes.f", fileset="rtl")
