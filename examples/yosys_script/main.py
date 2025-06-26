import subprocess
import os
from pathlib import Path

#################################################
def print_yosys_script(name, filename):
    return(f"""
# Read your RTL files
read_verilog {filename}

# Check design hierarchy and set top module
hierarchy -check -top {name}  # Replace 'top' with your top module name

# Generic synthesis
synth -top {name}

# Technology mapping for Xilinx (e.g., 6-input LUTs)
synth_xilinx -top {name}

# Write synthesized netlist as Verilog
write_verilog -noattr {name}.vg
""".strip())

if __name__ == "__main__":

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
            content = print_yosys_script(name, filename)
            with open(script, "w") as file:
                file.write(content)
            # run
            try:
                result = subprocess.run(
                    ["yosys", script],
                    check=True,                  # Raise error if Yosys fails
                    capture_output=True,         # Capture stdout and stderr
                    text=True)                   # Decode bytes to string

                print("Yosys output:")
                print(result.stdout)

            except subprocess.CalledProcessError as e:
                print("Yosys failed with error:")
                print(e.stderr)
            # go back home
            os.chdir(scriptdir)
