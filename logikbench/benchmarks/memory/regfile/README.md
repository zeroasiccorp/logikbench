Register file
============================================

## Description

Parametrized register file with WP write ports and RP read ports.

## Parameters
- AW = 6,  // address width (regs = 2**AW)
- RW = 16, // register width
- RP = 5,  // # read ports
- WP = 3   // # write prots

## Original Source

- Repository: https://github.com/aolofsson/oh
- Commit: 7edfcb5f0506fb854449fbe09598a7ec88bb2067

## License

 - MIT (See LICENSE for more details)

## Modifications

- Removed dependency on oh_mux
- Moving from REGS to AW as a parameter
