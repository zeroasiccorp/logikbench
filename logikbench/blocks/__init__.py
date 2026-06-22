from .aes.aes import Aes
from .apbregs.apbregs import Apbregs
from .axicrossbar.axicrossbar import Axicrossbar
from .ethmac.ethmac import Ethmac
# fft disabled: WIP RTL is not synthesizable (non-constant for-loop bound, and a
# single-cycle all-stages architecture ~768 multipliers). Needs a pipelined
# rewrite (FSM + RAM + twiddle ROM, one butterfly/clock) before re-enabling.
# from .fft.fft import Fft
from .firfix.firfix import Firfix
from .firprog.firprog import Firprog
from .fpu64.fpu64 import Fpu64
from .ialu.ialu import Ialu
from .i2c.i2c import I2c
from .lfsr.lfsr import Lfsr
from .picorv32.picorv32 import Picorv32
from .serv.serv import Serv
from .uart.uart import Uart
from .umiregs.umiregs import Umiregs

__all__ = [
    "Aes",
    "Apbregs",
    "Axicrossbar",
    "Ethmac",
    "Firfix",
    "Firprog",
    "Fpu64",
    "Ialu",
    "I2c",
    "Lfsr",
    "Picorv32",
    "Serv",
    "Uart",
    "Umiregs",
]
