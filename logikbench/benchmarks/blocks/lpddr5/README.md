# lpddr5 (LPDDR5 memory controller, UMI front-end + DFI PHY port)

**Source:** [rtl/lpddr5_umi.v](rtl/lpddr5_umi.v)

## What it is

A synthesizable, technology-agnostic **LPDDR5 memory controller** (JESD209-5
command model) with a **UMI transaction front-end** on the host side and a
**DFI-style command/data port** on the memory side. It accepts read/write burst
requests, tracks per-bank state, schedules a JEDEC-legal LPDDR5 command stream
honoring the full bank-group timing model, and returns read data (or write acks)
to the requester. The (inherently process/package-specific) **PHY is out of
scope** and attaches at the DFI boundary, exactly as in a real LPDDR5 design.

The benchmark top is `lpddr5_umi` (UMI front-end + queues + controller). The
bare `lpddr5` controller is independently usable through its generic valid/ready
host port.

It implements four production-class features:

- **Deep per-bank request reorder** -- a per-bank request queue (depth `QD`)
  lets the open-page scheduler reorder column commands across banks/groups,
  exploiting the shorter `tCCD_S`/`tRRD_S` between bank groups.
- **Link ECC (SEC-DED)** -- one `(39,32)` extended-Hamming lane per 32 data
  bits of the burst protects the controller<->PHY link: single-bit errors are
  corrected, double-bit errors flagged (`ecc_corr`/`ecc_uncorr`).
- **Power management** -- automatic power-down and self-refresh entry after
  programmable idle windows (pages are precharged first), with `tXP`/`tXSR`
  exit latencies and `dfi_cke` driven low while parked.
- **UMI front-end** -- a SUMI device endpoint with request decode, per-tag
  routing context, and an output response queue.

## Architecture

Bank-group mode, `NBG` groups x `NBPG` banks (`NB = NBG*NBPG`). One host
request maps to one LPDDR5 burst (`BL` columns). All command timing is in CK
(command-clock) units and every `tXXX` is an overridable parameter; defaults are
a representative LPDDR5-6400 bin.

- **`lpddr5_bank`** (one per bank, via `generate`) -- open-row tracker plus
  saturating down-counters for the bank-local timings (`tRCD` ACT->col, `tRAS`
  /`tRTP`/write-recovery ACT/RD/WR->PRE, `tRC`/`tRP` ACT eligibility, `tRFCpb`).
  Exposes `can_act`/`can_col`/`can_pre`; the top pulses `do_*` strobes back.
- **`lpddr5`** (controller top) --
  - per-bank request queues (depth `QD`) holding `{w,row,col,id,wdata}`;
  - cross-bank timing here: `tRRD_S/L`, rolling `tFAW` (4-deep history),
    `tCCD_S/L`, and bus turnaround `tWTR_S/L` and `tRTW`;
  - an all-bank auto-refresh engine (`tREFI` interval -> PREA + REFab,
    `tRFCab`);
  - a bank-group-aware open-page scheduler issuing at most one command per CK,
    preferring ready column commands;
  - a power FSM (active / power-down / self-refresh) with idle counters and an
    idle-precharge step before entry;
  - `NLANE` SEC-DED encode lanes on write data and decode lanes on read data.
- **`lpddr5_ecc`** -- `lpddr5_ecc_enc` (32 data -> 39-bit code) and
  `lpddr5_ecc_dec` (code -> corrected data + corr/uncorr). The Hamming column
  table is a packed constant sliced by genvar (no functions, no SV literals).
- **`lpddr5_umi`** (benchmark top) -- unpacks SUMI requests (`REQ_READ`=0x01,
  `REQ_WRITE`=0x03 acked, `REQ_POSTED`=0x05) into controller bursts, keeps a
  per-tag `{srcaddr,dstaddr,cmd}` context so read responses route back to the
  requester, and packs `RESP_READ`/`RESP_WRITE` packets through an output queue.
  The DFI port passes straight through to the PHY.

## Interface (`lpddr5_umi`)

| Signal              | Dir | Width   | Meaning                                  |
|---------------------|-----|---------|------------------------------------------|
| `clk`, `rst`        | in  | 1       | clock, synchronous active-high reset     |
| `udev_req_*`        | in  | UMI     | SUMI request (cmd/dstaddr/srcaddr/data)  |
| `udev_req_ready`    | out | 1       | request accept                           |
| `udev_resp_*`       | out | UMI     | SUMI response (read data / write ack)    |
| `udev_resp_ready`   | in  | 1       | response accept                          |
| `dfi_valid`,`dfi_cmd` | out | 1,4   | DFI command strobe + decoded command     |
| `dfi_bg`,`dfi_ba`,`dfi_addr` | out | -| bank group / bank / row-or-column        |
| `dfi_cke`           | out | 1       | clock-enable (low in power-down/SREF)    |
| `dfi_wrdata_en`,`dfi_wrdata` | out | 1,CODEW | DFI write data (ECC-coded), ~WL later |
| `dfi_rddata_valid`,`dfi_rddata` | in | 1,CODEW | DFI read data (ECC-coded), RL later |
| `ecc_corr`,`ecc_uncorr` | out | 1   | link-ECC status for the returned read    |

