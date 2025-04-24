Parametrized Integer Multiplier
============================================

## Description

A benchmark multiplies two numbers of width N and returns the N bit wide product a * b.

This benchmark checks:
- high level synthesis
- arithmetic logic libraries
- critical path timing optimization
- datapath placement

## Original Sources

- Author: Dan Gisselquist
- Repo: https://github.com/ZipCPU/dspfilters
- Commit Hash: 16d7dc3b23af167759693da9caff7c7111805873

## License

LGPLv3

## Modifications
- Cleanup
- Removed formal logic/verification stuff
- Changed name to fir
- Removing initial statements and resetting taps
- Combined firtap/fir into one file, pickling for convenience