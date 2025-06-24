# parameters
set CLK_PERIOD 1000 # clock period, watch the units!
set INPUT_DELAY 0
set OUTPUT_DELAY $CLK_PERIOD

# create a clock
create_clock -name clk -period $CLK_PERIOD clk

# time used by external logic with respect to rising edge
set_input_delay $INPUT_DELAY -clock clk [get_ports addr*]
set_input_delay $INPUT_DELAY -clock clk [get_ports din*]

# time after launching rising edge that output must be ready
set_output_delay $OUTPUT_DELAY -clock clk [get_ports dout*]
