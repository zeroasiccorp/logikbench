#!/usr/bin/env python3

import os
from siliconcompiler import Chip

def setup():

    # root dir
    root = os.path.dirname(__file__)

    #module
    name = 'aes'

    # library object
    chip = Chip(name)

    # rtl
    for item in ('aes.v',
                 'aes_inv_cipher_top.v',
                 'aes_inv_sbox.v',
                 'aes_key_expand_128.v',
                 'aes_rcon.v',
                 'aes_sbox.v'):
        chip.input(os.path.join(root, 'rtl', item))


    # sdc
    chip.input(os.path.join(root, 'sdc', f'{name}.sdc'))

    return chip
