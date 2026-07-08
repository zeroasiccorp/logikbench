# Summary

**Source:** [rtl/cva6.sv](rtl/cva6.sv)

CORE-V CVA6 application-class RISC-V core, configured as `cv64a6_imafdc_sv39`
(RV64IMAFDC, sv39 MMU, write-through cache), pickled into a single
self-contained Verilog file with FPU (cvfpu) and generic tech cells.

# Source

- author: OpenHW Group
- repo: https://github.com/openhwgroup/cva6
- tag: v5.3.0
- commit: 2ef1c1b1fca419354920c5487293bc605294904e
- Bender deps: axi 0.31.0, common_cells 1.23.0, cvfpu (106251e),
  tech_cells_generic 0.2.13

# License

Solderpad Hardware License v0.51 (see `LICENSE`).

# Verilog Generation

CVA6 is Bender-managed SystemVerilog. The single `rtl/cva6.sv` was produced
with bender + morty:

```
git clone -b v5.3.0 https://github.com/openhwgroup/cva6.git
cd cva6 && bender checkout
# resolved filelist for the 64-bit config + synthesis target
bender script flist-plus -t cv64a6_imafdc_sv39 -t synthesis > cva6.flist
# convert (+incdir+ -> -I, +define+ -> -D, files positional) and pickle
morty <args> --top cva6 -o rtl/cva6.sv
```

# Modifications (applied to the Bender sources before pickling)

morty's SystemVerilog parser and the Bender synthesis flist required a few
adjustments; none change the synthesized logic:

- `core/cva6.sv`: rewrote the HPDCACHE-select `CVA6Cfg.DCacheType inside {...}`
  in a generate-`if` to equivalent `==`/`||` (morty's parser rejects `inside`
  in a generate condition). The write-through config takes the other branch
  regardless.
- `common/local/util/sram.sv`: stripped the `// synthesis translate_off` /
  `translate_on` simulation-only block (morty rejected its nested named
  blocks). Synthesis ignores translate_off regions anyway.
- `core/cva6.sv`: flipped the behavioral instruction-tracer guard from
  `` `ifndef VERILATOR `` to `` `ifdef VERILATOR `` so the DV-only
  `instr_tracer` is not instantiated (it is not hardware).
- Added 5 RTL files that the Bender synthesis flist omitted but the core
  instantiates: `pmp_data_if.sv`, `cva6_shared_tlb.sv`,
  `cvxif_compressed_if_driver.sv`, `cvxif_issue_register_commit_if_driver.sv`,
  and the cache SRAM wrapper `sram_cache.sv`.

CVXIF and RVFI are off in this config; the AXI (noc) memory interface is the
top-level struct port set. No wrapper is needed (cva6's ports are plain/struct).
