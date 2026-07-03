###############################################################################
# csa32 SDC timing constraints
# File: logikbench/arithmetic/csa32/sdc/csa32.sdc
###############################################################################

# Signal lists (clock is removed from LB_INPUTS by default.sdc)
set LB_CLK     [get_ports clk -quiet]
set LB_INPUTS  [all_inputs]
set LB_OUTPUTS [all_outputs]

# Technology constants (required)
source $LB_TECH_FILE

# Default constraints (required)
source $LB_DEFAULT_SDC
