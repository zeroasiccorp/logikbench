from logikbench import Abs
from logikbench import Absdiff
from logikbench import Absdiffs
from logikbench import Add
from logikbench import Addsub
from logikbench import Cmp
from logikbench import Counter
from logikbench import Csa32
from logikbench import Csa42
from logikbench import Dec
from logikbench import Dotprod
from logikbench import Inc
from logikbench import Log2
from logikbench import Mac
from logikbench import Max
from logikbench import Min
from logikbench import Mul
from logikbench import Muladd
from logikbench import Muladdc
from logikbench import Mulc
from logikbench import Mulreg
from logikbench import Muls
from logikbench import Relu
from logikbench import Round
from logikbench import Shiftar
from logikbench import Shiftb
from logikbench import Shiftl
from logikbench import Shiftr
from logikbench import Sine
from logikbench import Sqdiff
from logikbench import Sqrt
from logikbench import Sub
from logikbench import Sum

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
