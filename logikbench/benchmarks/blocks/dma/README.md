# dma

**Source:** [rtl/dma.v](rtl/dma.v)

A single-channel AXI4 burst-master **scatter-gather DMA** engine: it walks a
linked list of descriptors in memory and executes each memory-to-memory copy
over one AXI4 master port.

## What it is

Software writes the byte address of the head descriptor to `desc_head_ptr` and
pulses `start`. The engine fetches descriptors (following `next` pointers),
copies each source region to its destination, and pulses `done` after the LAST
descriptor. Reads run ahead of writes through an internal FIFO. This fills the
Vitis "data mover" role in the suite.

## Circuit

```
dma                 top: single AXI4 master + control (desc_head_ptr/start/done)
+- dma_sg           scatter-gather FSM: fetch descriptor, chunk + copy, follow next
+- dma_read         AXI4 read master: INCR read bursts -> beat stream
+- dma_fifo         synchronous FIFO decoupling read from write (one chunk)
+- dma_write        AXI4 write master: FIFO -> INCR write bursts, consumes B
```

Per descriptor the transfer is split into chunks of up to `DEPTH` beats: a chunk
is read into the FIFO, then written out, so each AXI burst is a single INCR
burst and the FIFO never overflows.

## Descriptor format

Four `DW`-bit words in memory, contiguous at the descriptor's byte address:

| word | field | notes |
|------|-------|-------|
| 0 | `src_addr`  | source byte address |
| 1 | `dst_addr`  | destination byte address |
| 2 | `length`    | transfer length in beats |
| 3 | `next_ptr`  | next descriptor byte address; **bit 0 = LAST flag** (pointers are word-aligned, so bit 0 is free) |

## Interface

- **Control:** `start`, `desc_head_ptr[AW]`, `busy`, `done`.
- **AXI4 master:** standard AR / R / AW / W / B channels (`arsize`/`awsize` set
  from `DW`, `INCR` bursts, `wstrb` all-ones).

## Parameters

- `DW` = 64 (AXI data width), `AW` = 32 (address), `IDW` = 4 (AXI id),
  `DEPTH` = 32 (internal FIFO depth; must be a power of two, and is the max
  chunk / burst length).

## Testbench

`testbench/test_dma_smoke.v` includes a behavioral AXI4 slave memory model. It
builds a 3-descriptor chain (the last descriptor is longer than `DEPTH` to
exercise chunking and the LAST flag), programs the head pointer, starts the DMA,
waits for `done`, and checks every destination beat equals its source. Prints
`PASSED` / `FAILED`.

## Not tested / simplifications

INCR bursts only; one outstanding burst at a time; `WSTRB` all-ones
(word-granular length); fixed 4-word descriptor layout; addresses assumed
aligned; `BRESP` is consumed but not acted on (no error recovery/abort).

## References

This `dma.v` is an original RTL implementation, written from the AXI4 protocol
specification and the standard scatter-gather DMA architecture; it is not
derived from a specific HDL source.

* ARM AMBA AXI4 Protocol Specification (IHI 0022).
* Scatter-gather DMA (linked-descriptor memory movers), e.g. Xilinx Vitis
  data-mover / AXI DMA.
