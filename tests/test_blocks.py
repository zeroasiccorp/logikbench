from logikbench import Aes
from logikbench import Axicrossbar
from logikbench import Ethmac
from logikbench import Ialu
from logikbench import I2c
from logikbench import Lfsr
from logikbench import Picorv32
from logikbench import Serv
from logikbench import Uart

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
