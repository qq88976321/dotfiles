#!/usr/bin/env bash

# Exit on an Error or if an Unset variable is referenced.
set -eu

# When used in combination with set -e, pipefail will make a script exit if any command in a pipeline errors.
set -o pipefail

# Print a trace of simple commands and their arguments after they are expanded and before they are executed.
set -x

if [[ ! -x $(command -v interactive-rebase-tool) ]]; then
    # ref: https://github.com/MitMaro/git-interactive-rebase-tool/blob/master/readme/install.md

    LATEST_TAG=$(git ls-remote --tags --sort="v:refname" https://github.com/MitMaro/git-interactive-rebase-tool.git '[0-9]*.[0-9]*.[0-9]*' | tail -n1 | sed 's/.*\///; s/\^{}//')

    DIST_ID=$(lsb_release --id --short | awk '{print tolower($0)}')
    DIST_RELEASE=$(lsb_release --release --short)
    PKG_NAME=git-interactive-rebase-tool-"$LATEST_TAG"-"$DIST_ID"-"$DIST_RELEASE"_amd64.deb

    # FIXME: debian package for ubuntu 22.04 haven't been released, however 20.04 seems work better than latest build?
    if [[ "$DIST_ID" = "ubuntu" ]] && [[ "$DIST_RELEASE" = "22.04" ]]; then
        PKG_NAME=git-interactive-rebase-tool-"$LATEST_TAG"-"$DIST_ID"-20.04_amd64.deb
    fi

    curl -fsSL https://github.com/mitmaro/git-interactive-rebase-tool/releases/download/"$LATEST_TAG"/"$PKG_NAME" --output /tmp/"$PKG_NAME"
    sudo dpkg -i /tmp/"$PKG_NAME"
else
    echo "[INFO] interactive-rebase-tool is already installed."
fi
