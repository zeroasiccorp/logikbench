# Summary

SPI host. OpenTitan comportable IP (`spi_host`), pickled into a single
self-contained Verilog file with generic technology primitives.

# Source

- author: lowRISC (OpenTitan project)
- repo: https://github.com/lowRISC/opentitan
- branch: master
- commit: fc79657331cdea51cd59da2d56653202816e736c
- core: `lowrisc:ip:spi_host:1.0`

# License

Apache-2.0 (see `LICENSE`).

# Verilog Generation

OpenTitan IP are FuseSoC-managed SystemVerilog (TileLink-UL struct ports, `prim_*`
technology primitives selected via FuseSoC virtual cores). The single
`rtl/spi.sv` was generated with FuseSoC (==2.4.5) + morty:

```
git clone https://github.com/lowRISC/opentitan.git   # commit fc79657331cdea51cd59da2d56653202816e736c
# resolve the synth filelist with GENERIC prim implementations
fusesoc --cores-root opentitan run --target=default --tool=icarus --setup \
        --mapping=lowrisc:prim_generic:all:0.1 lowrisc:ip:spi_host:1.0
# convert the generated *.scr (+incdir+ -> -I, files as positional) and pickle
morty <args from .scr> --top spi_host -o rtl/spi.sv
```

The default virtual `top_pkg`/`top_racl_pkg` (earlgrey constants) are used.
The struct TL-UL / alert / RACL / ram_cfg ports become plain top-level ports
(no wrapper needed).

# Modifications

- `spi_host_fsm.sv` uses the `\`ASSERT` macros but does not itself
  `\`include "prim_assert.sv"` (it relies on OpenTitan's single-unit
  compilation where the macro leaks in from another file). morty preprocesses
  each file independently, so the include was added before pickling. The
  `\`ASSERT` macros are simulation/formal-only and synthesize to nothing;
  there is no logic impact.
