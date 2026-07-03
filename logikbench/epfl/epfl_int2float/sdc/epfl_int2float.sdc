###############################################################################
# epfl_int2float SDC timing constraints
# File: logikbench/epfl/epfl_int2float/sdc/epfl_int2float.sdc
###############################################################################

# Signal lists (clock is removed from LB_INPUTS by default.sdc)
set LB_CLK     [get_ports -quiet {*clk* *clock*}]
set LB_INPUTS  [all_inputs]
set LB_OUTPUTS [all_outputs]

# Technology constants (required)
source $LB_TECH_FILE

# Default constraints (required)
source $LB_DEFAULT_SDC
