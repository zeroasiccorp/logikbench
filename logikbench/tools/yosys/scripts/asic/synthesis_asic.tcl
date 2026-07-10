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

# Best-effort timing: even this minimal recipe steers abc for delay and keeps
# the mapper away from cells it must not use. The main std-cell library and its
# cell groups / yosys metadata come from the SC manifest (already sourced by
# synthesis.tcl).
set sc_mainlib [sc_cfg_get asic mainlib]

# dfflibmap excludes only the explicit dont-use cells (matches SC).
set dff_dont_use {}
foreach cell [sc_cfg_get library $sc_mainlib asic cells dontuse] {
    lappend dff_dont_use -dont_use $cell
}

# abc additionally excludes hold/clock cells so they are never mapped into
# ordinary datapath logic.
set abc_dont_use {}
foreach group {dontuse hold clkbuf clkgate clklogic} {
    foreach cell [sc_cfg_get library $sc_mainlib asic cells $group] {
        lappend abc_dont_use -dont_use $cell
    }
}

# abc drive/load model: a set_driving_cell + set_load constraint file built from
# the main library's yosys metadata (same values SC uses). Emit only the lines
# that exist so PDKs without the metadata still run.
set abc_constr_args {}
set abc_driver {}
if { [sc_cfg_exists library $sc_mainlib tool yosys driver_cell] } {
    set abc_driver [sc_cfg_get library $sc_mainlib tool yosys driver_cell]
}
set abc_load {}
if { [sc_cfg_exists library $sc_mainlib tool yosys abc_constraint_load] } {
    set abc_load [sc_cfg_get library $sc_mainlib tool yosys abc_constraint_load]
}
if { $abc_driver ne {} || $abc_load ne {} } {
    set abc_constr_file "abc.constraints"
    set fh [open $abc_constr_file w]
    if { $abc_driver ne {} } { puts $fh "set_driving_cell $abc_driver" }
    if { $abc_load ne {} } { puts $fh "set_load $abc_load" }
    close $fh
    set abc_constr_args [list -constr $abc_constr_file]
}

yosys dfflibmap {*}$dff_dont_use {*}$lib_args

# -D 1: push abc to minimize delay as hard as the library allows (an aggressive
# target well below any achievable period, so mapping is fully delay-driven).
yosys abc -D 1 {*}$abc_constr_args {*}$abc_dont_use {*}$lib_args

yosys setundef -zero
yosys opt_clean -purge
