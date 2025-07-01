from logikbench import Cache
from logikbench import Fifoasync
from logikbench import Fifosync
from logikbench import Ramasync
from logikbench import Rambit
from logikbench import Rambyte
from logikbench import Ramdp
from logikbench import Ramsdp
from logikbench import Ramsp
from logikbench import Ramspnc
from logikbench import Regfile
from logikbench import Rom

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
