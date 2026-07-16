# Memory Benchmarks

| Circuit                | Params        | Description                            |
|------------------------|---------------|----------------------------------------|
| [cache](cache)         | DW,AW,INDEXW  | Set-associative cache
| [cam](cam)             | DW,AW         | Content-addressable memory
| [fifoasync](fifoasync) | DW,AW         | Asynchronous (dual-clock) FIFO
| [fifosync](fifosync)   | DW,AW         | Synchronous FIFO
| [ramasync](ramasync)   | DW,AW         | Single-port RAM, async read
| [rambit](rambit)       | DW,AW         | Single-port RAM, per-bit write mask
| [rambyte](rambyte)     | DW,AW         | Single-port RAM, per-byte write mask
| [raminit](raminit)     | DW,AW         | Single-port RAM, preloaded contents
| [ramsdp](ramsdp)       | DW,AW         | Simple dual-port RAM (1 write, 1 read)
| [ramsp](ramsp)         | DW,AW         | Single-port RAM
| [ramspnc](ramspnc)     | DW,AW         | Single-port RAM, no-change read-during-write
| [ramsprf](ramsprf)     | DW,AW         | Single-port RAM, read-first read-during-write
| [ramspwf](ramspwf)     | DW,AW         | Single-port RAM, write-first read-during-write
| [ramtdp](ramtdp)       | DW,AW         | True dual-port RAM
| [ramtdpdc](ramtdpdc)   | DW,AW         | True dual-port RAM, dual clock
| [regfile](regfile)     | AW,DW,RP,WP   | Multi-port register file
| [rom](rom)             | DW,AW         | Read-only memory
