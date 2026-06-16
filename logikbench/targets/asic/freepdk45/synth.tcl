# Yosys ASIC synthesis recipe for the LogikBench 'nangate45' target.
#
# Driven by SiliconCompiler as: yosys -c synth.tcl
# SC writes sc_manifest.tcl, exposing sc_topmodule / sc_designlib; the liberty
# path is passed as the 'liberty' task variable by the flow.

source ./sc_manifest.tcl

# name of the synthesis command and default options for this target
set cmd synth
set default_options {-flatten}

########################################################
# Boiler plate below
########################################################

# Required yosys plugin
yosys plugin -i slang

# Standard-cell liberty (set by the flow)
set liberty [lindex [sc_cfg_tool_task_get var liberty] 0]

# Design RTL files from the active fileset
set fileset [lindex [sc_cfg_get option fileset] 0]
set rtl_files [concat \
    [sc_cfg_get_fileset $sc_designlib $fileset systemverilog] \
    [sc_cfg_get_fileset $sc_designlib $fileset verilog]]

# Read and elaborate the design
yosys read_slang --top $sc_topmodule {*}$rtl_files
yosys hierarchy -check -top $sc_topmodule

# Generic synthesis then technology mapping to the standard cells
yosys $cmd -top $sc_topmodule {*}$default_options
yosys dfflibmap -liberty $liberty
yosys abc -liberty $liberty
yosys setundef -zero
yosys opt_clean -purge

# Stats for metric extraction (area requires the liberty)
file mkdir reports
yosys tee -o ./reports/stat.json stat -json -top $sc_topmodule -liberty $liberty

# Write synthesized netlist for downstream timing
file mkdir outputs
yosys write_verilog -noattr "outputs/$sc_topmodule.vg"
