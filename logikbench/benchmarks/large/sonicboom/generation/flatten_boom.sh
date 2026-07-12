#!/bin/bash
#
# Flatten already-generated Chipyard BOOM collateral into one synthesizable
# subsystem file. This is the tail of generate_boom.sh, split out so it can be
# re-run on its own after `make ... verilog` has produced gen-collateral --
# without re-cloning or re-elaborating.
#
# Output: large/sonicboom/rtl/sonicboom.sv
set -e

# ---- must match generate_boom.sh -------------------------------------------
CONFIG=MegaBoomV3Config
VARIANT=sonicboom
PREFIX=${VARIANT}_
TOP=DigitalTop            # synthesizable digital top (drops TestHarness/sim)

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
CHIPYARD=$SCRIPT_DIR/chipyard
RTL_OUT=$SCRIPT_DIR/..                           # -> large/sonicboom (bench root)
CONFDIR=$CHIPYARD/sims/verilator/generated-src/chipyard.harness.TestHarness.${CONFIG}
COLL=$CONFDIR/gen-collateral

# ---- tools: morty + verible (presetup_boom.sh installs here by default) -----
TOOLS=${RISCV_CORES_TOOLS:-$HOME/riscv_cores_tools}
[ -d "$TOOLS/bin" ] && export PATH="$TOOLS/bin:$PATH"
for t in morty verible-verilog-preprocessor; do
    command -v "$t" >/dev/null 2>&1 || {
        echo "ERROR: '$t' not on PATH. Run presetup_boom.sh, or set" >&2
        echo "       RISCV_CORES_TOOLS to the prefix that holds bin/$t." >&2
        exit 1
    }
done

# ---- sanity: collateral must exist ------------------------------------------
[ -d "$COLL" ] || {
    echo "ERROR: no collateral at $COLL" >&2
    echo "       Run generate_boom.sh (or 'make CONFIG=$CONFIG verilog') first." >&2
    exit 1
}

mkdir -p "$RTL_OUT/rtl"

# ---- uniquify + flatten under $TOP, then strip comments ---------------------
cd "$COLL"
UNIQ=/tmp/${VARIANT}_uniquified.sv
echo "Flattening $(ls *.sv | wc -l) modules under $TOP ..."
morty *.sv -q -p "$PREFIX" --top "$TOP" -D SYNTHESIS -o "$UNIQ"

rm -f "$RTL_OUT/rtl/${VARIANT}.sv"
verible-verilog-preprocessor strip-comments "$UNIQ" \
    | grep "\S" > "$RTL_OUT/rtl/${VARIANT}.sv"

echo
echo "Wrote $RTL_OUT/rtl/${VARIANT}.sv  (top module: ${PREFIX}${TOP})"
echo "  ($(wc -l < "$RTL_OUT/rtl/${VARIANT}.sv") lines)"
echo "SRAMs remain blackboxes -- bind them via lambdalib (ramlib) in sonicboom.py."
