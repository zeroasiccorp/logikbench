"""Synthesis flows (`lb syn`), split by target class.

    asic.py -> ASICSynthesis  (standard-cell mapper + OpenSTA timing)
    fpga.py -> FPGASynthesis  (Yosys synth_fpga)

The runner selects the module by the target's class; '--tool' selects the
engine within each flow's _SYNTH dict.
"""

from logikbench.flows.syn.asic import ASICSynthesis
from logikbench.flows.syn.fpga import FPGASynthesis

__all__ = ["ASICSynthesis", "FPGASynthesis"]
