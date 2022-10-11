#!/usr/bin/env bash

# Exit on an Error or if an Unset variable is referenced.
set -eu

# When used in combination with set -e, pipefail will make a script exit if any command in a pipeline errors.
set -o pipefail

# Print a trace of simple commands and their arguments after they are expanded and before they are executed.
set -x

if [[ ! -x $(command -v poetry) ]]; then
    curl -sSL https://install.python-poetry.org | python3 -
else
    echo "[INFO] poetry is already installed."
fi
