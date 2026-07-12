#!/bin/bash
#
# One-time prerequisites for generate_boom.sh (the upstream, patch-free BOOM
# flow). Installs ONLY what that flow needs, user-locally (no root, no sudo):
#
#   * conda (Miniforge)  -- required by Chipyard's build-setup.sh
#   * morty              -- RTL uniquify/flatten
#   * verible            -- strip-comments
#
# Unlike presetup.sh (the ZeroASIC-fork flow), this does NOT need root and does
# NOT clone any ZeroASIC private repos (ebrick/uphy/chipio/clink).
#
# Usage:  ./presetup_boom.sh [install_prefix]     (default: $HOME/riscv_cores_tools)
# Then, in the shell you run generate_boom.sh from:
#   source <prefix>/miniforge3/etc/profile.d/conda.sh
#   export PATH=<prefix>/bin:$PATH
set -e

PREFIX=${1:-$HOME/riscv_cores_tools}
OS=$(uname); ARCH=$(uname -m)
mkdir -p "$PREFIX/bin"
cd "$PREFIX"

# ---- conda (Miniforge), user-local -----------------------------------------
if [ ! -x "$PREFIX/miniforge3/bin/conda" ]; then
    MF="Miniforge3-${OS}-${ARCH}.sh"
    curl -fsSL -O "https://github.com/conda-forge/miniforge/releases/latest/download/${MF}"
    bash "$MF" -b -p "$PREFIX/miniforge3"
    rm -f "$MF"
fi
source "$PREFIX/miniforge3/etc/profile.d/conda.sh"
# Chipyard's build-setup resolves its env with conda-lock.
conda install -y -n base conda-lock=1.4.0 || true

# ---- morty (pulp-platform) --------------------------------------------------
if [ ! -x "$PREFIX/bin/morty" ]; then
    curl -fsSL -O https://github.com/pulp-platform/morty/releases/download/v0.9.0/morty-ubuntu.22.04-x86_64.tar.gz
    tar xzf morty-ubuntu.22.04-x86_64.tar.gz morty
    mv morty "$PREFIX/bin/"
    rm -f morty-ubuntu.22.04-x86_64.tar.gz
fi

# ---- verible (chipsalliance) ------------------------------------------------
if [ ! -x "$PREFIX/bin/verible-verilog-preprocessor" ]; then
    TGZ=verible-v0.0-3836-g86ee9bab-linux-static-x86_64.tar.gz
    curl -fsSL -O "https://github.com/chipsalliance/verible/releases/download/v0.0-3836-g86ee9bab/${TGZ}"
    tar xzf "${TGZ}"
    # the archive extracts to verible-v0.0-3836-g86ee9bab/ (no arch suffix)
    cp verible-*/bin/* "$PREFIX/bin/"
    rm -rf verible-v0.0-3836-g86ee9bab* "${TGZ}"
fi

echo
echo "Done. Before running generate_boom.sh, in the same shell:"
echo "  source $PREFIX/miniforge3/etc/profile.d/conda.sh"
echo "  export PATH=$PREFIX/bin:\$PATH"
