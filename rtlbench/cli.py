import argparse
import sys
import os
import siliconcompiler

def main():


    ##############################################
    # Command line interface
    ##############################################

    progname = "lb"

    examples= f"""
===========================================================-
Examples:
lb run mult asap7_demo # run mult benchmark on asap7
lb run all asap7_demo # run all benchmarks on asap7
lb clean all # clean up all build directories
lb report all sky13_demo -m area # report area for all benchmarks in sky130
=============================================================================
"""

    parser = argparse.ArgumentParser(prog=progname,
                                     description=(
                                         "Logic design benchmark utility leveraging the SiliconCompiler project.\n"
                                         "See SiliconCompiler for target and metric documentation."
                                     ),
                                     epilog=examples,
                                     formatter_class=argparse.RawTextHelpFormatter
                                     )

    # main command
    parser.add_argument("cmd",
                        choices=["run", "clean", "report"],
                        help="command to execute")

    # main command
    parser.add_argument("benchmark",
                        help="benchmark name ('all' runs everything)")

    # target
    parser.add_argument("target",
                        help="target name")

    # metrics
    parser.add_argument("-m",
                        nargs="*",
                        help="metrics to report")

    # parameter
    parser.add_argument("-p",
                        nargs="*",
                        help="parameter value")


    args = parser.parse_args()

#chip = oh_mux.setup()
#chip.use(asap7_demo)
#chip.set('option', 'to', 'syn')
#chip.run()
#chip.summary()


if __name__ == "__main__":
    sys.exit(main())
