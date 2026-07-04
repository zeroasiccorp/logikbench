PicoRV32 - A Size-Optimized RISC-V CPU
============================================

## Description

A popular single file parametrized RV32I CPU design.

## Parameters

- Default overrides recorded in picorv32.py
- See https://github.com/YosysHQ/picorv32/blob/main/README.md for reference

## Original Sources

- Author: Claire Xenia Wolf
- Repo: https://github.com/YosysHQ/picorv32/
- Commit Hash: 87c89acc18994c8cf9a2311e871818e87d304568

## License

- MIT(See LICENSE file for details).

## Modifications

- Added SDC design constraints
- ENABLE_COUNTERS64 = 0
- ENABLE_REGS_DUALPORT = 0
- TWO_STAGE_SHIFT = 0
- ENABLE_MUL = 0
- ENABLE_FAST_MUL = 0
- ENABLE_IRQ_TIMER = 0
- ENABLE_IRQ_QREGS = 0
- LATCHED_MEM_RDATA = 1
- ENABLE_REGS_16_31 = 0
- CATCH_MISALIGN = 0
- CATCH_ILLINSN = 0
