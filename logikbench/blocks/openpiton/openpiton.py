from os.path import dirname, abspath
from siliconcompiler import Design


class Openpiton(Design):
    def __init__(self):

        name = 'openpiton'
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

        # top module: single OpenPiton dynamic_node 2D-mesh NoC router
        self.set_topmodule('dynamic_node_top_wrap', fileset)
        self.add_file(f'sdc/{name}.sdc', 'sdc', dataroot=root)


if __name__ == "__main__":
    d = Openpiton()
    d.write_fileset("openpiton.f", fileset="rtl")
