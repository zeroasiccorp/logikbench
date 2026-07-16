# Basic Benchmarks

| Circuit              | Params    | Description             |
|----------------------|-----------|-------------------------|
| [arbiter](arbiter)   | N         | Request priority arbiter
| [band](band)         | DW        | And gate
| [bin2gray](bin2gray) | DW        | Binary to gray converter
| [bin2prio](bin2prio) | DW        | Binary to onehot converter
| [binv](binv)         | DW        | Inverter
| [bnand](bnand)       | DW        | Nand gate
| [bnor](bnor)         | DW        | Nor gate
| [bor](bor)           | DW        | Or gate
| [bxnor](bxnor)       | DW        | Xnor gate
| [bxor](bxor)         | DW        | Xor gate
| [crossbar](crossbar) | DW,N      | Connection crossbar
| [dffasync](dffasync) | DW        | Flipflop with async reset
| [dffsync](dffsync)   | DW        | Flipflop with sync reset
| [fsm](fsm)           | STATES,DW | Finite state machine
| [gray2bin](gray2bin) | DW        | Gray to binary converter
| [icg](icg)           | DW        | Integrated clock gate
| [latch](latch)       | DW        | Level-sensitive latch
| [mux](mux)           | DW,N      | Mux
| [muxcase](muxcase)   | DW        | 8:1 case style mux
| [muxhot](muxhot)     | DW,N      | Onehot mux
| [muxpri](muxpri)     | DW,N      | Priority mux
| [onehot](onehot)     | DW        | Onehot encoder
| [pipeline](pipeline) | DW,N      | Synchronous data pipeline
| [shiftreg](shiftreg) | DW        | Shift register
| [tff](tff)           | DW        | Toggle flipflop
| [tmr](tmr)           | DW        | Triple modular redundancy voter
