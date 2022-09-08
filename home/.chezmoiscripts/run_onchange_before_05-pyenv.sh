#!/usr/bin/env bash

# Exit on an Error or if an Unset variable is referenced.
set -eu

# When used in combination with set -e, pipefail will make a script exit if any command in a pipeline errors.
set -o pipefail

# Print a trace of simple commands and their arguments after they are expanded and before they are executed.
set -x


if [[ ! -x $(command -v pyenv) ]]; then
    LATEST_TAG=$(git ls-remote --tags --sort="v:refname" https://github.com/pyenv/pyenv.git 'v[0-9]*.[0-9]*.[0-9]*' | tail -n1 | sed 's/.*\///; s/\^{}//')
    curl https://pyenv.run | PYENV_GIT_TAG=$LATEST_TAG bash
else
    echo "[INFO] pyenv is already installed."
fi


