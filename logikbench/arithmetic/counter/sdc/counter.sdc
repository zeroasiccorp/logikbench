###############################################################################
# Counter Module SDC Constraints
# File: logikbench/arithmetic/counter/sdc/counter.sdc
#
# These signals get used inside logikbench/targets/asic/default.sdc
#
# Alternatively, you could hard code the constraints in this file and
# not read the LB_DEFAULT.SDC
#
###############################################################################

########################################
# Signal lists
# Note that names are
########################################

set LB_CLK     [get_ports clk]
set LB_INPUTS  [get_ports {clear en}]
set LB_OUTPUTS [get_ports {count[*]}]

########################################
# Source constraints
########################################

source $LB_DEFAULT_SDC
