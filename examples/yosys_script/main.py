#####################################################################
# Simple script that loops over benchmarks using
# a native yosys script running at the command line
#####################################################################
import subprocess
import os
from pathlib import Path

def yosys_script(name, filename):
    return(f"""
# Read your RTL files
read_verilog {filename}

# Check design hierarchy and set top module
hierarchy -check -top {name}  # Replace 'top' with your top module name

# Generic synthesis
synth -top {name}

# Technology mapping for Xilinx (e.g., 6-input LUTs)
synth_xilinx -top {name}

memory_dff           ;# move DFFs into memory
memory_collect       ;# collect and prepare
memory_bram -rules +/xilinx_bram.rules  ;# apply Xilinx BRAM mapping rules
techmap -map +/xilinx_bram.v            ;# instantiate mapped BRAMs
opt_clean             ;# clean up

# Write synthesized netlist as Verilog
write_verilog -noattr {name}.vg
""".strip())

if __name__ == "__main__":

    #TODO: Add some arguments

    scriptdir = Path(__file__).resolve().parent
    rootdir = Path(__file__).resolve().parent.parent.parent

    #group_list = ['basic']
    group_list = ['memory']
    #group_list = ['basic', 'memory']

    script = "synth.ys"

    for group in group_list:
        group_path = rootdir / "logikbench" / group
        bench_list = [p.name for p in group_path.iterdir() if p.is_dir()]
        # iterate over all benchmarks
        for name in bench_list:
            os.makedirs(f"build/{group}/{name}", exist_ok=True)
            os.chdir(f"build/{group}/{name}")
            filename = group_path / name / "rtl" / f"{name}.v"
            content = yosys_script(name, filename)
            with open(script, "w") as file:
                file.write(content)
            # run
            try:
                result = subprocess.run(
                    ["yosys", script],
                    check=True,
                    capture_output=True,
                    text=True)

                print("Yosys output:")
                print(result.stdout)

            except subprocess.CalledProcessError as e:
                print("Yosys failed with error:")
                print(e.stderr)
            # go back home
            os.chdir(scriptdir)
