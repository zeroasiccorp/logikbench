# Summary

AES (DOM-masked default config). OpenTitan comportable IP (`aes`), pickled into a single
self-contained Verilog file with generic technology primitives.

# Source

- author: lowRISC (OpenTitan project)
- repo: https://github.com/lowRISC/opentitan
- branch: master
- commit: fc79657331cdea51cd59da2d56653202816e736c
- core: `lowrisc:ip:aes:1.0`

# License

Apache-2.0 (see `LICENSE`).

# Verilog Generation

OpenTitan IP are FuseSoC-managed SystemVerilog (TileLink-UL struct ports, `prim_*`
technology primitives selected via FuseSoC virtual cores). The single
`rtl/aes.sv` was generated with FuseSoC (==2.4.5) + morty:

```
git clone https://github.com/lowRISC/opentitan.git   # commit fc79657331cdea51cd59da2d56653202816e736c
# resolve the synth filelist with GENERIC prim implementations
fusesoc --cores-root opentitan run --target=default --tool=icarus --setup \
        --mapping=lowrisc:prim_generic:all:0.1 lowrisc:ip:aes:1.0
# convert the generated *.scr (+incdir+ -> -I, files as positional) and pickle
morty <args from .scr> --top aes -o rtl/aes.sv
```

The default virtual `top_pkg`/`top_racl_pkg` (earlgrey constants) are used.
The struct TL-UL / alert / RACL / ram_cfg ports become plain top-level ports
(no wrapper needed).

# Configuration

DOM-masked AES (OpenTitan default): secure masking with EDN entropy. The EDN
and keymgr key-sideload struct ports are top-level (tied off externally).
