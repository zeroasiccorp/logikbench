
# LogikBench Version Number
__version__ = "0.0.1"

######################################################
# Add benchmark package here for cleaner user imports
######################################################

from .mul.mul import Mul
from .muls.muls import Muls
from .muladd.muladd import Muladd
from .mux.mux import Mux

#################################################
# Define the public API
#################################################

__all__ = [
    'Mul',
    'Muls',
    'Muladd',
    'Mux']
