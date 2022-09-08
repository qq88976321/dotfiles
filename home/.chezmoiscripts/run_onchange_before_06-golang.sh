#!/usr/bin/env bash

# Exit on an Error or if an Unset variable is referenced.
set -eu

# When used in combination with set -e, pipefail will make a script exit if any command in a pipeline errors.
set -o pipefail

# Print a trace of simple commands and their arguments after they are expanded and before they are executed.
set -x

if [[ ! -x $(command -v go) ]]; then
    LATEST_VERSION=$(curl "https://go.dev/VERSION?m=text")
    DOWNLOAD_LINK="https://dl.google.com/go/$LATEST_VERSION.linux-amd64.tar.gz"
    rm -rf /usr/local/go && wget -O- "$DOWNLOAD_LINK" | sudo tar -C /usr/local -xzf -
else
    echo "[INFO] go is already installed."
fi
