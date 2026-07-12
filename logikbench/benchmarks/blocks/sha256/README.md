# sha256

**Source:** [rtl/sha256.v](rtl/sha256.v)

A SHA-256 (and SHA-224) secure hash core with a 32-bit register/bus interface,
from the secworks project.

## What it is

`sha256` implements the FIPS 180-4 SHA-256 compression over 512-bit message
blocks, producing a 256-bit digest. Padding/length must be applied by the host;
the core hashes pre-formed blocks. The `mode` bit selects SHA-256 or SHA-224.

## Circuit

```
sha256                top: clk/reset_n + 32-bit register bus
                      (cs, we, address[7:0], write_data, read_data, error)
+- sha256_core        init/next/mode, block[511:0] -> digest[255:0], ready
   +- sha256_k_constants   round -> 32-bit round constant K (constant ROM)
   +- sha256_w_mem         512-bit block -> per-round message schedule word W
```

The host writes a block to registers `BLOCK0..BLOCK15` (`0x10..0x1f`), pulses
`CTRL.init` (`0x08`), polls `STATUS.ready` (`0x09`), then reads the digest from
`DIGEST0..DIGEST7` (`0x20..0x27`).

## RTL Sources

- author: Joachim Strombergson (secworks)
- repo: https://github.com/secworks/sha256
- branch: master
- commit: 837c5cc396f001d18f2c765721c585716eb439ae

The four RTL files are vendored verbatim under `rtl/`; the design is
self-contained (no external includes or dependencies).

## Testbench

`testbench/test_sha256_smoke.v` is a self-checking smoke test (`lb sim`): it
drives the register interface to hash the NIST single-block "abc" message and
compares the digest against the known SHA-256 value
(`ba7816bf...f20015ad`), printing `PASSED` or `FAILED`. The vector is taken
from the upstream testbench; the smoke test follows the LogikBench convention
(clock-edge stimulus, self-check, deterministic finish with a watchdog).

## License

- BSD 2-Clause (see `LICENSE`); Copyright (c) 2013, Joachim Strombergson.

## How to Cite

```
secworks/sha256 -- SHA-256 hardware core, Joachim Strombergson.
https://github.com/secworks/sha256
```

## References

* FIPS PUB 180-4, "Secure Hash Standard (SHS)," National Institute of Standards
  and Technology, Aug. 2015. DOI: 10.6028/NIST.FIPS.180-4.
