import siliconcompiler as sc

#######################################################
# Basic Design Object inherits from Schema
# Adds design specific schema
#######################################################
# Usage: gcc [options] file...
# Usage: clang [options] file...

# Examples of types of design sources:
#  1.) human generated software (verilog, vhdl, python, c)
#  2.) ai generated software (verilog, vhdl, python, c)
#  3.) deterministic generated code (chisel-->verilog for example)
#  4.) schematics (block diagrams)
#  5.) netlist (1:1 correlation with schematics)

# Transpilers and modifiers allowed, C code-->C code
# Veriog --> Verilog

# Design --> SC --> Part --> SC --> Part

# Source/schema should support syntax for files, pip, git, local
# use the gcc command line options -L for the path to the library files and -l to link in a library (a .so or a .a):

# options:
# env?
# var?
# entrypoint, per fileset (CHANGE?)
# idir
# ydir
# vlib
# ldir? (CHANGE/ADD?)
# define (equal sign or not?)
# libext
# param (make consistent with DEFINE)

# tuples: (scribe, panelname, datasheet, constraint
# tuples: constraint, flawgraph

class Design(sc.Chip):
    def __init__(self,name):
        super().__init__(name)
        self.design_schema = {}

    def source(self, filename, fileset=None, filetype=None, iomap=None):
        # todo: implement
        self.input(filename)

    # TODO: options consistency
    # params vs defines (with equals), not consistent!!
    def option(self, keypath, value):
        keypath = ['option'] + keypath
        self.set(keypath, value)

    def getoption(self):
        '''return design optons'''
        pass

    def getdict(self):
        '''return design dict'''
        pass

    def getfileset(self):
        '''return list of filesets'''
        pass

    def getsource(self, fileset, filetype=None):
        '''return files of type fileset'''
        pass
