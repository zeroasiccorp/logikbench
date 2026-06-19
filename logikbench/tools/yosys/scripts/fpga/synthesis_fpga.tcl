# Map the FPGA target string to a yosys synth command. lb keeps the list of
# targets decoded here (see logikbench/flows/runner.py FPGA_TARGETS); a target
# not in that list selects the ASIC flow instead.
#
# synth_microchip
# synth_fabulous
# synth_gatemate
# synth_gowin
# synth_ice40
# synth_xilinx
# synth_efinix
# synth_achronix
# synth_quicklogic
# synth_intel
# zeroasic --> synth_fpga + plugin wildebeest

switch -- $sc_target {
    microchip   { set synth_cmd synth_microchip }
    fabulous    { set synth_cmd synth_fabulous }
    gatemate    { set synth_cmd synth_gatemate }
    gowin       { set synth_cmd synth_gowin }
    ice40       { set synth_cmd synth_ice40 }
    xilinx      { set synth_cmd synth_xilinx }
    efinix      { set synth_cmd synth_efinix }
    achronix    { set synth_cmd synth_achronix }
    quicklogic  { set synth_cmd synth_quicklogic }
    intel       { set synth_cmd synth_intel }
    default     { yosys plugin -i wildebeest; set synth_cmd synth_fpga }
}

# options from lb are appended verbatim as arguments to the synth command
yosys $synth_cmd -top $sc_topmodule {*}$sc_options

# Logic depth
yosys ltp -noff
