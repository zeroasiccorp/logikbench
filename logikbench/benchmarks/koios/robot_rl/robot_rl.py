from os.path import dirname, abspath
from siliconcompiler import Design


class RobotRl(Design):
    def __init__(self):

        name = 'robot_rl'
        root = f'{name}_root'
        source = ['rtl/robot_rl.v']

        # create a Design object
        super().__init__(name)

        # set data home directory
        self.set_dataroot(root, dirname(abspath(__file__)))

        # rtl files
        fileset = 'rtl'
        for item in source:
            self.add_file(item, fileset, dataroot=root)

        # top module (upstream module name, kept verbatim)
        self.set_topmodule('robot_maze', fileset)


if __name__ == "__main__":
    d = RobotRl()
    d.write_fileset("robot_rl.f", fileset="rtl")
