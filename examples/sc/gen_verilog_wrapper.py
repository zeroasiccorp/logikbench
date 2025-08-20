from pathlib import Path
from parse_verilog_ports import extract_ports_from_file


def gen_verilog_wrapper(
        top_level_module: str,
        wrapper_module_name: str,
        input_file: Path,
        output_file: Path):
    """Create a top level wrapper for a verilog file"""

    # Get ports from file
    top_level_ports = None
    top_level_ports = extract_ports_from_file(
        filepath=input_file,
        top_level_module=top_level_module
    )
    assert top_level_ports is not None, "Error, Could not find top level module"

    # Create wrapper
    wrapper = f"""
module {wrapper_module_name}(
{"".join(
        [
            f"\t{port['direction']} wire {port['vector']} {port['name']},\n"
            for port in top_level_ports
        ]
    ).rstrip().removesuffix(',')});
    {top_level_module} {top_level_module}_inst(
{"".join(
            [
                f"\t.{port['name']}({port['name']}),\n"
                for port in top_level_ports
            ]
        ).rstrip().removesuffix(',')});
endmodule

"""

    # Write wrapper to disc
    with open(output_file, "w") as f:
        f.write(wrapper)
