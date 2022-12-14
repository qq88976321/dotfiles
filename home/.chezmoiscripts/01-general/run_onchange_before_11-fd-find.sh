#!/usr/bin/env bash

# Exit on an Error or if an Unset variable is referenced.
set -eu

# When used in combination with set -e, pipefail will make a script exit if any command in a pipeline errors.
set -o pipefail

# Print a trace of simple commands and their arguments after they are expanded and before they are executed.
set -x

if [[ ! -x $(command -v fd) ]]; then
    # https://github.com/sharkdp/fd#on-ubuntu
    LATEST_TAG=$(git ls-remote --tags --sort="v:refname" https://github.com/sharkdp/fd.git | tail -n1 | sed 's/.*\///; s/\^{}//')
    LATEST_TAG_WITHOUT_V_PREFIX=$(echo "$LATEST_TAG" | cut -c 2-)
    PKG_PATH=/tmp/fd_"$LATEST_TAG_WITHOUT_V_PREFIX"_amd64.deb
    curl -fsSL https://github.com/sharkdp/fd/releases/download/"$LATEST_TAG"/fd_"$LATEST_TAG_WITHOUT_V_PREFIX"_amd64.deb --output "$PKG_PATH"

    sudo dpkg -i "$PKG_PATH"
else
    echo "[INFO] fd-find is already installed."
fi
