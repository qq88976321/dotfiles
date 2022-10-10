#!/usr/bin/env bash

# Exit on an Error or if an Unset variable is referenced.
set -eu

# When used in combination with set -e, pipefail will make a script exit if any command in a pipeline errors.
set -o pipefail

# Print a trace of simple commands and their arguments after they are expanded and before they are executed.
set -x

if [[ ! -x $(command -v rg) ]]; then
    # only Ubuntu Cosmic (18.10) or newer can use apt-get install to install rg
    LATEST_TAG=$(git ls-remote --tags --sort="v:refname" https://github.com/BurntSushi/ripgrep.git '[0-9]*.[0-9]*.[0-9]*' | tail -n1 | sed 's/.*\///; s/\^{}//')
    PKG_PATH=/tmp/ripgrep_"$LATEST_TAG"_amd64.deb
    curl -fsSL https://github.com/BurntSushi/ripgrep/releases/download/"$LATEST_TAG"/ripgrep_"$LATEST_TAG"_amd64.deb --output "$PKG_PATH"

    sudo dpkg -i "$PKG_PATH"
else
    echo "[INFO] rg is already installed."
fi
