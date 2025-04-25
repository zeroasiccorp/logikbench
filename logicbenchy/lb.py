import argparse
import sys
import os
import importlib
import shutil
import pandas as pd
import siliconcompiler

# TODO: cleaner way of dynamically importing targets?
from siliconcompiler.targets import asap7_demo

##############################################
# Main Program
##############################################
def main():

    progname = "lb"
    # creating dummy chip object to access cmdline utility
    chipargs = siliconcompiler.Chip(progname)

    description= f"""
============================================================================
Logic (RTL) benchmark utility based on SiliconCompiler.
============================================================================

examples:
   >> lb -b add mult -m cellarea warnings -to syn -o tmp.csv
   >> lb -b mult asap7_demo # run mult benchmark on asap7
   >> lb -b all asap7_demo # run all benchmarks on asap7
   >> lb -b mult asap7_demo -clean # clean mult directory before running

"""

    # sc switches to pass through
    switchlist = ['-param',
                  '-to',
                  '-from',
                  '-jobname',
                  '-quiet',
                  '-clean']

    # extra switches to add
    lb_args = {
        '-b': {'nargs': '+',
               'help': 'list of benchmarks to run',
               'sc_print': False},
        '-m': {'nargs': '+',
               'help': 'list of metrics to report',
               'sc_print': False},
        '-o': {'help': 'output results file name',
               'metavar': '<file>'}
    }

    # run sc command line function
    # TODO: why isn't this failing on above?
    args = chipargs.create_cmdline(progname,
                                   switchlist=switchlist,
                                   description=description,
                                   additional_args=lb_args)


    # capture extra arguments
    benchmarks = args['b']
    metrics = args['m']
    outfile = args['o']
    results = []

    # TODO: params don't work when looping over designs, remove for loop
    # params really only works for one run, remove for loop?

    # iterate over all benchmarks
    # TODO: params don't work when looping over designs, remove for loop
    # params really only works for one run, remove for loop?

    # TODO iterate over params as well
    for item in benchmarks:

        # dynamic modyle import
        module = importlib.import_module(f"logicbenchy.{item}.{item}")
        func = getattr(module, "setup")

        # creating a per design chip object
        chip = func()

        # copy over arguments
        chip.set('option', 'to', chipargs.get('option', 'to'))
        chip.set('option', 'from', chipargs.get('option', 'from'))
        chip.set('option', 'jobname', chipargs.get('option', 'jobname'))
        chip.set('option', 'quiet', chipargs.get('option', 'quiet'))
        chip.set('option', 'clean', chipargs.get('option', 'clean'))
        for p in chipargs.getkeys('option', 'param'):
            chip.set('option', 'param', p, chipargs.get('option', 'param', p))

        # run benchmark
        chip.use(asap7_demo) #TODO: set dynamically
        chip.run()
        chip.summary()

        # stuff metrics into a pandas compatible table
        row = {}
        row['benchmark'] = item
        for m in metrics:
            row[m] = chip.get('metric', m, step=chipargs.get('option', 'to')[0], index=str(0))
        results.append(row)

    # Create DataFrame in one shot
    df = pd.DataFrame(results)
    print(df)
    df.to_csv(outfile, index=False)


##############################################
# Calling as standalone program
##############################################
if __name__ == "__main__":
    sys.exit(main())
