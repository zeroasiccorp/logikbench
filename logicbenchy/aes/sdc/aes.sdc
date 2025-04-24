# TODO: drive these via siliconcompiler

set clk_period 10000
set input_delay 0
set output_delay 0

set clk_port [get_ports clk]

create_clock -name clk -period $clk_period $clk_port

set non_clock_inputs [lsearch -inline -all -not -exact [all_inputs] $clk_port]

set_input_delay $input_delay -clock clk $non_clock_inputs

set_output_delay $output_delay  -clock clk [all_outputs]
