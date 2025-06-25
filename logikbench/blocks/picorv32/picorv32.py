#!/usr/bin/env python3

import os
from siliconcompiler import Chip

def setup():

    # root dir
    root = os.path.dirname(__file__)

    #module
    name = 'picorv32'

    # library object
    chip = Chip(name)

    # rtl
    chip.input(os.path.join(root, 'rtl', f'{name}.v'))

    # sdc
    chip.input(os.path.join(root, 'sdc', f'{name}.sdc'))

    return chip
