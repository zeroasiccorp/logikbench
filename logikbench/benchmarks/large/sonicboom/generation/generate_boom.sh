#!/bin/bash
#
# Generate a flattened, synthesizable SonicBOOM (BOOM v3) subsystem from stock
# UPSTREAM Chipyard (github.com/ucb-bar/chipyard) with NO patches. Self-contained:
# it depends only on the tools installed by presetup_boom.sh (conda/morty/verible)
# and clones everything else -- nothing from any other repo or personal setup.
#
# BOOM is generated straight from stock upstream Chipyard at a pinned release,
# with the `boom` submodule checked out to a pinned riscv-boom commit (see below),
# overriding whatever commit that Chipyard release defaults to.
#
# Output: large/sonicboom/rtl/sonicboom.sv
#
# Heavy build: Chipyard build-setup (conda + firtool + sbt + riscv-tools) plus
# BOOM elaboration -- expect a large-RAM, long-running, network-dependent run on
# a provisioned machine. Not runnable from a bare checkout.
set -e

# ---- pins / knobs -----------------------------------------------------------
CHIPYARD_REPO=https://github.com/ucb-bar/chipyard
CHIPYARD_TAG=1.13.0            # upstream Chipyard release
# riscv-boom commit to pin. NOTE: the newest riscv-boom RELEASE TAG is v3.0.0
# (~2021), but that tag predates the rocket-chip config-package migration
# (freechips.rocketchip.config -> org.chipsalliance.cde.config) and no longer
# compiles against modern Chipyard's rocket-chip. Chipyard 1.13.0 ships BOOM at
# d2a64f7c == `git describe` v3.0.0-379-gd2a64f7c (379 commits past the tag) --
# same v3 "sonic" architecture line, but the head Chipyard actually validates.
# We pin that exact commit for reproducibility. To follow whatever a given
# Chipyard release pins instead, just delete the step-2b checkout below.
BOOM_REV=d2a64f7ca9fd914d9c686cb23edcd32d3465a02e
# Stock Chipyard BOOM config. Chipyard 1.13.0 names its BOOM configs with
# explicit V3/V4 suffixes (MegaBoomV3Config, MegaBoomV4Config, ...). We use the
# V3 "sonic" line to match the pinned boom commit above.
CONFIG=MegaBoomV3Config
VARIANT=sonicboom
PREFIX=${VARIANT}_
# Chipyard's synthesizable digital top (the DUT inside the TestHarness).
# Confirm against gen-collateral after the first run and adjust if needed.
TOP=DigitalTop

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
RTL_OUT=$SCRIPT_DIR/..                    # -> large/sonicboom (benchmark root)
cd "$SCRIPT_DIR"

# ---- 1. clone upstream Chipyard (NON-recursive) -----------------------------
# Do NOT use --recursive: that drags in Chipyard's whole software submodule
# tree (zephyr, spec2017, nvdla-workload, coremark, ...) which we do not need.
# build-setup.sh (step 1) runs init-submodules-no-riscv-tools, which inits only
# the RTL generators and explicitly excludes the software workloads.
rm -rf chipyard
git clone "$CHIPYARD_REPO" chipyard
cd chipyard
git checkout "$CHIPYARD_TAG"

# ---- 2. env: init generator submodules (no software) + firtool, and skip the
#         heavy riscv toolchain build (not needed for RTL generation) ---------
# Keep only: conda env (1), submodule init (2), CIRCT/firtool (10). Skip the
# heavy extras we do NOT need for RTL generation: toolchain (3), ctags (4),
# Scala/FireSim precompile (5/7), FireSim + its aws-fpga clone (6), FireMarshal
# (8/9). Do NOT skip CIRCT -- firtool is required by `make verilog`.
./build-setup.sh --skip-toolchain --skip-ctags --skip-precompile \
                 --skip-firesim --skip-marshal
source ./env.sh

# ---- 2b. pin the riscv-boom submodule to the requested release -------------
# Done AFTER build-setup so its submodule init does not reset the pin.
( cd generators/boom
  git fetch --tags origin
  git checkout "$BOOM_REV" )

# ---- 3. generate Verilog for MegaBoomConfig ---------------------------------
cd sims/verilator
make CONFIG="$CONFIG" verilog

# ---- 4. collect + flatten (NO patches, NO srammap) --------------------------
COLLATERAL=generated-src/chipyard.harness.TestHarness.${CONFIG}/gen-collateral
mkdir -p "$RTL_OUT/rtl"

cd "$COLLATERAL"
# Uniquify + flatten every module under $TOP into one file (prefix-namespaced),
# then strip comments -- one self-contained rtl/<name>.sv like the other cores.
morty *.sv -q -p "$PREFIX" --top "$TOP" -D SYNTHESIS -o /tmp/${VARIANT}_uniquified.sv
rm -f "$RTL_OUT/rtl/${VARIANT}.sv"
verible-verilog-preprocessor strip-comments /tmp/${VARIANT}_uniquified.sv \
    | grep "\S" > "$RTL_OUT/rtl/${VARIANT}.sv"

echo "Wrote $RTL_OUT/rtl/${VARIANT}.sv  (top module: ${PREFIX}${TOP})"
echo "SRAMs remain blackboxes -- bind them via lambdalib (ramlib) in sonicboom.py."
echo "Confirm the emitted SRAM module names and the top module (${PREFIX}${TOP})."
