import siliconcompiler as sc

#######################################################
# Basic Design Object inherits from Schema
# Adds design specific schema
#######################################################
# Usage: gcc [options] file...
# Usage: clang [options] file...

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

    def getfile(self, fileset, filetype=None):
        '''return files of type fileset'''
        pass
