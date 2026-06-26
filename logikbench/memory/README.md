# Memory Benchmarks

| Circuit   | Params       | Description             |
|-----------|--------------|-------------------------|
|axiram     | DW,AW        | Axi lite connected spram
|cache      | DW,AW,INDEXW | Direct mapped cache
|fifoasync  | DW,AW        | Asynchronous FIFO
|fifosync   | DW,AW        | Synhcronous FIFO
|ramasync   | DW,AW        | RAM with asynchronous read
|rambit     | DW,AW        | RAM with write bit mask
|rambyte    | DW,AW        | RAM with write byte mask
|ramsdp     | DW,AW        | Simple dual-port RAM (1 write port + 1 read port)
|ramsp      | DW,AW        | RAM with one access port
|ramspnc    | DW,AW        | Single-port RAM, no-change read
|ramtdp     | DW,AW        | True dual-port RAM (two read/write ports)
|regfile    | DW,AW,RP,WP  | Multi ported register file
|rom        | DW,AW        | ROM
