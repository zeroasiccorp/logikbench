import argparse
import sys
import os
import importlib
import shutil
import pandas as pd
import siliconcompiler as sc

from siliconcompiler.targets import asap7_demo

from .add.add import Add
from .mult.mult import Mult

##############################################
# Main Program
##############################################
def main():

    progname = "lb"
    # creating dummy chip object to access cmdline utility
    chipargs = sc.Chip(progname)

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

    # create a sime runset
    runset = {}
    #for b in args['b']:
    #    runset[b] = {}
    #    for p in chipargs.getkeys('option', 'param'):
    #        runset[b][p] = chipargs.get('option', 'param', p)

    # run benchmarks
    # todo, string to object mapping
    # todo, set
    # a.set('option, 'param', 'N', 16)
    a = Add()

    runset = [Add(), Mult()]

    run(runset,
        metrics=args['m'],
        target=asap7_demo, #TODO: make dynamic
        output=args['o'],
        to=chipargs.get('option', 'to')[0],
        jobname=chipargs.get('option', 'jobname'),
        quiet=chipargs.get('option', 'quiet'),
        clean=chipargs.get('option', 'clean'))

########################################################################
# Python callable function
########################################################################
def run(runset, metrics, target,
        output=None, to=None, jobname=None, quiet=None, clean=None):
    '''
    '''
    results = []
    for design in runset:
        # a new chip object for every benchmark
        chip = sc.Chip(design.name)
        chip.set('option', 'to', to)
        chip.set('option', 'jobname', jobname)
        chip.set('option', 'quiet', quiet)
        chip.set('option', 'clean', clean)
        chip.use(target)

        # instantiate object and copy over parameters
        # TODO: --> replace with chip.use(design)
        keypath = ['input', 'rtl','verilog']
        vlog = design.get(*keypath)
        chip.set(*keypath, vlog)
        keypath = ['input', 'constraint','sdc']
        sdc = design.get(*keypath)
        chip.set(*keypath, sdc)

        # run benchmark
        chip.run()
        chip.summary()

        # stuff metrics into a pandas compatible table
        row = {}
        row['benchmark'] = design.name
        for m in metrics:
            row[m] = chip.get('metric', m, step=to, index=str(0))
        results.append(row)

    # Create DataFrame in one shot
    df = pd.DataFrame(results)
    print(df)
    df.to_csv(output, index=False)

##############################################
# Calling as standalone program
##############################################
if __name__ == "__main__":
    sys.exit(main())
    "lb -to syn -m warnings cellarea -o tmp.csv"
