#!/usr/bin/env python3

import os
from siliconcompiler import Chip

def setup():

    # root dir
    root = os.path.dirname(__file__)

    # library object
    chip = Chip('uart')

    # rtl
    for item in ('uart.v',
                 'uart_tx.v',
                 'uart_rx.v'):
        chip.input(os.path.join(root, 'rtl', item))

    # sdc
    chip.input(os.path.join(root, 'sdc', 'uart.sdc'))

    return chip
