#!/usr/bin/env bash

# Exit on an Error or if an Unset variable is referenced.
set -eu

# When used in combination with set -e, pipefail will make a script exit if any command in a pipeline errors.
set -o pipefail

# Print a trace of simple commands and their arguments after they are expanded and before they are executed.
set -x

if [[ ! -x $(command -v tmux) ]]; then
    # tmux dependencies
    # https://github.com/tmux/tmux/wiki/Installing#from-source-tarball
    sudo apt-get install -yq libevent-dev ncurses-dev build-essential bison pkg-config automake

    # build tmux 3 from source
    LATEST_TAG=$(git ls-remote --tags --sort="v:refname" https://github.com/tmux/tmux.git | tail -n1 | sed 's/.*\///; s/\^{}//')
    git clone --depth 1 --branch "$LATEST_TAG" https://github.com/tmux/tmux.git /tmp/tmux
    cd /tmp/tmux
    sh autogen.sh
    ./configure
    make && sudo make install

    rm -rf /tmp/tmux
else
    echo "[INFO] tmux is already installed."
fi
