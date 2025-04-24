from siliconcompiler.targets import asap7_demo
#from uart import uart
#from aes import aes
#from picorv32 import picorv32
#from ethmac import ethmac
from mult import mult
from add import add

#chip = picorv32.setup()
#chip = uart.setup()
#chip = aes.setup()
#chip = ethmac.setup()
chip = add.setup()
chip.use(asap7_demo)
chip.set('option', 'to', 'syn')
chip.run()
chip.summary()
