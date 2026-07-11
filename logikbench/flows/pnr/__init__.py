"""Place-and-route flows (`lb pnr`), split by target class.

    asic.py -> ASICPnR  (SC asicflow: synthesis -> ... -> route)
    fpga.py -> FPGAPnR  (Logik FPGA flow: synthesis -> P&R -> bitstream)

The runner selects the module by the target's class; the PDK (ASIC) or FPGA
device (logiklib) is configured on the project by the runner. The 'logik'
dependency behind FPGAPnR is imported lazily, so importing this package never
requires it.
"""

from logikbench.flows.pnr.asic import ASICPnR
from logikbench.flows.pnr.fpga import FPGAPnR

__all__ = ["ASICPnR", "FPGAPnR"]
