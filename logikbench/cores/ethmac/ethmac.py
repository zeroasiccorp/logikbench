#!/usr/bin/env python3

import os
from siliconcompiler import Chip

def setup():

    # root dir
    root = os.path.dirname(__file__)

    #module
    name = 'ethmac'

    # library object
    chip = Chip(name)

    # rtl
    for item in ('ethmac.v',
                 'eth_mac_1g.v',
                 'axis_gmii_rx.v',
                 'axis_gmii_tx.v',
                 'lfsr.v'):
        chip.input(os.path.join(root, 'rtl', item))

    # sdc
    chip.input(os.path.join(root, 'sdc', f'{name}.sdc'))

    return chip
