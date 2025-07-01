import gen_class
import glob
import os
import sys

group = "basic"

paths = glob.glob(f"../logikbench/{group}/*")
lb_list = [os.path.basename(item) for item in paths]
lb_list = ['crossbar', 'binv']
for item in lb_list:
    sys.argv = ["gen_class.py", item, f"../logikbench/{group}/{item}"]
    gen_class.main()
