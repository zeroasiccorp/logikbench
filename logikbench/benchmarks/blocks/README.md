# Block Benchmarks

The `block` benchmarks are a collection of carefully curated high quality open source designs selected to create a diverse and carefully weighted benchmark.

Each benchmark circuit includes information about the author, license, and source code history.

## Benchmark listing

| Circuit       | Params      | Ready  | Description     |
|---------------|-------------|--------|-----------------|
| aes           | n/a         | Y      | 128b AES cipher
| apbregs       | DW,AW       | Y      | APB register file
| axicrossbar   | DW,AW,NM,NS | Y      | AXI crossbar
| axidev        | DW,AW       |        | AXI device
| axihost       | DW,AW       |        | AXI host
| conv2d        | DW, N       |        | 2D convolution filter
| en8b10b       |             |        | 8b10b encoder
| ethmac        | DW          | Y      | Ethernet MAC
| fft           | DW, N       |        | Streaming FFT
| firfix        | DW,ACCW,N   | Y      | Fixed FIR filter
| firprog       | DW,ACCW,N   | Y      | Programmable FIR filter
| fpu32         |             | Y      | Single precision FPU
| fpu64         |             |        | Double precision FPU
| hamming       |             |        |
| i2c           |             | Y      | I2C controller
| ialu          | DW          | Y      | Multi-function IALU
| ibex          |             |        | 32b RISC-V CPU
| lfsr          | DW,LFSRW    | Y      | Configurable LFSR
| matmul        | DW          |        | Systolic array matmul
| median3x3     | DW          |        | 2D median filter
| ofdm          |             |        |
| picorv32      |             | Y      | 32b RISC-V CPU
| sad8x8        | DW          |        | 2D SAD filter
| serv          |             | Y      | Bit serial CPU
| sobel3x3      | DW          |        | 2D sobel filter
| spi           |             |        | SPI controller
| uart          |             | Y      | Uart controller
| umiregs       |             | Y      | UMI register file
| viterbi       |             |        | Viterbi coprocessor
