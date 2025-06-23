# create virtual clock
create_clock -name vclk -period 1000

# inputs arrive on rising edge
set_input_delay 0.0 -clock vclk [get_ports a*]
set_input_delay 0.0 -clock vclk [get_ports b*]

# outputs ready on rising edge
set_output_delay 0.0 -clock vclk [get_ports c*]
