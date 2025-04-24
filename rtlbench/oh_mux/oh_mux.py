import os
from siliconcompiler import Chip

def setup():

    # root dir
    root = os.path.dirname(__file__)

    #module
    name = 'oh_mux'

    # library object
    chip = Chip(name)

    # rtl
    chip.input(os.path.join(root, 'rtl', f'{name}.v'))

    # sdc
    chip.input(os.path.join(root, 'sdc', f'{name}.sdc'))

    # need to add parameter range

    return chip
