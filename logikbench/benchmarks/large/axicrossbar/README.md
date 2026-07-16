AXI crossbar
============================================

## Description

**Source:** [rtl/axi_crossbar.v](rtl/axi_crossbar.v)

Parametrizable axi crossbar module written in standard Verilog.

## Parameters

- S_COUNT
- M_COUNT
- DATA_WIDTH
- ADDR_WDTH

## Original Sources

- author: Alex Forencich
- repo: https://github.com/alexforencich/verilog-lfsr
- commit: 516bd5dadc3365b7f9e225d2af8fe0b8d804fe53

## License

- MIT (See LICENSE file for more details)

## Modifications

- `rtl/axi_crossbar_addr.v`: changed the per-thread power-on initializer
  `thread_count_reg[n] <= 0;` from a non-blocking to a blocking assignment
  (`= 0;`) inside its `initial` block. The slang front end rejects non-blocking
  assignments in design initialization; the two forms are equivalent for a
  constant time-0 initializer, and the register is also reset in the clocked
  block. This lets the design elaborate without slang's `--ignore-initial`.
