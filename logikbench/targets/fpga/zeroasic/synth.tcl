# Yosys FPGA synthesis recipe for the LogikBench 'zeroasic' target.
#
# Driven by SiliconCompiler as: yosys -c synth.tcl
# SC writes sc_manifest.tcl into the run directory, exposing:
#   sc_topmodule  - design top module
#   sc_designlib  - design library (name) holding the RTL fileset
# The active fileset is read from the schema (sc_cfg_get option fileset).

source ./sc_manifest.tcl

# name of the zeroasic synthesis command
set cmd synth_fpga

# default options for this target (extend as needed); appended last so a
# caller-supplied option could override
set default_options {}

########################################################
# Boiler plate below
########################################################

# Required yosys plugins
yosys plugin -i slang
yosys plugin -i wildebeest

# Design RTL files from the active fileset
set fileset [lindex [sc_cfg_get option fileset] 0]
set rtl_files [concat \
    [sc_cfg_get_fileset $sc_designlib $fileset systemverilog] \
    [sc_cfg_get_fileset $sc_designlib $fileset verilog]]

# Read and elaborate the design
yosys read_slang --top $sc_topmodule {*}$rtl_files

# Check design hierarchy and set top module
yosys hierarchy -check -top $sc_topmodule

# FPGA synthesis + technology mapping
yosys $cmd -top $sc_topmodule {*}$default_options

# Stats for metric extraction
file mkdir reports
yosys tee -o ./reports/stat.json stat -json -top $sc_topmodule

# Write synthesized netlist
file mkdir outputs
yosys write_verilog -noattr "outputs/$sc_topmodule.vg"
