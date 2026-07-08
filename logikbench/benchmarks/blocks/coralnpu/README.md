# Summary

**Source:** [rtl/coralnpu.sv](rtl/coralnpu.sv)

Coral NPU Chisel subsystem (`CoralNPUChiselSubsystem`), a machine-learning
accelerator core from Google's Coral NPU project.

# Source

Pickled (preprocessed single-file) RTL imported from
[scgallery](https://github.com/siliconcompiler/scgallery), generated from
[google-coral/coralnpu](https://github.com/google-coral/coralnpu)
(`commit f33009468522a4d6f9845884a8c4c694e25c2997`) together with primitives
from [lowRISC/opentitan](https://github.com/lowRISC/opentitan)
(`commit f3b46add62acc0332e2d2d59d37298cf8cfb4d24`).

# Modifications

- Flattened to a single pickled file (`rtl/coralnpu.sv`).
- Added a lambda shim (`rtl/lambda.v`) mapping the hard memories onto
  lambdalib `Spram`.

# License

Apache-2.0 (see `LICENSE`); both upstream sources are Apache-2.0.
