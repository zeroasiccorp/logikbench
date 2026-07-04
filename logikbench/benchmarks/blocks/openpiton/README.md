# openpiton (NoC router)

## What this benchmark is

OpenPiton is Princeton University's open-source, manycore research processor.
Its tiles (each normally containing a CPU core, L1.5 and L2 cache slices) are
connected by on-chip networks. This benchmark is the **network-on-chip (NoC)
only**: a single OpenPiton `dynamic_node` router configured for a 2D-mesh
topology. It contains **no CPU core, no FPU, and no caches** -- it is a pure
interconnect (routing + buffering + flow control) circuit.

The RTL is vendored, unmodified, from the OpenPiton Design Benchmark (OPDB):

- Source: https://github.com/PrincetonUniversity/OPDB
- Path:   `modules/dynamic_node_2dmesh/NETWORK_2dmesh/dynamic_node_2dmesh.pickle.v`
- Branch: `master` (fetched 2026-06-25; pin the commit hash when available)
- License: BSD 3-Clause (Copyright (c) 2015 Princeton University)

The OPDB file is a "pickle": a single self-contained Verilog file with the full
module hierarchy flattened into one file (no includes, no defines, no external
dependencies). The top module is `dynamic_node_top_wrap`.

Note: "2dmesh" names the router *variant* (5-port, dimension-ordered mesh
routing), NOT an array of tiles. The benchmark is a **single router node**, not
an NxN mesh. (The pickle also carries an unused parameterized/crossbar variant,
`dynamic_node_top_wrap_para`, which is pruned away when `dynamic_node_top_wrap`
is selected as the top.)

## What the circuit contains

A single `dynamic_node` router with **5 ports**: four cardinal directions to
neighboring tiles (North, East, South, West) plus a local "Processor" port. Per
port the interface carries a 64-bit flit (`dataIn/Out_*`), a `validIn/Out_*`
strobe, and a `yummyIn/Out_*` credit-return signal (OpenPiton's credit-based,
"valid/yummy" flow control). The router's mesh position is supplied by
`myLocX` / `myLocY` / `myChipID`.

Internally the router is built from (module inventory in the pickle):

- **Input blocks** (`dynamic_input_top_16`, `dynamic_input_top_4`,
  `network_input_blk_multi_out`): per-port input FIFOs that buffer incoming
  flits. (In synthesis these FIFOs map to BRAM.)
- **Routing** (`dynamic_input_route_request_calc`, `dynamic_input_control`):
  dimension-ordered (X-Y) route computation from the flit header and this
  tile's `myLocX/Y`, producing per-direction route requests.
- **Output blocks** (`dynamic_output_top`, `dynamic_output_control`,
  `dynamic_output_datapath`): per-output arbitration across the five input
  sources and the output crossbar/datapath that drives the selected flit out.
- **Flow control** (`space_avail_top`): tracks downstream buffer occupancy and
  generates the credit ("yummy") signals so a port only sends when the
  neighbor has space.
- Helpers: `one_of_n`, `one_of_five`, `one_of_eight`, `flip_bus`,
  `bus_compare_equal`, `net_dff`.

Deliberately absent (vs a full OpenPiton tile): the SPARC core, FPU, L1.5/L2
caches, memory, and the multi-tile mesh fabric. This keeps the benchmark a
small, pure router (routing logic + FIFOs + arbitration/crossbar).

## Parameters / configuration

The OPDB pickle is generated at a fixed configuration; the values below are the
ones baked into this file. Some are RTL parameters, some are hardwired widths.

| Parameter / width        | Value | Where / meaning                              |
|--------------------------|-------|----------------------------------------------|
| NoC flit (data) width    | 64    | `dataIn/Out_*` payload width                 |
| Router ports             | 5     | N, E, S, W, P (processor/local)              |
| Routing                  | X-Y   | dimension-ordered (2D mesh)                  |
| Flow control             | credit| valid / yummy (credit return)               |
| Tile X coordinate width  | 8     | `myLocX`                                     |
| Tile Y coordinate width  | 8     | `myLocY`                                     |
| Chip ID width            | 14    | `myChipID`                                   |
| Input FIFO depth (deep)  | 16    | `dynamic_input_top_16` ports                 |
| Input FIFO depth (small) | 4     | `dynamic_input_top_4` ports                  |
| FIFO depth param         | `LOG2_NUMBER_FIFO_ELEMENTS` | log2 entries (=2 -> 4) in `network_input_blk_multi_out` |
| Downstream buffer size   | `BUFFER_SIZE` = 4 (`BUFFER_BITS` = 3) | `space_avail_top` credit tracking |

These are fixed by the OPDB-generated pickle; changing them (e.g. flit width or
FIFO depth) would require regenerating the design with OpenPiton/OPDB rather
than editing this vendored file.
