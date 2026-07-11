"""ASIC place-and-route flow (`lb pnr`, ASIC targets) -- local composition.

Reuses SiliconCompiler's asicflow *backend* subgraphs (floorplan -> place -> cts
-> route) but starts from a cached synthesized netlist instead of running
synthesis: an ImportFilesTask entry node brings in `lb syn`'s netlist and feeds
the OpenROAD P&R subgraphs. This mirrors how siliconcompiler.flows.asicflow
composes those same subgraphs, minus the SynthesisFlow front end.

Stops at detailed route -- no metal fill, no GDS export. The netlist path is
supplied by the runner on the project as the import task's 'file' var
(tool 'builtin', task 'importfiles').
"""

from siliconcompiler import Flowgraph
from siliconcompiler.tools.builtin.importfiles import ImportFilesTask
from siliconcompiler.flows.asicflow import (
    FloorplanningFlow,
    PlacementFlow,
    ClockTreeSynthesisFlow,
    FillerCellFlow,
    RoutingFlow,
)


class ASICPnR(Flowgraph):
    """Import a cached netlist, then run the asicflow backend through detailed
    route (floorplan -> place -> cts -> fillcell -> route). No metal fill/GDS.

    asicflow's post-synthesis synth_cleanup (OpenROAD buffer/dead-logic removal
    on the yosys netlist) is intentionally omitted: floorplan reads the imported
    netlist directly, so it is not required. Re-add a cleanup node here if P&R
    QoR ever needs it."""

    def __init__(self, tool="openroad", name="asic_pnr", floorplan_np=1,
                 place_np=1, cts_np=1, route_np=1):
        super().__init__()
        self.set_name(name)

        # Only OpenROAD has a hard-coded SC-task backend here. A different P&R
        # engine (e.g. a proprietary tool) would supply its own flow via tools/
        # (see logikbench/tools/README.md) -- so guard on the engine selection.
        if tool != "openroad":
            raise ValueError(
                f"pnr --tool '{tool}' has no flow; only 'openroad' is wired.")

        # entry: import the cached synthesized netlist (<top>.vg) as this node's
        # output, so the floorplan node reads it like any prior-node netlist.
        self.node("import", ImportFilesTask())
        prev = "import"

        # reuse SC's asicflow backend subgraphs, chained as asicflow does
        # (FillerCellFlow shares the 'cts' prefix, per asicflow). Ends at route.
        for prefix, graph in [
                ("floorplan", FloorplanningFlow(np=floorplan_np)),
                ("place", PlacementFlow(np=place_np)),
                ("cts", ClockTreeSynthesisFlow(np=cts_np)),
                ("cts", FillerCellFlow(np=1)),
                ("route", RoutingFlow(np=route_np))]:
            self.graph(graph, name=prefix)
            for node in graph.get_entry_nodes():
                self.edge(prev, f"{prefix}.{node[0]}", head_index=node[1])
            exits = graph.get_exit_nodes()
            if len(exits) != 1:
                raise ValueError(f"{graph.name} must have exactly one exit node")
            prev = f"{prefix}.{exits[0][0]}"
