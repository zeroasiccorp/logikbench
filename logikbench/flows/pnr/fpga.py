"""FPGA place-and-route flow (`lb pnr`, FPGA targets).

Wraps SiliconCompiler's Logik FPGA flow
(https://github.com/siliconcompiler/logik): RTL -> synthesis -> place-and-route
-> bitstream for ZeroASic eFPGA devices. Reused as-is (SC-ecosystem-first). The
FPGA device (from logiklib, e.g. logiklib.zeroasic.z1000) is selected on the
project by the runner via project.set_fpga(...), analogous to the PDK setup on
the ASIC pnr path.

'logik' is an optional dependency: it is imported lazily so that importing this
package (or running ASIC pnr) does not require it. FPGA pnr errors with an
install hint only when actually invoked without logik present.
"""


def FPGAPnR(tool="logik", name="fpga_pnr"):
    """Logik FPGA flow (synth + P&R + bitstream) for `lb pnr` on FPGA targets.
    `tool` is reserved for future engine selection."""
    try:
        from logik.flows.logik_flow import LogikFlow
    except ImportError as e:
        raise ImportError(
            "FPGA place-and-route uses the Logik flow "
            "(https://github.com/siliconcompiler/logik); install it with "
            "'pip install logik' (plus logiklib for device targets).") from e
    return LogikFlow()
