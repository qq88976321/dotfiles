# Bootstrap a New Machine

Manual setup steps for a fresh Debian-based machine (Ubuntu / Kubuntu).

These steps are intentionally NOT automated with `.chezmoiscripts`: they need
sudo, change system state, or change so rarely that maintaining install
scripts costs more than running a few commands by hand. The old scripts are
kept in [`archived/`](../archived) for reference.

Division of labor:

- **apt** (`docs/pkglist`): system packages and build dependencies
- **chezmoi**: dotfiles, plus oh-my-zsh / powerlevel10k / zsh plugins /
  vim-plug via `.chezmoiexternal.toml`
- **mise** (`~/.config/mise/config.toml`): all CLI dev tools (fd, fzf, rg,
  go, node, python, neovim, atuin, just, k9s, ...)
- **this document**: the remaining one-off steps (docker, chsh, self-built
  tools, fonts)

## 1. Base packages

```sh
grep -v '^#' docs/pkglist | xargs sudo apt-get install -y
```

## 2. Dotfiles

```sh
sh -c "$(curl -fsLS https://chezmoi.io/get)" -- init --apply qq88976321
```

This also pulls oh-my-zsh, powerlevel10k, zsh plugins, and vim-plug
(declared in `home/.chezmoiexternal.toml`). Vim plugins install themselves
automatically on the first vim startup.

The one-off chezmoi binary downloaded here is temporary; the mise-managed
chezmoi from step 4 takes over afterwards.

## 3. Default shell

```sh
chsh -s "$(which zsh)"
```

Log out and back in for the change to take effect.

## 4. Dev tools (mise)

```sh
curl https://mise.run | sh
mise install
```

Shell activation is already wired up in `.zshrc`. The tool list lives in
`~/.config/mise/config.toml` (managed by chezmoi in step 2).

## 5. Docker

Follow the official apt repository setup:
<https://docs.docker.com/engine/install/ubuntu/>

Then allow running docker without sudo:

```sh
sudo usermod -aG docker "$(id -nu)"
```

## 6. Self-built tools

### tmux

Intentionally not managed by mise or apt: prebuilt binaries do not emit
OSC 52, which breaks clipboard integration over ssh. See
[clipboard-osc52.md](clipboard-osc52.md).

```sh
sudo apt-get install -y libevent-dev libncurses-dev bison autotools-dev automake
git clone https://github.com/tmux/tmux.git /tmp/tmux
cd /tmp/tmux && git checkout <latest-release-tag>
sh autogen.sh && ./configure && make -j"$(nproc)"
sudo make install   # installs to /usr/local/bin/tmux
```

### diff-highlight

Used by tig (`set diff-highlight = true` in `.tigrc`). Shipped in git's
contrib directory but not packaged by Debian:

```sh
git clone --depth 1 https://github.com/git/git.git /tmp/git
cd /tmp/git/contrib/diff-highlight && make diff-highlight
install diff-highlight ~/.local/bin
```

### git-interactive-rebase-tool

Used as `sequence.editor` in `.gitconfig`. Download the latest deb from
<https://github.com/MitMaro/git-interactive-rebase-tool/releases> and:

```sh
sudo dpkg -i git-interactive-rebase-tool-*.deb
```

## 7. Fonts

powerlevel10k expects MesloLGS NF:

```sh
mkdir -p ~/.local/share/fonts
cd ~/.local/share/fonts
for style in Regular Bold Italic "Bold Italic"; do
    curl -fsSL "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20${style// /%20}.ttf" \
        --output "MesloLGS NF ${style}.ttf"
done
fc-cache -f
```

Then set the terminal font to "MesloLGS NF".

## 8. Desktop (optional, i3 setup only)

Skip this whole section on KDE/Kubuntu machines.

```sh
grep -v '^#' docs/pkglist-desktop | xargs sudo apt-get install -y
```

- **vscode**: follow <https://code.visualstudio.com/docs/setup/linux> to add
  the Microsoft apt repository and install `code`.
- **polybar-pulseaudio-control**: single script, drop into `~/.local/bin`:
  <https://github.com/marioortizmanero/polybar-pulseaudio-control>
- **joplin**: official install script:
  <https://joplinapp.org/help/install/#linux>
