# Large Benchmarks

The `large` benchmarks are the biggest designs in LogikBench -- full CPUs, SoCs,
GPUs, and deep-learning accelerators that dominate synthesis time. They were
split out of the `blocks` group so routine sweeps over `blocks` stay fast; run
the heavy set explicitly with `-g large`.

## Selection

Designs were moved here by synthesis cost, not source size: every design whose
yosys FPGA synthesis time (`virtex7`, `lb syn`) exceeded ~285 s -- a cluster
cleanly separated from the next design at ~160 s. (Synthesis time, not RTL
bytes, is the criterion: e.g. `wally` has small RTL but elaborates to a large
design, while `aes` has large RTL but a shorter run.)

Designs added since the original split -- full CPU cores, accelerators, and
parametrized generators (e.g. `sonicboom`, `nvdlafull`, `tpu`, `bitcoin`) -- are
placed here directly when they clearly belong to this size class, rather than by
re-applying the synthesis-time threshold.

## Benchmark listing

| Benchmark   | Description                                          |
|-------------|------------------------------------------------------|
| aes         | AES encryption core                                  |
| axicrossbar | AXI crossbar                                         |
| bitcoin     | SHA256d proof-of-work miner (uses sha256)            |
| blackparrot | BlackParrot RISC-V core                              |
| coralnpu    | CoralNPU neural accelerator                          |
| cva6        | CVA6 (Ariane) RISC-V core                            |
| lz77        | LZ77 (LZSS) compressor/decompressor                  |
| nvdlafull   | NVDLA accelerator (nv_full, 2048 MACs)               |
| nvdlasmall  | NVDLA accelerator (nv_small)                         |
| ofdm        | OFDM modem (QAM + IFFT/FFT)                          |
| qr          | QR decomposition solver (CORDIC/Givens systolic)     |
| rocket      | Rocket RISC-V core                                   |
| sonicboom   | SonicBOOM (BOOM v3) out-of-order RISC-V core         |
| tpu         | Weight-stationary systolic matrix multiply (TPU MXU) |
| vortex      | Vortex GPU core                                      |
| wally       | CVW-Wally RISC-V core                                |

Provenance, license, and source history for each design live in its own
`<name>/README.md` (moved intact from `blocks`).

## Stretch goal: coralnpu

`coralnpu` is a stretch goal: it does not finish flat FPGA synthesis within the
default `--timeout`, so its result is `null`. It is the largest design in the
suite; recording a number needs a much larger `--timeout`.
