# Summary

Ara, the PULP platform RISC-V vector unit (RVV 1.0), configured with
NrLanes = 2 and VLEN = 4096 bits. Only the vector unit (`ara`) is included;
the CVA6 scalar core is not instantiated.

# Source

Pickled (preprocessed single-file) RTL generated with
[bender](https://github.com/pulp-platform/bender) +
[morty](https://github.com/pulp-platform/morty) from
[pulp-platform/ara](https://github.com/pulp-platform/ara), top module
`ara_wrap`.

# Modifications

- Added a thin wrapper `ara_wrap` (package + module) that fixes the
  configuration (NrLanes = 2, VLEN = 4096) and builds the AXI and CVA6
  accelerator interface struct types, mirroring `ara_soc.sv` /
  `ara_system.sv`, then instantiates bare `ara`. This replaces the
  unsynthesizable defaults (NrLanes = 0, VLEN = 0, `type ... = logic`).
- Pickled with `morty --top ara_wrap`, which strips everything outside the
  vector-unit hierarchy (CVA6 core, SoC, peripherals).
- CVA6 base config target: `cv64a6_imafdc_sv39`.

# Versions (Bender.lock, exact)

| Package | Repo | Revision |
|---------|------|----------|
| ara | pulp-platform/ara | ab4158aeeb552a5b6f9aebed7fca0e51aa003534 |
| apb | pulp-platform/apb | 77ddf073f194d44b9119949d2421be59789e69ae |
| axi | pulp-platform/axi | 853ede23b2a9837951b74dbdc6d18c3eef5bac7d |
| common_cells | pulp-platform/common_cells | c27bce39ebb2e6bae52f60960814a2afca7bd4cb |
| common_verification | pulp-platform/common_verification | 9c07fa860593b2caabd9b5681740c25fac04b878 |
| cva6 | pulp-platform/cva6 | 99eac9a649001bdf5b8f9da52e0ca73d5c48db1c |
| fpnew (cvfpu) | pulp-platform/cvfpu | e5aa6a01b5bbe1675c3aa8872e1203413ded83d1 |
| fpu_div_sqrt_mvp | pulp-platform/fpu_div_sqrt_mvp | 86e1f558b3c95e91577c41b2fc452c86b04e85ac |
| tech_cells_generic | pulp-platform/tech_cells_generic | 7968dd6e6180df2c644636bc6d2908a49f2190cf |

# License

Solderpad Hardware License v0.51 (see `LICENSE`).
