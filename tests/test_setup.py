from logikbench import *

def test_basic_setup():
    for item in [Arbiter(),
                 Band(),
                 Bbuf(),
                 Bin2gray(),
                 Bin2prio(),
                 Binv(),
                 Bnand(),
                 Bnor(),
                 Bor(),
                 Bxnor(),
                 Bxor(),
                 Crossbar(),
                 Dffasync(),
                 Dffsync(),
                 Gray2bin(),
                 Mux(),
                 Muxcase(),
                 Muxhot(),
                 Muxpri(),
                 Onehot(),
                 Pipeline(),
                 Shiftreg()]:
        assert len(item.get_file('rtl')) == 1

def test_memory_setup():
    for item in [Cache(),
                 Fifoasync(),
                 Fifosync(),
                 Ramasync(),
                 Rambit(),
                 Rambyte(),
                 Ramdp(),
                 Ramsdp(),
                 Ramsp(),
                 Ramspnc(),
                 Regfile(),
                 Rom()]:
        assert len(item.get_file('rtl')) == 1

def test_arithmetic_setup():

    for item in [Abs(),
                 Absdiff(),
                 Absdiffs(),
                 Add(),
                 Addsub(),
                 Cmp(),
                 Counter(),
                 Csa32(),
                 Csa42(),
                 Dec(),
                 Dotprod(),
                 Inc(),
                 Log2(),
                 Mac(),
                 Max(),
                 Min(),
                 Mul(),
                 Muladd(),
                 Muladdc(),
                 Mulc(),
                 Mulreg(),
                 Muls(),
                 Relu(),
                 Round(),
                 Shiftar(),
                 Shiftb(),
                 Shiftl(),
                 Shiftr(),
                 Sine(),
                 Sqdiff(),
                 Sqrt(),
                 Sub(),
                 Sum()]:
        assert len(item.get_file('rtl')) == 1

def test_block_setup():
    for item in [Aes(),
                 Axicrossbar(),
                 Ethmac(),
                 Ialu(),
                 I2c(),
                 Lfsr(),
                 Picorv32(),
                 Serv(),
                 Uart()]:
        assert item.get_file('rtl')
