# Dotfiles

My linux dotfiles, managed with [chezmoi](https://www.chezmoi.io). Mainly tested on Ubuntu 20.04 Desktop / Server / WSL.

## Requirement

Need `curl` or `wget` to install the `chezmoi` command.

## Quick start

Install the `chezmoi` command and dotfiles from this GitHub dotfile repo on a new machine with a this command:

```sh
# Option 1: installed by curl
$ sh -c "$(curl -fsLS https://chezmoi.io/get)" -- init --apply qq88976321
# Option 2: installed by wget
$ sh -c "$(wget -qO- https://chezmoi.io/get)" -- init --apply qq88976321

# And then fill in prompts or just leave it empty if you don't need it
```
