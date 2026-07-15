#!/usr/bin/env bash
#
# Linear FPGA synthesis sweep for logikbench.
#
# Phase 1: the small benchmark groups (everything except koios/large) across
#          every FPGA target, at -j 16, EXCLUDING the long-pole benchmarks
#          (--skip $LONGPOLES) -- a few epfl designs dominate runtime
#          (hyp ~1300s, log2 ~460s, multiplier ~330s) and would straggle the
#          otherwise-fast wide phase.
# Phase 2: those long poles on their own (-n $LONGPOLES) across every target,
#          at -j 3 (only three designs; run them concurrently per target).
# Phase 3: the heavy groups (large + koios) across every target, at -j 2 --
#          these designs are memory-hungry and OOM at high parallelism.
#
# "Linear" = one target at a time (an outer for-loop), so a hang or OOM on one
# target does not tie up scheduling for the others. Within each invocation, -j
# fans the target's benchmarks over that many workers.
#
# Results publish into ./results by default (autodetected when run from a git
# clone). Benchmark failures are expected on some target/design combinations;
# the loop intentionally continues past them (no 'set -e').
#
# Edit TARGETS / *_GROUPS / LONGPOLES below to narrow the sweep. If you want
# phase 3 to run only the 'large' group (not koios), drop "koios" from
# HEAVY_GROUPS.

set -u

TARGETS="virtex7 polarpro polarfire ice40 ecp5 gw5a speedster flex16ffc \
trion fabulous cologne z1015 z1060"

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
