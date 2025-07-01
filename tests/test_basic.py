from logikbench import Arbiter
from logikbench import Band
from logikbench import Bbuf
from logikbench import Bin2gray
from logikbench import Bin2prio
from logikbench import Binv
from logikbench import Bnand
from logikbench import Bnor
from logikbench import Bor
from logikbench import Bxnor
from logikbench import Bxor
from logikbench import Crossbar
from logikbench import Dffasync
from logikbench import Dffsync
from logikbench import Gray2bin
from logikbench import Mux
from logikbench import Muxcase
from logikbench import Muxhot
from logikbench import Muxpri
from logikbench import Onehot
from logikbench import Pipeline
from logikbench import Shiftreg

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
