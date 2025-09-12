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
|ramdp      | DW,AW        | RAM with two access ports
|ramsdp     | DW,SW        | RAM with one read port & one write port
|ramsp      | DW,SW        | RAM with one access ports
|ramspnc    | DW,AW        |
|regfile    | DW,AW,RP,WP  | Multi ported register file
|rom        | DW,AW        | ROM
