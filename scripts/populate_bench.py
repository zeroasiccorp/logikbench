import os

logic = ["arbiter",
         "bxor",
         "bxnor",
         "band",
         "bnand",
         "gray",
         "mux",
         "onehot",
         "pipeline",
         "priority",
         "rstasync",
         "rstsync",
         "shiftreg",
         "xbar"]

memory = ["cam",
          "fifoasync",
          "fifosync",
          "rambm",
          "ramdist",
          "ramdp",
          "ramsdp",
          "ramsp",
          "regfile",
          "rom",
          ]

arithmetic = ["abs",
              "absdiff",
              "add",
              "addsub",
              "csa",
              "cordic",
              "dotprod",
              "incr",
              "max",
              "min",
              "mul",
              "muladd",
              "mulc",
              "mulreg",
              "muls",
              "relu",
              "round",
              "shifl",
              "shiftb",
              "shiftr",
              "sine",
              "sub",
              "sqdiff",
              "sqrt",
              "sum"
              ]

cores = ["aes",
         "apbdev",
         "axihost",
         "axidev",
         "axixbar",
         "conv2d",
         "counter",
         "crc32",
         "en8b10b",
         "ethmac",
         "fftc",
         "fftr",
         "fir",
         "fpu32",
         "fpu34",
         "hamming",
         "ialu",
         "ibex",
         "l1cache",
         "lfsr",
         "mac",
         "matmul",
         "median3x3",
         "ofdm",
         "picorv32",
         "rv32dec",
         "sad8x8",
         "serv",
         "sobel3x3",
         "spi",
         "uart",
         "viterbi"]

all_marks = logic + arithmetic + cores + memory

for name in all_marks:
    if name in logic:
        group = "logic"
    elif name in arithmetic:
        group = "arithmetic"
    elif name in memory:
        group = "memory"
    elif name in cores:
        group = "cores"
    dir_path = os.path.join("logikbench", group, name, "rtl")
    os.makedirs(dir_path, exist_ok=True)
    file_path = os.path.join(dir_path, f"{name}.v")
    if not os.path.exists(file_path):
        with open(file_path, "w") as f:
            f.write(f"module {name}();\n//complete code\nendmodule\n")
    else:
        print(f"File already exists: {file_path}")
