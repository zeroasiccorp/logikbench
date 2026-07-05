PicoRV32 - A Size-Optimized RISC-V CPU
============================================

## Description

A popular single file parametrized RV32I CPU design.

## Parameters

- Our RTL (rtl/picorv32.v) is a modified copy of upstream picorv32.v: the
  parameter defaults are changed directly in the RTL, not passed from
  picorv32.py. The changed defaults are listed under Modifications below.
- Upstream reference: https://github.com/YosysHQ/picorv32/blob/main/picorv32.v

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
- LATCHED_MEM_RDATA = 1
- TWO_STAGE_SHIFT = 0
- BARREL_SHIFTER = 1
- COMPRESSED_ISA = 1
- CATCH_MISALIGN = 0
- CATCH_ILLINSN = 0
- ENABLE_PCPI = 1
- ENABLE_MUL = 1
- ENABLE_FAST_MUL = 1
- ENABLE_DIV = 1
- ENABLE_IRQ = 1
- ENABLE_IRQ_QREGS = 0
- ENABLE_IRQ_TIMER = 0
