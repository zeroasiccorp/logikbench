# ISCAS89 sequential circuit: the clock port is named CK, which the shared
# default.sdc does not auto-detect (its glob is *clk*/*clock*). Pin the clock
# explicitly, then defer to the shared defaults.
set LB_CLK [get_ports CK]
source $LB_DEFAULT_SDC
