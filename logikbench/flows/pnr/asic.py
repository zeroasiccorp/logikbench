"""ASIC place-and-route flow (`lb pnr`, ASIC targets).

Wraps SiliconCompiler's asicflow (synthesis -> floorplan -> place -> cts ->
route), reused as-is (SC-first -- LB does not redefine it). LB run configuration
(slang RTL read, low utilization + tight pin spacing for IO-dominated designs)
and the PDK/library/scenario setup are applied on the project by the runner; run
through 'route' for full place-and-route.

Adding a P&R engine (e.g. a proprietary tool such as Innovus) follows the
tools/ pattern; see logikbench/tools/README.md.
"""

from siliconcompiler.flows import asicflow


def ASICPnR(tool="openroad", name="asic_pnr"):
    """SC asicflow used for `lb pnr` on ASIC targets. `tool` is reserved for
    future P&R-engine selection; the SC asicflow currently uses OpenROAD."""
    return asicflow.ASICFlow()
