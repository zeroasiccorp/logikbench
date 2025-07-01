
# LogikBench Version Number
__version__ = "0.0.1"

######################################################
# Add benchmark package here for cleaner user imports
######################################################

# Basic
from .basic.arbiter.arbiter import Arbiter
from .basic.band.band import Band
from .basic.bbuf.bbuf import Bbuf
from .basic.bin2gray.bin2gray import Bin2gray
from .basic.bin2prio.bin2prio import Bin2prio
from .basic.binv.binv import Binv
from .basic.bnand.bnand import Bnand
from .basic.bnor.bnor import Bnor
from .basic.bor.bor import Bor
from .basic.bxnor.bxnor import Bxnor
from .basic.bxor.bxor import Bxor
from .basic.crossbar.crossbar import Crossbar
from .basic.dffasync.dffasync import Dffasync
from .basic.dffsync.dffsync import Dffsync
from .basic.gray2bin.gray2bin import Gray2bin
from .basic.mux.mux import Mux
from .basic.muxcase.muxcase import Muxcase
from .basic.muxhot.muxhot import Muxhot
from .basic.muxpri.muxpri import Muxpri
from .basic.onehot.onehot import Onehot
from .basic.pipeline.pipeline import Pipeline
from .basic.shiftreg.shiftreg import Shiftreg

#################################################
# Define the public API
#################################################

__all__ = [
    'Mul',
    'Muls',
    'Muladd',
    'Mux']
