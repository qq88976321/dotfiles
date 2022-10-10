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

    # Suggested build environment
    # https://github.com/pyenv/pyenv/wiki#suggested-build-environment
    sudo apt-get update
    sudo apt-get install make build-essential libssl-dev zlib1g-dev \
        libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm \
        libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev
else
    echo "[INFO] pyenv is already installed."
fi
