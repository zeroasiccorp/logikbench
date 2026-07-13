from os.path import dirname, abspath
from siliconcompiler import Design
from logikbench.benchmarks.blocks.sha256.sha256 import Sha256


class Bitcoin(Design):
    def __init__(self):

        name = 'bitcoin'
        root = f'{name}_root'
        # leaf modules first, top last (single compilation unit)
        source = ['rtl/bitcoin_compare.v', 'rtl/bitcoin_sha256d.v',
                  'rtl/bitcoin_engine.v', 'rtl/bitcoin.v']

        # create a Design object
        super().__init__(name)

        # set data home directory
        self.set_dataroot(root, dirname(abspath(__file__)))

        # rtl files
        fileset = 'rtl'
        for item in source:
            self.add_file(item, fileset, dataroot=root)

        # reuse the SHA-256 core (sha256_core) from the sha256 benchmark rather
        # than vendoring a copy; pulls in the sha256 rtl fileset as a dependency
        self.add_depfileset(Sha256(), fileset=fileset)

        # top module
        self.set_topmodule(name, fileset)

        # Large configuration: NENGINES parallel SHA256d lanes (~one SHA-256
        # core each). Default 128 (~1.3M cells); scale up for authentic miner
        # sizes. NENGINES is a top-level RTL parameter the flow forwards to the
        # mapper (slang -G / chparam).
        self.set_param('NENGINES', '128', fileset)

        # self-checking testbench (`lb sim`)
        self.add_file(f'testbench/test_{name}_smoke.v', 'testbench', dataroot=root)
        self.set_topmodule(f'test_{name}_smoke', 'testbench')


if __name__ == "__main__":
    d = Bitcoin()
    d.write_fileset("bitcoin.f", fileset="rtl")
