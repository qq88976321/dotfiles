#!/usr/bin/env bash

# Exit on an Error or if an Unset variable is referenced.
set -eu

# When used in combination with set -e, pipefail will make a script exit if any command in a pipeline errors.
set -o pipefail

# Print a trace of simple commands and their arguments after they are expanded and before they are executed.
set -x

if [[ ! -d ~/.nvm ]]; then
    LATEST_TAG=$(git ls-remote --tags --sort="v:refname" https://github.com/nvm-sh/nvm.git | tail -n1 | sed 's/.*\///; s/\^{}//')
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/"$LATEST_TAG"/install.sh | bash
else
    echo "[INFO] nvm is already installed."
fi
