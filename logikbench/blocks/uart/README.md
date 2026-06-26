# Summary

UART. OpenTitan comportable IP (`uart`), pickled into a single self-contained
Verilog file with generic technology primitives.

# Source

- author: lowRISC (OpenTitan project)
- repo: https://github.com/lowRISC/opentitan
- branch: master
- commit: fc79657331cdea51cd59da2d56653202816e736c
- core: `lowrisc:ip:uart:0.1`

# License

Apache-2.0 (see `LICENSE`).

# Verilog Generation

OpenTitan IP are FuseSoC-managed SystemVerilog (TileLink-UL struct ports, `prim_*`
technology primitives selected via FuseSoC virtual cores). The single
`rtl/uart.sv` was generated with FuseSoC (==2.4.5) + morty:

```
git clone https://github.com/lowRISC/opentitan.git   # commit fc79657331cdea51cd59da2d56653202816e736c
# resolve the synth filelist with GENERIC prim implementations
fusesoc --cores-root opentitan run --target=default --tool=icarus --setup \
        --mapping=lowrisc:prim_generic:all:0.1 lowrisc:ip:uart:0.1
# convert the generated *.scr (+incdir+ -> -I, files as positional) and pickle
morty <args from .scr> -D SYNTHESIS=1 --top uart -o rtl/uart.sv
```

The default virtual `top_pkg`/`top_racl_pkg` (earlgrey constants) are used.
The struct TL-UL / alert / RACL / ram_cfg ports become plain top-level ports
(no wrapper needed).

The `-D SYNTHESIS=1` define drops the OpenTitan `prim_assert` SVA (the `prim_alert_sender` async path declares named `sequence`s under `\`ifdef INC_ASSERT`, which the synthesis slang frontend does not support); functional RTL is unchanged.
