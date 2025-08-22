# Block Level Synthesis Constraints
# https://docs.amd.com/r/en-US/ug949-vivado-design-methodology/Block-Level-Synthesis-Strategy
set_property BLOCK_SYNTH.MAX_LUT_INPUT 4 [get_cells *]
set_property BLOCK_SYNTH.MUXF_MAPPING 0 [get_cells *]
set_property BLOCK_SYNTH.ADDER_THRESHOLD 128 [get_cells *]
set_property BLOCK_SYNTH.COMPARATOR_THRESHOLD 128 [get_cells *]
