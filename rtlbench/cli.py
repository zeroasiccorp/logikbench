import argparse
import sys
import os
import siliconcompiler

def main():
    progname = "hwbenchy"

    description = f"""
-----------------------------------------------------------
Runs RTL benchmarks using SiliconCompiler. The
<target> is any target recognized by SC (eg. asap7_demo)

Run a single benchmark on :
   hwbenchy mult <target>

Run all benchmarks
   hwbenchy all <target>

Clean up build directories
   hwbenchy clean

-----------------------------------------------------------
"""

#chip = oh_mux.setup()
#chip.use(asap7_demo)
#chip.set('option', 'to', 'syn')
#chip.run()
#chip.summary()


if __name__ == "__main__":
    sys.exit(main())
