
try:
    from logikbench._version import __version__ as __version__
except ImportError:
    # This only exists in installations
    __version__ = None

# Sub-modules
from logikbench.benchmarks import basic
from logikbench.benchmarks import arithmetic
from logikbench.benchmarks import memory
from logikbench.benchmarks import blocks
from logikbench.benchmarks import epfl
from logikbench.benchmarks import iscas85
from logikbench.benchmarks import iscas89

__all__ = [
    "basic",
    "arithmetic",
    "memory",
    "blocks",
    "epfl",
    "iscas85",
    "iscas89"
]
