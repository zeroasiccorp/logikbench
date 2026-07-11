from os.path import dirname, abspath
from siliconcompiler import Design


class Fsm(Design):
    def __init__(self):

        name = 'fsm'
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

        # top module (RTL module name differs from the block/dir name)
        self.set_topmodule('parametric_fsm_benchmark', fileset)

        # self-checking testbench (`lb sim`)
        self.add_file(f'testbench/test_{name}_smoke.v', 'testbench', dataroot=root)
        self.set_topmodule(f'test_{name}_smoke', 'testbench')


if __name__ == "__main__":
    d = Fsm()
    d.write_fileset("fsm.f", fileset="rtl")
