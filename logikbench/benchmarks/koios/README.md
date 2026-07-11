# Koios Benchmarks

Koios is a deep-learning (DL) benchmark suite released with the
Verilog-to-Routing (VTR) project. It targets FPGA architecture and CAD research
and collects RTL for a range of neural-network accelerators and layers -- CNNs,
RNNs, MLPs, and RL networks, covering fully-connected, convolution, activation,
softmax, reduction, and elementwise layers. The full upstream suite ("Koios
2.0") advertises 40 designs spread across two directories plus a small
SystemVerilog set.

The Koios files were copied into LogikBench (rather than linked) to keep the
benchmark set self-contained and reproducible, matching the treatment of the
other vendored suites (`epfl`, `iscas85`, `iscas89`). You can access the
original files here:

* Repository: https://github.com/verilog-to-routing/vtr-verilog-to-routing
* Upstream path: `vtr_flow/benchmarks/verilog/koios/`
* Documentation: https://docs.verilogtorouting.org/en/latest/vtr/benchmarks/
* Commit: `24b55a9f985dec53580960e37766fd655f94e643`
* Retrieved: 2026-07-11

## Origin and License

Koios is distributed under the same license as VTR. VTR's top-level
`LICENSE.md` places the project under the **MIT License** (Copyright 2012 VTR
Developers), noting that a few components (notably ABC and some benchmark
circuits) may carry their own terms; the Koios README itself states plainly
that "Koios benchmarks are distributed under the same license as VTR", so the
MIT terms apply here. The MIT text is vendored alongside this README as
`LICENSE`.

## Provenance and scope

LogikBench does **not** vendor the entire upstream suite. The 40-design count is
made up of:

* `vtr_flow/benchmarks/verilog/koios/` -- 29 synthesizable Verilog designs
  (33 `.v` files minus the three `*_include.v` macro toggles and `test.v`).
* `vtr_flow/benchmarks/verilog/koios_proxy/` -- 8 synthetic "proxy" designs
  (`proxy.1.v` .. `proxy.8.v`), each a large single generated file
  (635 KB to 4.3 MB).
* 3 SystemVerilog designs (ARM FixyNN "DeepFreeze", MobileNet layers) counted
  by the README but not present as standalone files in the pinned `master`.

We vendor a **core synthesizable subset of 19 designs**, all drawn from the
`koios/` directory. The selection excludes:

* The multi-megabyte "giant" designs whose synthesis time dominates a sweep:
  `lenet.v` (11 MB), `tdarknet_like.large.v` (6.6 MB),
  `tdarknet_like.small.v` (3.6 MB), and `bnn.v` (1.3 MB).
* Every `*.large` variant (`bwave_like.fixed.large`, `bwave_like.float.large`,
  `clstm_like.large`, `dla_like.large`, `tpu_like.large.os`,
  `tpu_like.large.ws`); the retained `*.small` / `*.medium` variants of the
  same families keep the design shapes represented at a tractable size.
* The entire `koios_proxy/` set (8 large synthetic designs).
* The 3 SystemVerilog DeepFreeze designs (absent from the pinned commit).

The `small` / `medium` / `large` suffixes are shipped upstream as separate
pre-generated files, so each is treated as its own benchmark (there is no
LogikBench parameter sweep for them). `os` / `ws` denote the output-stationary
and weight-stationary dataflows of the TPU-like accelerator.

## Naming

Each benchmark uses the bare upstream design name (the `koios` group already
namespaces it). Dots in the upstream filename become underscores so the name is
a valid Python module and class identifier (e.g. `tpu_like.small.ws.v` becomes
benchmark `tpu_like_small_ws`, class `TpuLikeSmallWs`).

## Pure-RTL (hard blocks disabled)

Koios designs can map their multipliers/MACs and memories either to dedicated
FPGA hard blocks or to behavioral RTL, selected by two Verilog macros:

* `complex_dsp` -- when defined, hard DSP macros (e.g. native FP16/BF16
  multiply, dedicated chains) are used; when undefined, the equivalent
  functionality is expressed in behavioral Verilog.
* `hard_mem` -- when defined, hard single-/dual-port BRAM primitives are
  instantiated; when undefined, memory is described behaviorally so the
  synthesis tool infers RAM.

Upstream, these macros are supplied by the flow, not by the design files: a
design contains no `` `include `` and instead reads `` `ifdef complex_dsp `` /
`` `ifndef hard_mem ``, while VTR's flow injects the macros with a header file
(`-include hard_block_include.v`, which defines both). The three toggle files
contain exactly:

* `complex_dsp_include.v` : `` `define complex_dsp ``
* `hard_mem_include.v`    : `` `define hard_mem ``
* `hard_block_include.v`  : `` `define complex_dsp `` and `` `define hard_mem ``

**LogikBench vendors every design as pure RTL: neither macro is ever defined.**
As a result the `` `ifdef complex_dsp `` branches are skipped (behavioral
`qmult` / `qadd` / `` * `` are used) and the `` `ifndef hard_mem `` branches are
taken (memory is behavioral and left for the target flow to infer). The VTR
hard-block primitives (`dual_port_ram`, `single_port_ram`, DSP macros) are
therefore never referenced, so no external primitive library is needed and the
designs synthesize standalone.

Because the designs do not `` `include `` the toggle files, those three files
are not vendored. Should any vendored design turn out to `` `include `` a toggle
file directly, an **empty stub** of that file is shipped in the design's `rtl/`
directory so the macro stays undefined (the empty-toggle policy; see
Modifications). DSP/BRAM inference is thus left entirely to the target synth
flow (yosys ASIC/FPGA), consistent with the rest of LogikBench.

## Timing constraints (SDC)

Koios designs are sequential. Their clock port names vary -- most use `clk`,
some add a second clock (`conv_layer`, `eltwise_layer`, and the `tpu_like`
designs have both `clk` and `clk_mem`), and a couple use an AXI-style name
(`conv_layer_hls` uses `ap_clk`, `gemm_layer` uses `s00_axi_aclk`). Every one of
these matches the `*clk*` port glob that LogikBench's shared
`logikbench/targets/default.sdc` uses to auto-detect clocks, and that file
creates one real clock per detected port at the `--clk` period -- so multi-clock
designs are fully constrained and no per-benchmark SDC is required. Resets
(e.g. `resetn`, `pe_resetn`) are asynchronous and carry no timing constraint.

## Benchmark Listing

| Benchmark                      | Upstream file                 | Description                                             |
|--------------------------------|-------------------------------|---------------------------------------------------------|
| `attention_layer`        | `attention_layer.v`           | Transformer self-attention layer                        |
| `conv_layer`             | `conv_layer.v`                | GEMM-based convolution layer                            |
| `conv_layer_hls`         | `conv_layer_hls.v`            | Sliding-window convolution (HLS style)                  |
| `eltwise_layer`          | `eltwise_layer.v`             | Matrix elementwise add / sub / mult                     |
| `reduction_layer`        | `reduction_layer.v`           | Add / max / min reduction tree                          |
| `gemm_layer`             | `gemm_layer.v`                | 20x20 matrix-multiplication engine                      |
| `softmax`                | `softmax.v`                   | Softmax classification layer                            |
| `spmv`                   | `spmv.v`                      | Sparse matrix-vector multiplication                     |
| `lstm`                   | `lstm.v`                      | LSTM engine                                             |
| `robot_rl`               | `robot_rl.v`                  | Reinforcement-learning robot / maze application         |
| `dnnweaver`              | `dnnweaver.v`                 | DNNWeaver-like accelerator                              |
| `tpu_like_small_os`      | `tpu_like.small.os.v`         | Google-TPU-v1-like accelerator (small, output-stationary) |
| `tpu_like_small_ws`      | `tpu_like.small.ws.v`         | Google-TPU-v1-like accelerator (small, weight-stationary) |
| `clstm_like_small`       | `clstm_like.small.v`          | CLSTM-like accelerator (small)                          |
| `clstm_like_medium`      | `clstm_like.medium.v`         | CLSTM-like accelerator (medium)                         |
| `dla_like_small`         | `dla_like.small.v`            | Intel-DLA-like accelerator (small)                      |
| `dla_like_medium`        | `dla_like.medium.v`           | Intel-DLA-like accelerator (medium)                     |
| `bwave_like_fixed_small` | `bwave_like.fixed.small.v`    | Microsoft-Brainwave-like NPU (fixed-point, small)       |
| `bwave_like_float_small` | `bwave_like.float.small.v`    | Microsoft-Brainwave-like NPU (floating-point, small)    |

## Top modules

The RTL is byte-verbatim, so each design keeps its upstream top-module name,
which differs from the bare design name for the generically-named designs --
`top` is the top module of four designs, and `NPU`, `DLA`, and `C_LSTM_datapath`
are each shared by two (harmless: the `koios` group namespaces the benchmarks,
and they are never elaborated together). Each Design sets its top explicitly,
recovered by finding in each file the one declared module never instantiated:

| Benchmark                          | Top module (upstream)        |
|------------------------------------|------------------------------|
| `attention_layer`            | `attention_layer` |
| `bwave_like_fixed_small`     | `NPU`             |
| `bwave_like_float_small`     | `NPU`             |
| `clstm_like_small` / `_medium` | `C_LSTM_datapath` |
| `conv_layer`                 | `conv_layer`      |
| `conv_layer_hls`             | `top`             |
| `dla_like_small` / `_medium` | `DLA`             |
| `dnnweaver`                  | `cl_wrapper`      |
| `eltwise_layer`              | `eltwise_layer`   |
| `gemm_layer`                 | `gemm_layer`      |
| `lstm`                       | `top`             |
| `reduction_layer`            | `reduction_layer` |
| `robot_rl`                   | `robot_maze`      |
| `softmax`                    | `softmax`         |
| `spmv`                       | `spmv`            |
| `tpu_like_small_os` / `_ws`  | `top`             |

## Pure-RTL synthesizability (verified)

The pure-RTL claim was checked statically against the vendored files before
import, not just assumed:

* **No `` `include ``.** None of the 19 designs contains an `` `include ``
  directive, so nothing pulls in a macro toggle; `complex_dsp` / `hard_mem` are
  simply never defined.
* **No surviving hard-block.** Simulating the Verilog preprocessor with
  `complex_dsp`, `hard_mem`, and `QUARTUS` all undefined, no `single_port_ram` /
  `dual_port_ram` hard-block instantiation survives in any design -- every such
  reference sits behind `` `ifdef hard_mem ``. (The lone apparent hit, a
  `single_port_ram` token in `dnnweaver.v`, is a commented-out line.)

With hard blocks off, memory is behavioral (synth-inferred RAM) and the
arithmetic uses behavioral `qmult` / `qadd`, so every design elaborates
standalone with no undefined modules -- exactly the soft mapping LogikBench
wants to benchmark.

## Excluded from LogikBench

Documented here so the omission is explicit rather than silent:

| Upstream file / dir            | Size    | Reason                              |
|--------------------------------|---------|-------------------------------------|
| `lenet.v`                      | 11 MB   | Giant single-file design            |
| `tdarknet_like.large.v`        | 6.6 MB  | Giant single-file design            |
| `tdarknet_like.small.v`        | 3.6 MB  | Giant single-file design            |
| `bnn.v`                        | 1.3 MB  | Giant single-file design            |
| `bwave_like.fixed.large.v`     | 346 KB  | `*.large` variant (small kept)      |
| `bwave_like.float.large.v`     | 1.0 MB  | `*.large` variant (small kept)      |
| `clstm_like.large.v`           | 870 KB  | `*.large` variant (small/med kept)  |
| `dla_like.large.v`             | 1.9 MB  | `*.large` variant (small/med kept)  |
| `tpu_like.large.os.v`          | 672 KB  | `*.large` variant (small kept)      |
| `tpu_like.large.ws.v`          | 1.4 MB  | `*.large` variant (small kept)      |
| `koios_proxy/proxy.1-8.v`      | ~17 MB  | Synthetic proxy set (all large)     |
| DeepFreeze (SystemVerilog x3)  | n/a     | Not present in the pinned `master`  |

## Modifications

Changes LogikBench made to the upstream Koios files, documented for provenance.
Except for the three lint fixes noted below, RTL content is byte-verbatim,
including the upstream top-module names.

1. **RTL file renamed** to the bare design name with dots turned into
   underscores (e.g. `tpu_like.small.ws.v` becomes `tpu_like_small_ws.v`); the
   file contents, including the top-module name, are unchanged. The upstream
   file name is retained in the Benchmark Listing table above.
2. **Macro toggle files not vendored.** `complex_dsp_include.v`,
   `hard_mem_include.v`, and `hard_block_include.v` only serve to turn hard
   blocks on; LogikBench leaves both macros undefined (pure RTL), so these files
   are not copied. If a design were to `` `include `` one directly, an empty stub
   is shipped so the macro stays undefined.
3. **Lint fixes (three designs).** Koios RTL is Verilog-2005 (VTR compiles it
   single-file with a lenient front-end); a few files are not clean under
   LogikBench's strict SystemVerilog lint (slang), so they were patched
   minimally, logic unchanged:
   - `attention_layer`: the `softmax` instance named `soft` was renamed to
     `soft_u` (`soft` is a reserved SV keyword, invalid as an instance name).
   - `conv_layer_hls`: a `` `timescale 1 ns / 1 ps `` directive was added at the
     top so the `dpram` module has a timescale like the others (slang errors on
     a design with mixed timescale coverage).
   - `dnnweaver`: a stale `$readmemh(INIT, mem, ...)` FIFO-init line was
     commented out -- its `mem` array is already commented out upstream, so the
     line referenced an undeclared signal.

## How to Cite

If you use the Koios benchmarks, please cite the original work:

A. Arora, A. Boutros, D. Rauch, A. Rajen, A. Borda, S. A. Damghani, S. Mehta,
S. Kate, P. Patel, K. B. Kent, V. Betz, and L. K. John, "Koios: A Deep Learning
Benchmark Suite for FPGA Architecture and CAD Research," International Conference
on Field Programmable Logic and Applications (FPL), 2021.

```
@inproceedings{koios_benchmarks,
  title={Koios: A Deep Learning Benchmark Suite for FPGA Architecture and CAD Research},
  author={Arora, Aman and Boutros, Andrew and Rauch, Daniel and Rajen, Aishwarya and Borda, Aatman and Damghani, Seyed A. and Mehta, Samidh and Kate, Sangram and Patel, Pragnesh and Kent, Kenneth B. and Betz, Vaughn and John, Lizy K.},
  booktitle={International Conference on Field Programmable Logic and Applications (FPL)},
  year={2021}
}
```
