
try:
    from logikbench._version import __version__ as __version__
except ImportError:
    # This only exists in installations
    __version__ = None

# Sub-modules
from logikbench import basic
from logikbench import arithmetic
from logikbench import memory
from logikbench import blocks
from logikbench import epfl
from logikbench import iscas85
from logikbench import iscas89

__all__ = [
    "basic",
    "arithmetic",
    "memory",
    "blocks",
    "epfl",
    "iscas85",
    "iscas89"
]