`DATAW = BL*DQW`, `NLANE = DATAW/32`, `CODEW = NLANE*39`.

## Parameters (selected)

| Parameter        | Default | Meaning                                     |
|------------------|---------|---------------------------------------------|
| `DQW`            | 16      | channel DQ width                            |
| `BL`             | 32      | burst length (BG mode)                       |
| `NBG`,`NBPG`     | 4,4     | bank groups, banks per group (`NB`=16)       |
| `ROWW`,`COLW`    | 16,6    | row / column (burst) address width           |
| `IDW`            | 6       | request id (tag) width                       |
| `QD`             | 4       | per-bank request queue depth                 |
| `RL`,`WL`        | 20,10   | read / write latency (CK)                    |
| `T_PDE`,`T_SRE`  | 16,64   | idle CK before power-down / self-refresh      |
| `TXP`,`TXSR`     | 8,30    | power-down / self-refresh exit latency (CK)   |
| timing `tXXX`    | LPDDR5-6400 | tRCD/tRP/tRAS/tRC/tRTP/tWRC/tRRD_S-L/tFAW/tCCD_S-L/tWTR_S-L/tRTW/tRFCab/tREFI |

## Mapping

Control-plane logic -- per-bank FSMs and timing counters, the scheduler, the
refresh/power FSMs, and the address/control flops -- maps to LUTs and FFs. The
SEC-DED encode/decode lanes are combinational XOR parity trees (constant-folded
column table) -- LUTs, no DSP. There are **no multipliers** (0 DSP). The wide
data arrays do infer **block RAM**: the per-bank write-data queues (`q_wd`,
`CODEW=624` bits x `QD` x `NB` banks at the defaults) dominate, plus the UMI
per-tag context (`ctx_*`, `2**IDW` entries) and the output response queue
(`rq_*`, depth 64, carrying a full burst). Reference point (Yosys, z1015,
`lpddr5_umi`, default params): ~12.5k LUTs, ~11.7k FFs, ~82 dual-port BRAMs,
0 DSP, no latches. Shrinking `BL`/`DQW`/`QD`/`IDW` reduces the BRAM count.

## Files

- `rtl/lpddr5_bank.v` -- per-bank state machine and timing tracker.
- `rtl/lpddr5_ecc.v` -- `(39,32)` SEC-DED encoder/decoder lanes.
- `rtl/lpddr5.v` -- controller top (queues, scheduler, refresh, power, ECC).
- `rtl/lpddr5_umi.v` -- UMI front-end (benchmark top `lpddr5_umi`).
- `testbench/test_lpddr5_smoke.v` -- Verilog-2005 self-checking smoke test:
  drives UMI transactions (posted writes across banks/groups, a clean read pass
  and an injected single-bit link-error pass that SEC corrects, acked writes)
  against a behavioral DFI-layer LPDDR5 model that stores/returns ECC-coded data
  and checks the command stream against the JEDEC timing model and the
  power-management protocol. Asserts UMI response data/opcode/routing,
  zero timing violations, zero uncorrectable ECC, and that power-down and
  self-refresh were both exercised. Run:

  ```
  iverilog -g2005 -o sim.out rtl/lpddr5_bank.v rtl/lpddr5_ecc.v \
           rtl/lpddr5.v rtl/lpddr5_umi.v testbench/test_lpddr5_smoke.v
  vvp sim.out
  ```

## References

This RTL is an original implementation. It follows the JEDEC LPDDR5 command and
timing model and the cited controller/ECC architectures; it is not copied from,
nor derived from, any specific HDL source.

### Standard / algorithm

1. JEDEC Solid State Technology Association, *Low Power Double Data Rate 5/5X
   (LPDDR5/5X) SDRAM Standard*, JESD209-5. (command set, bank-group mode,
   timing parameters, refresh and power-down/self-refresh protocol)
2. JEDEC, *DDR PHY Interface (DFI) Specification*, v5.0. (controller<->PHY
   command/write/read-data interface modeled by the DFI port)
3. R. W. Hamming, "Error detecting and error correcting codes," *Bell System
   Technical Journal*, vol. 29, no. 2, pp. 147-160, 1950. (the SEC-DED
   extended-Hamming link code)
4. Universal Memory Interface (UMI) specification,
   https://github.com/zeroasiccorp/umi. (the SUMI request/response packet
   format used by the front-end)

### Hardware implementation

5. B. Jacob, S. W. Ng, and D. T. Wang, *Memory Systems: Cache, DRAM, Disk*,
   Morgan Kaufmann, 2007. (DRAM controller architecture: bank state machines,
   open-page policy, request scheduling and reordering, refresh management)
6. S. Rixner, W. J. Dally, U. J. Kapasi, P. Mattson, and J. D. Owens, "Memory
   access scheduling," *ISCA*, 2000. (bank-aware/out-of-order DRAM command
   scheduling that the per-bank-queue reorder scheme follows)
