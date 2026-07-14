# Run the resolved FPGA synth command. $sc_command is the yosys synth command
# line for this target, mapped from "<vendor>_<partname>" in benchmark.py
# (FPGA_TARGETS), e.g. "synth_xilinx -family xc7". It may be a ';'-separated
# sequence when a plugin must load first (the zeroasic parts need wildebeest:
# "plugin -i wildebeest; synth_fpga -partname z1010"). Run each part as a yosys
# command; append -top and the user's --options to the final (synth) part only,
# since a leading plugin load takes neither.

set sc_parts [split $sc_command ";"]
set sc_last [expr {[llength $sc_parts] - 1}]
for {set i 0} {$i < [llength $sc_parts]} {incr i} {
    set sc_part [string trim [lindex $sc_parts $i]]
    if {$sc_part eq ""} continue
    if {$i == $sc_last} {
        yosys {*}$sc_part -top $sc_topmodule {*}$sc_options
    } else {
        yosys {*}$sc_part
    }
}

# Logic depth. Tee the 'ltp' result to a small report so the metric survives
# the post-run cleanup (clean_build keeps reports/ but reclaims the run log).
yosys echo off
yosys tee -o ./reports/ltp.rpt ltp -noff
yosys echo on
