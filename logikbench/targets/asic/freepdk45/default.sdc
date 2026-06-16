# Generic timing constraints for LogikBench ASIC timing.
#
# Creates a clock on a port named 'clk' if present (the convention across the
# clocked benchmarks). Combinational designs have no clock, so fmax is not
# reported for them. The period is only a starting constraint; fmax is derived
# from the minimum achievable period, not this value.

if { [get_ports clk -quiet] ne "" } {
    create_clock -name clk -period 1.0 [get_ports clk]
    set_input_delay 0.0 -clock clk [all_inputs]
    set_output_delay 0.0 -clock clk [all_outputs]
}
