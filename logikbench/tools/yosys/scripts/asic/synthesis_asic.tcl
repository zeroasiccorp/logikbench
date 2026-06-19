###############################
# Custom Synthesis Logic
###############################

yosys synth -flatten -top $sc_topmodule
yosys dfflibmap -liberty $sc_liberty
yosys abc -liberty $sc_liberty
yosys setundef -zero
yosys opt_clean -purge
