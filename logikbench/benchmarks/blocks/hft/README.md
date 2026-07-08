# hft

**Source:** [rtl/hft.v](rtl/hft.v)

Tick-to-trade high-frequency-trading pipeline: a 512-bit market-data word
streams in and, six registered stages later, a 512-bit order packet streams
out. Modeled after an FPGA low-latency trading datapath (parse -> book ->
signal -> strategy -> risk -> encode).

## What it is

A streaming, valid-only pipeline (no backpressure) with one register stage per
box in the block diagram:

1. **hft_parser** - decodes the 512-bit market-data word into
   `{msg_type, symbol_id, side, level, price, qty}` using a simplified,
   self-defined binary layout (not any proprietary exchange protocol).
2. **hft_book** - a level-indexed limit order book. Per side (bid/ask), a
   simple dual-port RAM (inferred BRAM) stores `{price,qty}` indexed by
   `{symbol, level}`. Each update/delete writes the addressed level and reads
   out the top of book (level 0); a level-0 write is forwarded so the emitted
   top of book reflects the current update.
3. **hft_feature** - computes spread (`ask-bid`), mid (`(bid+ask)/2`), size
   imbalance (`bid_qty-ask_qty`), and an imbalance-weighted fair value
   `mid + (imbalance*SKEW_K) >>> SKEW_SH` (saturated). The multiply maps to a
   DSP/hard multiplier.
4. **hft_strategy** - threshold rules: buy if fair is above ask by MARGIN,
   sell if below bid by MARGIN, cancel if the spread is wider than WIDE, else
   replace (requote at mid).
5. **hft_risk** - pre-trade checks: price band around the mid, per-order
   notional limit (`price*qty`, a second multiply), and per-symbol position
   limit. Breaching orders are suppressed; passing buys/sells update the
   running per-symbol position.
6. **hft_encoder** - packs the decision into a 512-bit order packet and
   asserts `order_packet_valid` only for real actions.

Total latency is 6 cycles. Features use the top of book (level 0); deeper
levels are stored (exercising the book memory) but not consumed by the current
feature set.

Key parameters: `NSYM` (symbols, default 32), `NLEVEL` (levels/side, default
16, power of two), `PRICE_W` (default 32), `QTY_W` (default 16), plus strategy
(`SKEW_K`, `SKEW_SH`, `MARGIN`, `WIDE`, `ORDER_QTY`) and risk (`POS_LIMIT`,
`NOTIONAL_LIMIT`, `PRICE_BAND`) knobs.

## Interface

| Signal              | Dir | Width | Description                    |
|---------------------|-----|-------|--------------------------------|
| `clk`               | in  | 1     | clock                          |
| `nreset`            | in  | 1     | async reset, active low        |
| `market_data_valid` | in  | 1     | input word valid               |
| `market_data_word`  | in  | 512   | market-data message            |
| `order_packet_valid`| out | 1     | output order valid             |
| `order_packet_word` | out | 512   | encoded order                  |

Message layout (both directions, byte-aligned): `[7:0]` type/action,
`[8+:SYMW]` symbol, `[16]` side, `[24+:LVLW]` level (input only),
`[32+:PRICE_W]` price, `[64+:QTY_W]` qty. The book RAM models power-on-zero, so
a symbol reads flat until its first update arrives.

## Synthesis mapping / what it stresses

- **BRAM:** the two per-side order-book RAMs (`NSYM*NLEVEL` deep) infer block
  RAM.
- **DSP / multipliers:** the imbalance-weighted fair value and the notional
  (`price*qty`) risk check infer hard multipliers.
- **Deep pipelined control + datapath:** six registered stages of decode,
  compare, mux, and accumulate exercise a realistic mixed control/arithmetic
  fabric and its FF/LUT balance and Fmax.

## References

### Algorithm / domain

- L. Harris, *Trading and Exchanges: Market Microstructure for Practitioners*,
  Oxford University Press, 2003. The limit order book, bid-ask spread, order
  imbalance, and market-making logic modeled by the feature/strategy stages.

### Hardware implementation

- C. Leber, B. Geib, H. Litz, "High Frequency Trading Acceleration using
  FPGAs," 21st Int. Conf. on Field Programmable Logic and Applications (FPL),
  2011. The FPGA tick-to-trade pipeline architecture (market-data decode ->
  decision -> order emission) this block follows.

### Provenance

Original implementation written for LogikBench, AI-assisted (see `ai.json`). It
follows the pipeline architecture in the references above and the block diagram
supplied by the author, and is not copied from any specific HDL source. The
message format is a generic, self-defined layout, not any proprietary exchange
protocol.

## Testbench

`testbench/test_hft_smoke.v` is a Verilog-2005 self-checking testbench. A
reference model mirrors all six stages and predicts each emitted order; because
the pipeline is in-order, a FIFO scoreboard compares predicted vs actual order
packets across the 6-cycle latency. It drives random messages and prints
`PASSED` / `FAILED`.
