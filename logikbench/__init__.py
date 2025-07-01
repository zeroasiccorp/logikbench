
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

# Arithmetic
from .arithmetic.abs.abs import Abs
from .arithmetic.absdiff.absdiff import Absdiff
from .arithmetic.absdiffs.absdiffs import Absdiffs
from .arithmetic.add.add import Add
from .arithmetic.addsub.addsub import Addsub
from .arithmetic.cmp.cmp import Cmp
from .arithmetic.counter.counter import Counter
from .arithmetic.csa32.csa32 import Csa32
from .arithmetic.csa42.csa42 import Csa42
from .arithmetic.dec.dec import Dec
from .arithmetic.dotprod.dotprod import Dotprod
from .arithmetic.inc.inc import Inc
from .arithmetic.log2.log2 import Log2
from .arithmetic.mac.mac import Mac
from .arithmetic.max.max import Max
from .arithmetic.min.min import Min
from .arithmetic.mul.mul import Mul
from .arithmetic.muladd.muladd import Muladd
from .arithmetic.muladdc.muladdc import Muladdc
from .arithmetic.mulc.mulc import Mulc
from .arithmetic.mulreg.mulreg import Mulreg
from .arithmetic.muls.muls import Muls
from .arithmetic.relu.relu import Relu
from .arithmetic.round.round import Round
from .arithmetic.shiftar.shiftar import Shiftar
from .arithmetic.shiftb.shiftb import Shiftb
from .arithmetic.shiftl.shiftl import Shiftl
from .arithmetic.shiftr.shiftr import Shiftr
from .arithmetic.sine.sine import Sine
from .arithmetic.sqdiff.sqdiff import Sqdiff
from .arithmetic.sqrt.sqrt import Sqrt
from .arithmetic.sub.sub import Sub
from .arithmetic.sum.sum import Sum

#################################################
# Define the public API
#################################################

# __all__ = ['Mul','Muls']
