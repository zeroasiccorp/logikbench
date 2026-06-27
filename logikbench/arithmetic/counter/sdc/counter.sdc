###############################################################################
# Counter Module SDC Constraints
###############################################################################

########################################
# Signal lists
########################################

set clk_port     [get_ports clk]
set data_inputs  [get_ports {clear en}]
set data_outputs [get_ports {count[*]}]

##########################################
# Apply the shared LogikBench constraints
##########################################

source $LB_DEFAULT_SDC
