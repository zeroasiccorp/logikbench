###############################
# Custom Synthesis Logic
###############################

yosys synth -flatten -top $sc_topmodule

# sc_liberty is a list of liberty files (one for most PDKs, several when the
# library is split by cell group, e.g. asap7). dfflibmap/abc take a -liberty
# flag per file, so build the arg list and map against all of them.
set lib_args {}
foreach lib_file $sc_liberty {
    lappend lib_args -liberty $lib_file
}
yosys dfflibmap {*}$lib_args
yosys abc {*}$lib_args
yosys setundef -zero
yosys opt_clean -purge
