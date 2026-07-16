#!/usr/bin/env bash
#
# Linear ASIC synthesis sweep for logikbench (mirrors scripts/run_fpga.sh).
#
# Phase 1: the small benchmark groups (everything except koios/large) across
#          every ASIC PDK, at -j 16, EXCLUDING the long-pole benchmarks
#          (--skip $LONGPOLES) -- a few epfl designs dominate runtime
#          (hyp, log2, multiplier) and would straggle the fast wide phase.
# Phase 2: those long poles on their own (-n $LONGPOLES) across every PDK,
#          at -j 3 (only three designs; run them concurrently per PDK).
# Phase 3: the heavy groups (large + koios) across every PDK, at -j 2 --
#          these designs are memory-hungry and OOM at high parallelism.
#
# ASIC synthesis is yosys mapped against each PDK's liberty (default --tool
# yosys), timed with each PDK's tech.tcl default clock. It needs the PDK
# libraries installed (e.g. `sc-install -group asic`); PDKs that aren't
# installed simply fail and the loop continues.
#
# "Linear" = one PDK at a time (an outer for-loop), so a hang or OOM on one
# does not tie up scheduling for the others. Within each invocation, -j fans
# the PDK's benchmarks over that many workers. Results publish into ./results
# by default (git clone). Benchmark failures are expected; no 'set -e'.
#
# Edit TARGETS / *_GROUPS / LONGPOLES below to narrow the sweep. If you want
# phase 3 to run only the 'large' group (not koios), drop "koios" from
# HEAVY_GROUPS.

set -u

TARGETS="asap7 freepdk45 gf180 ihp130 sky130"

SMALL_GROUPS="basic memory arithmetic epfl blocks iscas85 iscas89"
LONGPOLES="hyp log2 multiplier"
HEAVY_GROUPS="large koios"

echo "############################################################"
echo "# Phase 1: small groups (-j 16), long poles skipped"
echo "#   groups : $SMALL_GROUPS"
echo "#   skip   : $LONGPOLES"
echo "############################################################"
for target in $TARGETS; do
    echo ">>> [phase 1] $target"
    lb syn -t "$target" -g $SMALL_GROUPS --skip $LONGPOLES -j 16
done

echo "############################################################"
echo "# Phase 2: long poles (-j 3)"
echo "#   names  : $LONGPOLES"
echo "############################################################"
for target in $TARGETS; do
    echo ">>> [phase 2] $target"
    lb syn -t "$target" -n $LONGPOLES -j 3
done

echo "############################################################"
echo "# Phase 3: heavy groups (-j 2)"
echo "#   groups : $HEAVY_GROUPS"
echo "############################################################"
for target in $TARGETS; do
    echo ">>> [phase 3] $target"
    lb syn -t "$target" -g $HEAVY_GROUPS -j 2
done

echo "Done."
