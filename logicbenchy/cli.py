import argparse
import sys
import os
import importlib
import shutil
import siliconcompiler
from siliconcompiler.apps._common import manifest_switches

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
Logic (RTL) benchmark utility leveraging the SiliconCompiler project.
See SiliconCompiler for target and metric documentation.
============================================================================
Examples:
lb mult asap7_demo # run mult benchmark on asap7
lb all asap7_demo # run all benchmarks on asap7
lb mult asap7_demo -clean # clean mult directory before running
 =============================================================================
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
        '-b': {'action': 'append',
               'help': 'list of benchmarks to run ',
               'metavar': '<benchmark>',
               'sc_print': False},
        '-m': {'action': 'append',
               'help': 'list of metrics to report ',
               'metavar': '<metric>',
               'sc_print': False}
    }

    # run sc command line function
    args = chipargs.create_cmdline(progname,
                                   switchlist=switchlist,
                                   description=description,
                                   additional_args=lb_args)

    # capture extra arguments
    benchmarks = args['b']
    metrics = args['m']
    results = {}
    for m in metrics:
        results[m] = {}

    # TODO: params don't work when looping over designs, remove for loop
    # params really only works for one run, remove for loop?

    # iterate over list
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

        # stuff metrics into table
        #TODO: why is to a list and why is error so obtuse!?
        for m in metrics:
            results[m][item] = chip.get('metric', m, step=chipargs.get('option', 'to')[0], index=str(0))


    print(results)

##############################################
# Calling as standalone program
##############################################
if __name__ == "__main__":
    sys.exit(main())
