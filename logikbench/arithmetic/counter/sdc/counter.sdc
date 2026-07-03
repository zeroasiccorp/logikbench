###############################################################################
# Counter Counter SDC Constraints
# File: logikbench/arithmetic/counter/sdc/counter.sdc
###############################################################################

# Signal lists
set LB_CLK     [get_ports clk]
set LB_INPUTS  [get_ports {clear en}]
set LB_OUTPUTS [get_ports {count[*]}]

# Tecnology constants (required)
source $LB_TECH_FILE

# Default constraints (required)
source $LB_DEFAULT_SDC
