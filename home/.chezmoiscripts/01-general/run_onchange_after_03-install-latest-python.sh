#!/usr/bin/env bash

# Exit on an Error or if an Unset variable is referenced.
set -eu

# When used in combination with set -e, pipefail will make a script exit if any command in a pipeline errors.
set -o pipefail

# Print a trace of simple commands and their arguments after they are expanded and before they are executed.
set -x

# Set up shell environment for pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"

# Set up default python version to the latest stable version
VERSION=$(pyenv install --list | grep "^\s*[0-9]*.[0-9]*.[0-9]*$" | tail -n 1 | sed 's/ //g')
pyenv install "$VERSION"
pyenv global "$VERSION"
