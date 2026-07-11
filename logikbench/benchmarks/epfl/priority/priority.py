from os.path import dirname, abspath
from siliconcompiler import Design


class Priority(Design):
    def __init__(self):

        name = 'priority'
        root = f'{name}_root'
        source = ['rtl/priority.v']

        # create a Design object
        super().__init__(name)

        # set data home directory
        self.set_dataroot(root, dirname(abspath(__file__)))

        # rtl files
        fileset = 'rtl'
        for item in source:
            self.add_file(item, fileset, dataroot=root)

        # top module (the RTL module was renamed from the reserved SV keyword
        # 'priority' to 'priority_encoder' so slang can lint it; see README)
        self.set_topmodule('priority_encoder', fileset)


if __name__ == "__main__":
    d = Priority()
    d.write_fileset("priority.f", fileset="rtl")
