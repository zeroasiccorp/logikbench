# Generic timing constraints for LogikBench ASIC timing.
#
# Creates a clock on a port named 'clk' if present (the convention across the
# clocked benchmarks). Combinational designs have no clock port; for those a
# virtual clock (no associated port) is created instead so STA still has a
# timing reference and the input->output paths are constrained -- otherwise
# OpenROAD reports unconstrained endpoints / "no clocks defined" and the flow
# halts. The period is only a starting constraint; fmax is derived from the
# minimum achievable period, not this value.

if { [get_ports clk -quiet] ne "" } {
    create_clock -name clk -period 1.0 [get_ports clk]
    set_input_delay 0.0 -clock clk [all_inputs]
    set_output_delay 0.0 -clock clk [all_outputs]
} else {
    create_clock -name virt -period 1.0
    set_input_delay 0.0 -clock virt [all_inputs]
    set_output_delay 0.0 -clock virt [all_outputs]
}
