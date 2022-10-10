#!/usr/bin/env bash

# Exit on an Error or if an Unset variable is referenced.
set -eu

# When used in combination with set -e, pipefail will make a script exit if any command in a pipeline errors.
set -o pipefail

# Print a trace of simple commands and their arguments after they are expanded and before they are executed.
set -x

if [[ ! -x $(command -v diff-highlight) ]]; then
    # build from source
    LATEST_TAG=$(git ls-remote --tags --sort="v:refname" https://github.com/git/git.git | tail -n1 | sed 's/.*\///; s/\^{}//')
    git clone --depth 1 --branch "$LATEST_TAG" https://github.com/git/git.git /tmp/git
    cd /tmp/git/contrib/diff-highlight
    make diff-highlight
    mkdir -p ~/.local/bin
    install diff-highlight ~/.local/bin
else
    echo "[INFO] diff-highlight is already installed."
fi
