# Arithmetic Benchmarks

| Circuit                  | Params        | Description                          |
|--------------------------|---------------|--------------------------------------|
| [abs](abs)               | DW            | Absolute value
| [absdiff](absdiff)       | DW            | Absolute difference
| [absdiffs](absdiffs)     | DW            | Absolute difference (signed)
| [add](add)               | DW            | Adder
| [addmod](addmod)         | DW            | Modular adder
| [addsub](addsub)         | DW            | Adder / subtractor
| [addtree](addtree)       | N,DW          | Adder tree (N inputs)
| [argmax](argmax)         | N,DW          | Argmax (index of maximum)
| [argmin](argmin)         | N,DW          | Argmin (index of minimum)
| [atan](atan)             | DW,QW,N       | Arctangent
| [avgn](avgn)             | N,DW          | Average of N inputs
| [clamp](clamp)           | DW            | Clamp / saturate
| [clz](clz)               | DW            | Count leading zeros
| [cmp](cmp)               | DW            | Comparator
| [cos](cos)               | DW,QW,N       | Cosine
| [counter](counter)       | DW            | Counter
| [csa32](csa32)           | DW            | 3:2 carry-save adder
| [csa42](csa42)           | DW            | 4:2 carry-save adder
| [ctz](ctz)               | DW            | Count trailing zeros
| [dec](dec)               | DW            | Decrementer
| [div](div)               | DW            | Unsigned divider
| [divs](divs)             | DW            | Signed divider
| [dotprod](dotprod)       | N,DW          | Dot product (N-element)
| [exp](exp)               | DW,QW         | Exponential
| [fmadd8](fmadd8)         |               | fp8 (E4M3) fused multiply-add
| [fmadd16](fmadd16)       |               | bf16 fused multiply-add
| [fmadd32](fmadd32)       | EXP,MANT      | fp32 fused multiply-add
| [gelu](gelu)             | DW,QW         | GELU activation
| [hswish](hswish)         | DW,QW         | Hard-swish activation
| [inc](inc)               | DW            | Incrementer
| [ln](ln)                 | DW,QW         | Natural logarithm
| [log2](log2)             | DW            | Integer base-2 logarithm
| [lrelu](lrelu)           | DW,ASHIFT     | Leaky ReLU activation
| [mac](mac)               | DW,OW         | Multiply-accumulate
| [macc](macc)             | DW,OW         | Complex multiply-accumulate
| [macs](macs)             | DW,ACCW       | Signed multiply-accumulate
| [max](max)               | DW            | Maximum (2-input)
| [maxn](maxn)             | N,DW          | Maximum of N inputs
| [min](min)               | DW            | Minimum (2-input)
| [mod](mod)               | DW            | Unsigned modulo / remainder
| [msub](msub)             | DW,OW         | Multiply-subtract (a*b - c)
| [mul](mul)               | DW,OW         | Unsigned multiplier
| [muladd](muladd)         | DW,OW         | Multiply-add (a*b + c)
| [muladdc](muladdc)       | DW,OW         | Complex multiply-add
| [muladds](muladds)       | DW,OW         | Signed multiply-add
| [mulc](mulc)             | DW            | Complex multiplier
| [mulreg](mulreg)         | DW,OW         | Registered multiplier
| [muls](muls)             | DW,OW         | Signed multiplier
| [mulsu](mulsu)           | DW,OW         | Signed x unsigned multiplier
| [multconst](multconst)   | DW,OW         | Multiply by constant
| [popcount](popcount)     | DW            | Population count
| [premul](premul)         | DW,OW         | Pre-adder multiplier ((a+d)*b)
| [recip](recip)           | DW,QW         | Reciprocal (1/x)
| [relu](relu)             | DW            | ReLU activation
| [requant](requant)       | IW,MW,SHW,OW  | Requantize (multiply by scale, shift)
| [rotl](rotl)             | DW            | Rotate left
| [rotr](rotr)             | DW            | Rotate right
| [round](round)           | DW,FW         | Fixed-point round
| [rsqrt](rsqrt)           | DW,QW         | Inverse square root (1/sqrt(x))
| [shiftar](shiftar)       | DW            | Arithmetic shift right
| [shiftb](shiftb)         | DW            | Barrel shifter
| [shiftl](shiftl)         | DW            | Shift left
| [shiftr](shiftr)         | DW            | Logical shift right
| [sigmoid](sigmoid)       | DW,QW         | Sigmoid activation
| [simdmul](simdmul)       | DW,N          | SIMD packed multiplier (N lanes)
| [sine](sine)             | DW            | Sine
| [sqdiff](sqdiff)         | DW            | Squared difference ((a-b)^2)
| [sqrt](sqrt)             | DW            | Unsigned square root
| [sub](sub)               | DW            | Subtractor
| [sum](sum)               | N,DW          | Sum of N inputs
| [tanh](tanh)             | DW,QW         | Tanh activation
